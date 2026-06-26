import 'dart:async';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/services/offline_sync_manager.dart';
import '../../../../core/utils/church_filter_mixin.dart';
import '../../domain/entities/app_notification_entity.dart';
import '../../domain/repositories/i_notification_repository.dart';
import '../models/notification_model.dart';
import '../../../../core/utils/app_date_time.dart';

class NotificationRepositoryImpl with ChurchFilterMixin implements INotificationRepository {
  final SupabaseClient _supabase;
  final IsarService _isarService;
  final OfflineSyncManager _syncManager;
  final Ref _ref;

  NotificationRepositoryImpl(this._supabase, this._isarService, this._syncManager, this._ref);

  @override
  Future<List<AppNotificationEntity>> getNotifications({
    int limit = 50,
    int offset = 0,
    bool? isRead,
  }) async {
    if (!_isarService.isReady) {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];
      try {
        final List<dynamic> data = await _supabase
            .from('notifications')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false)
            .range(offset, offset + limit - 1);
        return data.map((json) => AppNotificationEntity.fromJson(json)).toList();
      } catch (e) {
        return [];
      }
    }

    final isar = _isarService.db;
    
    // Remote fetch & sync
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId != null) {
        final List<dynamic> data = await _supabase
            .from('notifications')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false)
            .range(offset, offset + limit - 1);

        await isar.writeTxn(() async {
          for (final json in data) {
            final entity = AppNotificationEntity.fromJson(json);
            final model = NotificationModel.fromEntity(entity)
              ..isSynced = true
              ..lastSyncedAt = AppDateTime.nowUtc();
            await isar.notificationModels.put(model);
          }
        });
      }
    } catch (e) {
      AppLogger.w('Failed to sync notifications', 'NOTIF_REPO');
    }

    final models = await isar.notificationModels
        .where()
        .sortByCreatedAtDesc()
        .offset(offset)
        .limit(limit)
        .findAll();

    var entities = models.map((m) => m.toEntity()).toList();
    if (isRead != null) {
      entities = entities.where((n) => n.isRead == isRead).toList();
    }
    return entities;
  }

  @override
  Future<int> getUnreadCount() async {
    if (!_isarService.isReady) return 0;
    return _isarService.db.notificationModels.filter().isReadEqualTo(false).count();
  }

  @override
  Future<void> markAsRead(String id) async {
    final churchId = getActiveChurchId(_ref);
    
    if (_isarService.isReady) {
      final isar = _isarService.db;
      final model = await isar.notificationModels
          .filter()
          .remoteIdEqualTo(id)
          .findFirst();

      if (model != null) {
        await isar.writeTxn(() async {
          model.isRead = true;
          model.readAt = AppDateTime.nowUtc();
          model.isSynced = false;
          await isar.notificationModels.put(model);
        });

        await _syncManager.registerAction(
          entityType: 'notifications',
          action: 'UPDATE',
          payload: {'id': id, 'is_read': true, 'read_at': AppDateTime.nowIso()},
          churchId: churchId ?? '',
          recordId: id,
        );
      }
    } else {
      await _supabase.from('notifications').update({
        'is_read': true,
        'read_at': AppDateTime.nowIso(),
      }).eq('id', id);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    final churchId = getActiveChurchId(_ref);
    
    if (_isarService.isReady) {
      final isar = _isarService.db;
      final unread =
          await isar.notificationModels.filter().isReadEqualTo(false).findAll();

      if (unread.isEmpty) return;

      await isar.writeTxn(() async {
        for (final model in unread) {
          model.isRead = true;
          model.readAt = AppDateTime.nowUtc();
          model.isSynced = false;
          await isar.notificationModels.put(model);
        }
      });
      
      for (final model in unread) {
        await _syncManager.registerAction(
          entityType: 'notifications',
          action: 'UPDATE',
          payload: {'id': model.remoteId, 'is_read': true, 'read_at': AppDateTime.nowIso()},
          churchId: churchId ?? '',
          recordId: model.remoteId,
        );
      }
    } else {
      final userId = _supabase.auth.currentUser?.id;
      if (userId != null) {
        await _supabase
            .from('notifications')
            .update({
              'is_read': true,
              'read_at': AppDateTime.nowIso(),
            })
            .eq('user_id', userId)
            .eq('is_read', false);
      }
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    final churchId = getActiveChurchId(_ref);
    
    if (_isarService.isReady) {
      final isar = _isarService.db;
      final model = await isar.notificationModels
          .filter()
          .remoteIdEqualTo(id)
          .findFirst();

      if (model != null) {
        await isar.writeTxn(() async {
          await isar.notificationModels.delete(model.isarId);
        });
        
        await _syncManager.registerAction(
          entityType: 'notifications',
          action: 'DELETE',
          payload: {'id': id},
          churchId: churchId ?? '',
          recordId: id,
        );
      }
    } else {
      await _supabase.from('notifications').delete().eq('id', id);
    }
  }

  @override
  Future<void> clearAll() async {
    if (_isarService.isReady) {
      final isar = _isarService.db;
      await isar.writeTxn(() async {
        await isar.notificationModels.clear();
      });
    }

    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId != null) {
        await _supabase.from('notifications').delete().eq('user_id', userId);
      }
    } catch (e) {
      AppLogger.w('Failed to clear notifications remotely', 'NOTIF_REPO');
    }
  }

  @override
  Stream<List<AppNotificationEntity>> watchNotifications() {
    if (!_isarService.isReady) {
      return Stream.fromFuture(_supabase
            .from('notifications')
            .select()
            .order('created_at', ascending: false)
            .limit(50)).map((data) => (data as List).map((json) => AppNotificationEntity.fromJson(json)).toList());
    }

    final controller = StreamController<List<AppNotificationEntity>>();
    
    final isarSubscription = _isarService.db.notificationModels
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .listen((models) {
      controller.add(models.map((m) => m.toEntity()).toList());
    });

    controller.onCancel = () {
      isarSubscription.cancel();
      controller.close();
      AppLogger.d('Closed notifications stream', 'NOTIF_REPO');
    };

    return controller.stream;
  }
}
