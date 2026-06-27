// lib/core/services/sync_service.dart
// Service central de synchronisation Lumina — Architecture IMAGIR
//
// Responsabilités :
//   - PUSH  : vider l'outbox (SyncItemModel) vers Supabase
//   - PULL  : récupérer les changements distants et les appliquer à Isar
//   - Résolution de conflits : Last-Write-Wins (version + updatedAt)
//   - Isolation multi-tenant  : toujours filtré par churchId (RLS enforced)
//   - Watermark de pull       : lastSyncedAt par table, persisté dans Isar

import 'dart:async';
import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/data/models/sync_item_model.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:lumina/core/monitoring/sentry_stub.dart';
import 'package:lumina/core/services/device_service.dart';

import 'offline_sync_worker.dart';

part 'sync_service.g.dart';

// ---------------------------------------------------------------------------
// Provider Riverpod
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
SyncService syncService(SyncServiceRef ref) {
  final isar = ref.watch(isarServiceProvider);
  final supabase = ref.watch(supabaseClientProvider);
  final device = ref.watch(deviceServiceProvider);
  return SyncService(isar: isar, supabase: supabase, deviceService: device);
}

/// Provider léger renvoyant le client Supabase — overridable en test
@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(SupabaseClientRef ref) =>
    Supabase.instance.client;

// ---------------------------------------------------------------------------
// Constantes
// ---------------------------------------------------------------------------

const _tag = 'SYNC';
const _defaultBatchSize = 20;
const _defaultTimeout = Duration(seconds: 30);

/// Tables gérées par le Pull différentiel.
/// Ordre : d'abord les entités indépendantes, ensuite celles qui en dépendent.
const _pullableTables = [
  SyncTable(name: 'groups', watermarkKey: 'groups'),
  SyncTable(name: 'members', watermarkKey: 'members'),
  SyncTable(name: 'finance_transactions', watermarkKey: 'finance_transactions'),
  SyncTable(name: 'sacraments', watermarkKey: 'sacraments'),
  SyncTable(name: 'annonces', watermarkKey: 'annonces'),
  SyncTable(name: 'events', watermarkKey: 'events'),
  SyncTable(name: 'group_memberships', watermarkKey: 'group_memberships'),
  SyncTable(name: 'budgets', watermarkKey: 'budgets'),
];

// ---------------------------------------------------------------------------
// Modèles internes
// ---------------------------------------------------------------------------

/// Décrit une table synchronisable côté Pull.
class SyncTable {
  final String name;
  final String watermarkKey;
  const SyncTable({required this.name, required this.watermarkKey});
}

/// Résultat d'une session de synchronisation complète.
class SyncResult {
  final int pushed;
  final int pulled;
  final int conflicts;
  final List<String> errors;
  final DateTime completedAt;

  const SyncResult({
    required this.pushed,
    required this.pulled,
    required this.conflicts,
    required this.errors,
    required this.completedAt,
  });

  bool get hasErrors => errors.isNotEmpty;

  @override
  String toString() =>
      'SyncResult(pushed: $pushed, pulled: $pulled, conflicts: $conflicts, '
      'errors: ${errors.length}, at: $completedAt)';
}

// ---------------------------------------------------------------------------
// SyncService
// ---------------------------------------------------------------------------

/// Service central de synchronisation offline/online pour Lumina.
///
/// Usage :
/// ```dart
/// final result = await ref.read(syncServiceProvider).fullSync(churchId: id);
/// ```
class SyncService {
  final IsarService _isar;
  final SupabaseClient _supabase;
  final DeviceService _device;

  SyncService({
    required IsarService isar,
    required SupabaseClient supabase,
    required DeviceService deviceService,
  })  : _isar = isar,
        _supabase = supabase,
        _device = deviceService;

  // -------------------------------------------------------------------------
  // API Publique
  // -------------------------------------------------------------------------

