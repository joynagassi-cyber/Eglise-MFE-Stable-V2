import 'dart:async';
import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:lumina/core/api/supabase_service.dart';
import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/data/models/sync_item_model.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:lumina/core/services/device_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'offline_sync_worker.dart';

part 'offline_sync_manager.g.dart';

@Riverpod(keepAlive: true)
OfflineSyncManager offlineSyncManager(OfflineSyncManagerRef ref) {
  final isar = ref.watch(isarServiceProvider);
  final supabase = ref.watch(supabaseServiceProvider).valueOrNull;
  final device = ref.watch(deviceServiceProvider);

  if (supabase == null) {
    throw Exception(
        'SupabaseService must be initialized before OfflineSyncManager');
  }

  return OfflineSyncManager(isar, supabase, device);
}

@riverpod
Stream<bool> isRecordPending(IsRecordPendingRef ref, String recordId) {
  final syncManager = ref.watch(offlineSyncManagerProvider);
  return syncManager.watchIsRecordPending(recordId);
}

/// Gestionnaire de synchronisation offline (IMAGIR)
/// Gère la queue de mutations et la synchronisation transactionnelle
class OfflineSyncManager extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  final IsarService _isarService;
  final SupabaseClient _supabase;
  final DeviceService _deviceService;

  bool _isOnline = true;
  bool _isSyncing = false;
  int _pendingCount = 0;
  DateTime? _lastSyncAt;
  String? _lastError;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  OfflineSyncManager(this._isarService, this._supabase, this._deviceService);

  bool get isOnline => _isOnline;
  bool get isSyncing => _isSyncing;
  int get pendingCount => _pendingCount;
  DateTime? get lastSyncAt => _lastSyncAt;
  String? get lastError => _lastError;
  bool get hasPendingChanges => _pendingCount > 0;

  /// Initialise le manager et écoute les changements de connectivité
  Future<void> initialize() async {
    if (!_isarService.isReady) {
      AppLogger.w(
          'Isar not ready, sync manager will run in degraded mode', 'OSM');
      return;
    }

    // CRITICAL FIX: Add timeout to connectivity check to prevent hanging
    try {
      final results = await _connectivity.checkConnectivity().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          AppLogger.w('Connectivity check timeout', 'OSM');
          // Assume offline on timeout
          return List<ConnectivityResult>.empty();
        },
      );
      _updateConnectivity(results);
    } catch (e) {
      AppLogger.e('Connectivity check failed: $e', 'OSM', e);
      // Continue with offline state as fallback
      _isOnline = false;
    }

    // Reset stuck items (processing=true but app restarted)
    try {
      await _resetStuckItems().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          AppLogger.w('Reset stuck items timeout', 'OSM');
        },
      );
    } catch (e) {
      AppLogger.e('Failed to reset stuck items: $e', 'OSM', e);
    }

    // Charger le compte initial des items en attente
    try {
      await _refreshPendingCount().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          AppLogger.w('Refresh pending count timeout', 'OSM');
        },
      );
    } catch (e) {
      AppLogger.e('Failed to refresh pending count: $e', 'OSM', e);
    }

    // Écouter les changements
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectivity,
    );

    AppLogger.i(
        'OfflineSyncManager initialized (Online: $_isOnline, Pending: $_pendingCount)',
        'OSM');
  }

  /// Réinitialise les items marqués comme "en cours" au démarrage
  Future<void> _resetStuckItems() async {
    if (!_isarService.isReady) return;
    final stuckItems = await _isarService.db.syncItemModels
        .filter()
        .isProcessingEqualTo(true)
        .findAll();

    if (stuckItems.isNotEmpty) {
      AppLogger.w('Resetting ${stuckItems.length} stuck items', 'OSM');
      await _isarService.db.writeTxn(() async {
        for (final item in stuckItems) {
          item.isProcessing = false;
          await _isarService.db.syncItemModels.put(item);
        }
      });
    }
  }

  Future<void> _refreshPendingCount() async {
    final pendingItems = await _isarService.getPendingSyncItems();
    _pendingCount = pendingItems.length;
    notifyListeners();
  }

  void _updateConnectivity(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    _isOnline =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);

    if (_isOnline != wasOnline) {
      AppLogger.i(
          'Connectivity changed: ${_isOnline ? "ONLINE" : "OFFLINE"}', 'OSM');
      notifyListeners();

      // Si on repasse en ligne et qu'il y a des changements en attente
      if (_isOnline && hasPendingChanges) {
        _triggerSync();
      }
    }
  }

  /// Ajoute une mutation à la queue de synchronisation (Architecture IMAGIR)
  ///
  /// [churchId] est **obligatoire** pour garantir le déterminisme multi-église.
  /// Chaque mutation est atomiquement liée à son église d'origine.
  Future<void> registerAction({
    required String entityType,
    required String action, // 'INSERT', 'UPDATE', 'DELETE'
    required Map<String, dynamic> payload,
    required String churchId,
    String? recordId,
  }) async {
    // Garde-fou déterministe : aucune mutation sans contexte d'église
    assert(churchId.isNotEmpty, 'churchId cannot be empty in registerAction');
    if (churchId.isEmpty) {
      AppLogger.e(
          'CRITICAL: registerAction called with empty churchId for $entityType ($action). Mutation rejected.',
          'OSM');
      return;
    }

    // NOTE: In a full architecture, we should inject the active church ID and isSuperAdmin here to verify.
    // For now, enforcing churchId is present is a major step. Wait, let's read it from the saved session or Riverpod context.
    // Since OfflineSyncManager doesn't have direct access to ref inside this method without being passed,
    // we assume the Caller has verified the active church, OR we can check it if we inject ref.

    // FIX CRITIQUE: Les champs late String operationId, deviceId, userId sont obligatoires
    // dans SyncItemModel. Sans eux, un LateInitializationError crash le sync au premier read.
    // On les hydrate ici avec les mêmes sources que SyncService.enqueueOperation().
    final deviceId = await _deviceService.getDeviceId();
    final userId = _supabase.auth.currentUser?.id ?? 'anonymous';
    final operationId =
        '${DateTime.now().millisecondsSinceEpoch}_$entityType${action.toLowerCase()}';

    final item = SyncItemModel()
      ..tableName = entityType
      ..action = action
      ..jsonData = jsonEncode(payload)
      ..createdAt = DateTime.now()
      ..localId = recordId ?? payload['id']?.toString()
      ..churchId = churchId
      ..operationId = operationId
      ..deviceId = deviceId
      ..userId = userId;

    await _isarService.queueSyncItem(item);

    await _refreshPendingCount();

    AppLogger.d(
        'Mutation queued for ${item.tableName} ($action) - Church: $churchId',
        'OSM');

    // Si en ligne, synchroniser immédiatement en passant le churchId pour filtrer
    if (_isOnline) {
      unawaited(_triggerSync(churchId: churchId));
    }
  }

  // _getCurrentActiveChurchId() SUPPRIMÉE (Phase A - D-Sync)
  // Le churchId est désormais obligatoire dans registerAction.
  // Aucune déduction probabiliste n'est tolérée.

  /// Force la synchronisation de toutes les mutations en attente
  Future<void> _triggerSync({String? churchId}) async {
    if (_isSyncing || !_isOnline) return;

    _isSyncing = true;
    _lastError = null;
    notifyListeners();

    try {
      // FIX: On rafraîchit le pending count AVANT et APRÈS pour plus de précision UI
      await syncItemsStandalone(_supabase, _isarService, churchId: churchId);
      _lastSyncAt = DateTime.now();
    } catch (e, st) {
      _lastError = e.toString();
      AppLogger.e('Sync process triggered exception: $e', 'OSM', e, st);
    } finally {
      _isSyncing = false;
      await _refreshPendingCount();
    }
  }

  static Future<void> syncItemsStandalone(
    SupabaseClient supabase,
    IsarService isarService, {
    String workerId = 'unknown',
    String? churchId,
  }) {
    return OfflineSyncWorker.syncItemsStandalone(supabase, isarService,
        workerId: workerId, churchId: churchId);
  }

  /// Force une synchronisation manuelle
  Future<void> forceSync() async {
    if (!_isOnline) {
      throw Exception('Impossible de synchroniser en mode hors ligne');
    }
    await _triggerSync();
  }

  /// Retourne un résumé de l'état de synchronisation
  SyncStatus getStatus() {
    if (!_isOnline) {
      return SyncStatus.offline;
    }
    if (_isSyncing) {
      return SyncStatus.syncing;
    }
    if (_pendingCount > 0) {
      return SyncStatus.pending;
    }
    return SyncStatus.synced;
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    AppLogger.d('OfflineSyncManager disposed', 'OSM');
    super.dispose();
  }

  /// Observe si un enregistrement spécifique est en attente de synchro
  Stream<bool> watchIsRecordPending(String recordId) {
    if (!_isarService.isReady) return Stream.value(false);
    return _isarService.db.syncItemModels
        .where()
        .filter()
        .localIdEqualTo(recordId)
        .watch(fireImmediately: true)
        .map((items) => items.isNotEmpty);
  }
}

/// États possibles de synchronisation
enum SyncStatus {
  offline,
  syncing,
  pending,
  synced;

  String get label {
    switch (this) {
      case SyncStatus.offline:
        return 'Hors ligne';
      case SyncStatus.syncing:
        return 'Synchronisation...';
      case SyncStatus.pending:
        return 'En attente';
      case SyncStatus.synced:
        return 'Synchronisé';
    }
  }

  bool get isHealthy => this == SyncStatus.synced;
}
