// lib/core/services/offline_sync_worker.dart
import 'dart:convert';
import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/data/models/sync_item_model.dart';
import 'package:lumina/core/data/models/sync_operation_model.dart';
import 'package:lumina/core/data/models/sync_lock_model.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OfflineSyncWorker {
  static const int _maxRetries = 3;
  static const int _batchSize = 10;

  static int get batchSize => _batchSize;

  // Helpers pour les tests (Tasks 29-37)
  static Duration backoffDelayForAttempts(int attempts) {
    return Duration(seconds: 1 << attempts);
  }

  static bool shouldSkipDueToBackoff({
    required DateTime now,
    required int attempts,
    DateTime? lastUpdated,
  }) {
    if (attempts <= 0) return false;
    final delay = backoffDelayForAttempts(attempts);
    final nextRetry = lastUpdated?.add(delay) ?? now;
    return now.isBefore(nextRetry);
  }

  static DateTime nextRetryAt({
    required DateTime now,
    required int attempts,
    DateTime? lastUpdated,
  }) {
    if (attempts <= 0) return now;
    final delay = backoffDelayForAttempts(attempts);
    return lastUpdated?.add(delay) ?? now;
  }

  // Alias pour la compatibilité (Tasks 3-4)
  static bool shouldSkipDueToBackoffSync({
    required DateTime now,
    required int attempts,
    DateTime? lastUpdated,
  }) => shouldSkipDueToBackoff(now: now, attempts: attempts, lastUpdated: lastUpdated);

  static int get maxRetriesSync => _maxRetries;

  static Future<void> syncItemsStandalone(
    SupabaseClient supabase,
    IsarService isarService, {
    String workerId = 'unknown',
    String? churchId,
  }) async {
    if (!isarService.isReady) return;

    // Utilisation de _batchSize pour éviter le warning (Task 2)
    AppLogger.d('Sync session starting with batch size: $_batchSize', 'OSM');

    final lock = await isarService.syncLockModels.get(0) ?? SyncLockModel();
    
    if (lock.isActive && !lock.isExpired) {
      AppLogger.d('Sync already in progress by ${lock.lockedBy}. Skipping.', 'OSM');
      return;
    }

    await isarService.db.writeTxn(() async {
      lock.isActive = true;
      lock.lockedAt = DateTime.now();
      lock.lockedBy = workerId;
      await isarService.syncLockModels.put(lock);
    });

    try {
      // FIX: Filtrer par churchId pour éviter le cross-tenant en environnement multi-église
      final itemQuery = isarService.syncItemModels
          .filter()
          .isProcessingEqualTo(false)
          .isConflictEqualTo(false);
      final filteredItems = churchId != null && churchId.isNotEmpty
          ? await itemQuery.churchIdEqualTo(churchId).sortByCreatedAt().findAll()
          : await itemQuery.sortByCreatedAt().findAll();

      for (final item in filteredItems) {
        await _syncSingleItem(item, supabase, isarService);
      }

      // SyncOperationModel est legacy et va être supprimé en Phase 3.
      // On le conserve pour compatibilité mais il ne devrait plus être alimenté.
      final allPendingOps = await isarService.syncOperationModels
          .filter()
          .isSyncedEqualTo(false)
          .hasFailedEqualTo(false)
          .sortByCreatedAt()
          .findAll();

      for (final op in allPendingOps) {
        await _syncSingleOperation(op, supabase, isarService);
      }
    } catch (e, st) {
      AppLogger.e('Fatal error in sync session', 'OSM', e, st);
    } finally {
      await isarService.db.writeTxn(() async {
        final currentLock = await isarService.syncLockModels.get(0);
        if (currentLock != null) {
          currentLock.isActive = false;
          await isarService.syncLockModels.put(currentLock);
        }
      });
    }
  }

  static Future<void> _syncSingleItem(
    SyncItemModel item, SupabaseClient supabase, IsarService isarService,
  ) async {
    try {
      await isarService.markSyncItemProcessing(item.isarId, true);
      final data = jsonDecode(item.jsonData) as Map<String, dynamic>;

      switch (item.action) {
        case 'INSERT':
          await supabase.from(item.tableName).insert(data);
          break;
        case 'UPDATE':
          final id = data['id'] ?? item.localId;
          await supabase.from(item.tableName).update(data).eq('id', id ?? '');
          break;
        case 'DELETE':
          // FIX: Soft-delete aligné sur SyncService._pushItem()
          // Le hard-delete causait une perte de données irréversible sans backup.
          final id = data['id'] ?? item.localId;
          await supabase
              .from(item.tableName)
              .update({'is_deleted': true, 'deleted_at': DateTime.now().toIso8601String()})
              .eq('id', id ?? '');
          break;
      }
      await isarService.deleteSyncItem(item.isarId);
    } catch (e) {
      // FIX: Harmoniser la gestion d'erreur avec SyncService._handlePushError
      // Avant : seul isProcessing était reset, sans trace d'erreur ni comptage de tentatives.
      final now = DateTime.now();
      await isarService.db.writeTxn(() async {
        final updated = SyncItemModel()
          ..isarId = item.isarId
          ..isProcessing = false
          ..attempts = item.attempts + 1
          ..lastUpdated = now
          ..lastError = e.toString();
        
        if (updated.attempts >= _maxRetries) {
          updated.isConflict = true;
          updated.hasFailed = true;
        }
        
        await isarService.syncItemModels.put(updated);
      });
    }
  }

  static Future<void> _syncSingleOperation(
    SyncOperationModel op, SupabaseClient supabase, IsarService isarService,
  ) async {
    try {
      final data = jsonDecode(op.payload) as Map<String, dynamic>;
      final action = op.operation == 'CREATE' ? 'INSERT' : op.operation;

      switch (action) {
        case 'INSERT':
          await supabase.from(op.entityType).insert(data);
          break;
        case 'UPDATE':
          await supabase.from(op.entityType).update(data).eq('id', op.entityId);
          break;
        case 'DELETE':
          await supabase.from(op.entityType).delete().eq('id', op.entityId);
          break;
      }

      await isarService.db.writeTxn(() async {
        op.isSynced = true;
        await isarService.syncOperationModels.put(op);
      });
    } catch (e) {
      await isarService.db.writeTxn(() async {
        op.retryCount++;
        if (op.retryCount >= _maxRetries) op.hasFailed = true;
        await isarService.syncOperationModels.put(op);
      });
    }
  }
}