  /// Synchronisation complète : Push puis Pull pour une église donnée.
  ///
  /// [churchId] est **obligatoire** — toute tentative sans churchId est rejetée.
  Future<SyncResult> fullSync({required String churchId}) async {
    _assertChurchId(churchId);
    AppLogger.i('Starting full sync for church: $churchId', _tag);

    int pushed = 0;
    int pulled = 0;
    int conflicts = 0;
    final errors = <String>[];

    // --- Phase 1 : PUSH ---
    try {
      pushed = await _pushOutbox(churchId: churchId);
    } catch (e, st) {
      final msg = 'Push phase failed: $e';
      errors.add(msg);
      AppLogger.e(msg, _tag, e, st);
      await Sentry.captureException(e, stackTrace: st);
    }

    // --- Phase 2 : PULL ---
    try {
      final pullStats = await _pullAll(churchId: churchId);
      pulled = pullStats.$1;
      conflicts = pullStats.$2;
    } catch (e, st) {
      final msg = 'Pull phase failed: $e';
      errors.add(msg);
      AppLogger.e(msg, _tag, e, st);
      await Sentry.captureException(e, stackTrace: st);
    }

    final result = SyncResult(
      pushed: pushed,
      pulled: pulled,
      conflicts: conflicts,
      errors: errors,
      completedAt: DateTime.now().toUtc(),
    );

    AppLogger.i('Sync complete — $result', _tag);
    await Sentry.addBreadcrumb(Breadcrumb(
      message: 'Full sync completed',
      category: 'sync',
      data: {
        'church_id': churchId,
        'pushed': pushed,
        'pulled': pulled,
        'conflicts': conflicts,
        'has_errors': result.hasErrors,
      },
    ));

    return result;
  }

  /// Push uniquement — vider l'outbox vers Supabase.
  Future<int> pushOnly({required String churchId}) async {
    _assertChurchId(churchId);
    return _pushOutbox(churchId: churchId);
  }

  /// Pull uniquement — récupérer les nouveautés depuis Supabase.
  Future<int> pullOnly({required String churchId}) async {
    _assertChurchId(churchId);
    final stats = await _pullAll(churchId: churchId);
    return stats.$1;
  }

  /// Enregistre une opération locale dans l'outbox (SyncItemModel).
  ///
  /// À appeler depuis chaque repository après toute mutation locale.
  Future<void> enqueueOperation({
    required String tableName,
    required String action, // 'INSERT' | 'UPDATE' | 'DELETE'
    required Map<String, dynamic> payload,
    required String churchId,
    String? recordId,
  }) async {
    _assertChurchId(churchId);

    final deviceId = await _device.getDeviceId();
    final operationId =
        '${DateTime.now().millisecondsSinceEpoch}_${tableName}_${action.toLowerCase()}';

    final item = SyncItemModel()
      ..tableName = tableName
      ..action = action
      ..jsonData = jsonEncode(payload)
      ..createdAt = DateTime.now().toUtc()
      ..localId = recordId ?? payload['id']?.toString()
      ..churchId = churchId
      ..operationId = operationId
      ..deviceId = deviceId
      ..userId = _supabase.auth.currentUser?.id ?? 'anonymous';

    await _isar.queueSyncItem(item);

    AppLogger.d(
      'Enqueued $action on $tableName (op: $operationId, church: $churchId)',
      _tag,
    );
  }

  // -------------------------------------------------------------------------
  // Phase PUSH — Outbox → Supabase
  // -------------------------------------------------------------------------

  /// Vide l'outbox par batches. Retourne le nombre d'items synchronisés.
  Future<int> _pushOutbox({required String churchId}) async {
    if (!_isar.isReady) return 0;

    // Réutilise OfflineSyncWorker existant (éprouvé) pour le push
    // mais filtre les items de cette église uniquement.
    final pending = await _isar.syncItemModels
        .where()
        .churchIdEqualTo(churchId)
        .filter()
        .isProcessingEqualTo(false)
        .isConflictEqualTo(false)
        .sortByCreatedAt()
        .findAll();

    if (pending.isEmpty) return 0;

    AppLogger.i('Push: ${pending.length} items pending for $churchId', _tag);

    int synced = 0;
    for (int i = 0; i < pending.length; i += _defaultBatchSize) {
       final batch = pending.skip(i).take(_defaultBatchSize).toList();
       final results = await Future.wait(
        batch.map((item) => _pushItem(item)),
        eagerError: false,
      );
      synced += results.where((ok) => ok).length;
    }

    return synced;
  }

  /// Pousse un seul item. Retourne `true` en cas de succès.
  Future<bool> _pushItem(SyncItemModel item) async {
    final now = DateTime.now();
    if (OfflineSyncWorker.shouldSkipDueToBackoffSync(
      now: now,
      attempts: item.attempts,
      lastUpdated: item.lastUpdated,
    )) {
      return false;
    }

    try {
      await _isar.markSyncItemProcessing(item.isarId, true);
      final data = jsonDecode(item.jsonData) as Map<String, dynamic>;

      // Garantir l'isolation : injecter churchId dans le payload si absent
      if (!data.containsKey('church_id') && item.churchId != null) {
        data['church_id'] = item.churchId;
      }

      switch (item.action) {
        case 'INSERT':
          await _supabase
              .from(item.tableName)
              .insert(data)
              .timeout(_defaultTimeout);
          break;
        case 'UPDATE':
          final id = data['id'] ?? item.localId;
          if (id == null) throw Exception('Missing ID for UPDATE');
          await _supabase
              .from(item.tableName)
              .update(data)
              .eq('id', id)
              .timeout(_defaultTimeout);
          break;
        case 'DELETE':
          final id = data['id'] ?? item.localId;
          if (id == null) throw Exception('Missing ID for DELETE');
          // Soft-delete : on met is_deleted = true si la table le supporte
          await _supabase
              .from(item.tableName)
              .update({'is_deleted': true, 'deleted_at': DateTime.now().toIso8601String()})
              .eq('id', id)
              .timeout(_defaultTimeout);
          break;
      }

      await _isar.deleteSyncItem(item.isarId);
      return true;
    } on PostgrestException catch (e) {
      await _handlePushConflict(item, e);
      return false;
    } catch (e, st) {
      await _handlePushError(item, e);
      AppLogger.w('Push error item ${item.isarId}: $e', _tag);
      await Sentry.captureException(e, stackTrace: st,
          hint: Hint.withMap({'sync_item_id': item.isarId.toString()}));
      return false;
    }
  }

  /// Gestion du conflit Postgrest (409 / duplicate).
  Future<void> _handlePushConflict(
      SyncItemModel item, PostgrestException e) async {
    final isConflict = e.code == '409' ||
        e.code == '23505' || // unique_violation
        e.message.contains('conflict') ||
        e.message.contains('duplicate');

    if (!isConflict) {
      await _handlePushError(item, e);
      return;
    }

    AppLogger.w(
        'Conflict on ${item.tableName} [${item.action}] — applying LWW', _tag);

    try {
      final localData = jsonDecode(item.jsonData) as Map<String, dynamic>;
      final id = localData['id'] ?? item.localId;
      if (id == null) throw Exception('No ID for LWW resolution');

      final remote = await _supabase
          .from(item.tableName)
          .select()
          .eq('id', id)
          .maybeSingle()
          .timeout(_defaultTimeout);

      if (remote != null && _localWins(localData, remote)) {
        // Local plus récent → on force l'upsert
        await _supabase
            .from(item.tableName)
            .upsert(localData)
            .timeout(_defaultTimeout);
        AppLogger.i('LWW: local won for ${item.tableName}/$id', _tag);
      } else {
        AppLogger.i('LWW: remote won for ${item.tableName}/$id — discarding local', _tag);
      }

      await _isar.deleteSyncItem(item.isarId);
    } catch (resErr, st) {
      AppLogger.e('Conflict resolution failed: $resErr', _tag, resErr, st);
      await _isar.db.writeTxn(() async {
        item
          ..isProcessing = false
          ..isConflict = true
          ..lastError = 'LWW_FAILED: $resErr';
        await _isar.db.syncItemModels.put(item);
      });
    }
  }

  /// Marque l'item en erreur avec backoff exponentiel.
  Future<void> _handlePushError(SyncItemModel item, Object e) async {
    await _isar.db.writeTxn(() async {
      item
        ..isProcessing = false
        ..attempts = item.attempts + 1
        ..lastUpdated = DateTime.now().toUtc()
        ..lastError = e.toString();

      if (item.attempts >= OfflineSyncWorker.maxRetriesSync) {
        item
          ..isConflict = true
          ..lastError = 'DEAD_LETTER: ${item.lastError}';
        AppLogger.e(
            'Item ${item.isarId} → Dead Letter (${item.tableName})', _tag);
      }
      await _isar.db.syncItemModels.put(item);
    });
  }

  // -------------------------------------------------------------------------
  // Phase PULL — Supabase → Isar (différentiel par watermark)
  // -------------------------------------------------------------------------

  /// Tire les changements pour toutes les tables pullables en parallèle
  /// avec un limitateur de concurrence (max 4 tables simultanées).
  /// Retourne (totalPulled, totalConflicts).
  ///
  /// FIX #4: Pull parallélisé — au lieu de 8 appels séquentiels (8-16s),
  /// les pulls sont exécutés par batch de 4 tables en parallèle (~3-5s total).
  Future<(int, int)> _pullAll({required String churchId}) async {
    if (!_isar.isReady) return (0, 0);

    int totalPulled = 0;
    int totalConflicts = 0;

    const maxConcurrent = 4;
    // ignore: prefer_const_literals_to_create_immutables
    const tables = _pullableTables;

    for (var i = 0; i < tables.length; i += maxConcurrent) {
      final batch = tables.skip(i).take(maxConcurrent).toList();
      final results = await Future.wait(
        batch.map((t) => _pullTable(table: t, churchId: churchId)),
        eagerError: false,
      );
      for (final (pulled, conflicts) in results) {
        totalPulled += pulled;
        totalConflicts += conflicts;
      }
    }

    return (totalPulled, totalConflicts);
  }

  /// Tire les changements d'une seule table depuis le dernier watermark.
  ///
  /// FIX #5: Pagination automatique — boucle do-while avec pageSize=500.
  /// Sans pagination, les lignes au-delà de 500 étaient silencieusement ignorées.
  /// Le watermark n'est avancé qu'après traitement de TOUTES les pages.
  Future<(int, int)> _pullTable({
    required SyncTable table,
    required String churchId,
  }) async {
    final watermark = await _getWatermark(table.watermarkKey, churchId);
    final watermarkStr = watermark?.toIso8601String() ??
        DateTime.fromMillisecondsSinceEpoch(0).toIso8601String();

    AppLogger.d(
        'Pull ${table.name} since $watermarkStr (church: $churchId)', _tag);

    const pageSize = 500;
    int offset = 0;
    int totalPulled = 0;
    int totalConflicts = 0;
    DateTime? maxUpdatedAt;

    bool hasMore;
    do {
      final rows = await _supabase
          .from(table.name)
          .select()
          .eq('church_id', churchId)
          .gte('updated_at', watermarkStr)
          .order('updated_at', ascending: true)
          .range(offset, offset + pageSize - 1)
          .timeout(_defaultTimeout) as List<dynamic>;

      hasMore = rows.length == pageSize;
      offset += pageSize;

      if (rows.isEmpty) break;

      AppLogger.d('Pull ${table.name}: page at offset ${offset - rows.length}, ${rows.length} rows', _tag);

      for (final row in rows) {
        final rowData = row as Map<String, dynamic>;
        try {
          final conflict = await _applyRemoteRow(table: table, row: rowData);
          if (conflict) totalConflicts++;
          totalPulled++;

          final rowUpdatedAt = _parseDateTime(rowData['updated_at']);
          if (rowUpdatedAt != null) {
            if (maxUpdatedAt == null || rowUpdatedAt.isAfter(maxUpdatedAt)) {
              maxUpdatedAt = rowUpdatedAt;
            }
          }
        } catch (e) {
          AppLogger.w('Failed to apply row from ${table.name}: $e', _tag);
        }
      }
    } while (hasMore);

    if (maxUpdatedAt != null) {
      await _setWatermark(table.watermarkKey, churchId, maxUpdatedAt);
    }

    AppLogger.d('Pull ${table.name} done: $totalPulled rows, $totalConflicts conflicts', _tag);
    return (totalPulled, totalConflicts);
  }

  /// Applique une ligne distante dans Isar avec résolution LWW.
  /// Retourne `true` si un conflit a été détecté (mais résolu).
  Future<bool> _applyRemoteRow({
    required SyncTable table,
    required Map<String, dynamic> row,
  }) async {
    // Vérifier s'il existe un item outbox en attente pour cet enregistrement
    final remoteId = row['id']?.toString();
    if (remoteId == null) return false;

    final pendingLocal = await _isar.syncItemModels
        .filter()
        .tableNameEqualTo(table.name)
        .localIdEqualTo(remoteId)
        .isConflictEqualTo(false)
        .findFirst();

    bool hasConflict = false;

    if (pendingLocal != null) {
      // Conflit : on a une mutation locale non poussée ET une mise à jour distante
      final localData =
          jsonDecode(pendingLocal.jsonData) as Map<String, dynamic>;

      if (_localWins(localData, row)) {
        // Local plus récent → on garde la mutation locale, on rejette le pull
        AppLogger.d(
            'Pull LWW: local wins for ${table.name}/$remoteId — skipping remote', _tag);
        return true; // conflit détecté, local prioritaire
      }
      // Remote plus récent → on supprime la mutation obsolète
      hasConflict = true;
      AppLogger.d(
          'Pull LWW: remote wins for ${table.name}/$remoteId — discarding local op', _tag);
      await _isar.deleteSyncItem(pendingLocal.isarId);
    }

    // Appliquer la ligne distante dans Isar via le handler spécifique à la table
    await _persistRemoteRow(tableName: table.name, row: row);

    return hasConflict;
  }

  /// Persiste une ligne distante dans la collection Isar correspondante.
  ///
  /// Chaque table a sa propre logique de mapping.
  /// Les tables non mappées sont ignorées avec un warning.
  Future<void> _persistRemoteRow({
    required String tableName,
    required Map<String, dynamic> row,
  }) async {
    switch (tableName) {
      case 'members':
        await _isar.upsertMemberFromRemote(row);
        break;
      case 'finance_transactions':
        await _isar.upsertFinanceTransactionFromRemote(row);
        break;
      case 'sacraments':
        await _isar.upsertSacramentFromRemote(row);
        break;
      case 'annonces':
        await _isar.upsertAnnonceFromRemote(row);
        break;
      case 'events':
        await _isar.upsertEventFromRemote(row);
        break;
      case 'groups':
        await _isar.upsertGroupFromRemote(row);
        break;
      case 'group_memberships':
        await _isar.upsertGroupMembershipFromRemote(row);
        break;
      case 'budgets':
        await _isar.upsertBudgetFromRemote(row);
        break;
      default:
        AppLogger.w('No Isar handler for table: $tableName — skipped', _tag);
    }
  }

  // -------------------------------------------------------------------------
  // Last-Write-Wins (LWW)
  // -------------------------------------------------------------------------

  /// Retourne `true` si la version locale est plus récente que la distante.
  ///
  /// Stratégie :
  ///   1. Comparer `version` (entier incrémental)
  ///   2. En cas d'égalité, comparer `updated_at`
  bool _localWins(
    Map<String, dynamic> local,
    Map<String, dynamic> remote,
  ) {
    final localVersion = (local['version'] as num?)?.toInt() ?? 0;
    final remoteVersion = (remote['version'] as num?)?.toInt() ?? 0;

    if (localVersion != remoteVersion) return localVersion > remoteVersion;

    final localUpdatedAt = _parseDateTime(local['updated_at']);
    final remoteUpdatedAt = _parseDateTime(remote['updated_at']);

    if (localUpdatedAt == null || remoteUpdatedAt == null) return false;
    return localUpdatedAt.isAfter(remoteUpdatedAt);
  }

  // -------------------------------------------------------------------------
  // Watermark — persisté dans Isar (SessionModel.metadata or Isar KV)
  // -------------------------------------------------------------------------

  /// Clé de watermark : `sync_watermark_{key}_{churchId}`
  String _watermarkKey(String key, String churchId) =>
      'sync_watermark_${key}_$churchId';

  /// Lit le watermark depuis le SessionModel stocké en local.
  Future<DateTime?> _getWatermark(String key, String churchId) async {
    if (!_isar.isReady) return null;
    try {
      final session = await _isar.sessionModels
          .where()
          .findFirst();
      if (session == null) return null;
      final raw = session.getMetadata(_watermarkKey(key, churchId));
      return _parseDateTime(raw);
    } catch (_) {
      return null;
    }
  }

  /// Persiste le watermark dans le SessionModel.
  Future<void> _setWatermark(
      String key, String churchId, DateTime value) async {
    if (!_isar.isReady) return;
    try {
      await _isar.db.writeTxn(() async {
        final session = await _isar.sessionModels.where().findFirst();
        if (session == null) return;
        session.setMetadata(
            _watermarkKey(key, churchId), value.toIso8601String());
        await _isar.sessionModels.put(session);
      });
    } catch (e) {
      AppLogger.w('Failed to persist watermark for $key: $e', _tag);
    }
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  DateTime? _parseDateTime(dynamic raw) {
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString())?.toUtc();
  }

  void _assertChurchId(String churchId) {
    assert(churchId.isNotEmpty, 'churchId must not be empty in SyncService');
    if (churchId.isEmpty) {
      throw ArgumentError('CRITICAL: SyncService called with empty churchId');
    }
  }
}
