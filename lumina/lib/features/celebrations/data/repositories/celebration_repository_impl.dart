import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../domain/entities/church_service.dart';
import '../../domain/repositories/i_celebration_repository.dart';
import '../models/church_service_model.dart';
import '../models/service_attendance_model.dart';
import '../../domain/entities/service_attendance.dart';
import 'package:lumina/core/logging/app_logger.dart';
import '../../../../core/services/offline_sync_manager.dart';

class CelebrationRepositoryImpl implements ICelebrationRepository {
  final SupabaseClient _supabase;
  final IsarService _isarService;
  final OfflineSyncManager _syncManager;

  CelebrationRepositoryImpl(
      this._supabase, this._isarService, this._syncManager);

  @override
  Future<List<ChurchService>> getServices(String churchId) async {
    if (!_isarService.isReady) {
      final List<dynamic> data = await _supabase
          .from('church_services')
          .select()
          .eq('church_id', churchId);
      return data.map((json) => ChurchService.fromJson(json)).toList();
    }
    final isar = _isarService.db;

    try {
      final List<dynamic> data = await _supabase
          .from('church_services')
          .select()
          .eq('church_id', churchId);

      await isar.writeTxn(() async {
        for (final json in data) {
          final service = ChurchService.fromJson(json);
          await isar.churchServiceModels.put(
            ChurchServiceModel.fromEntity(service),
          );
        }
      });
    } catch (e, stack) {
      AppLogger.e(
          'Error fetching church services', 'CELEBRATION_REPO', e, stack);
    }

    final models = await isar.churchServiceModels
        .filter()
        .churchIdEqualTo(churchId)
        .isDeletedEqualTo(false)
        .sortByDateDesc()
        .findAll();

    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Stream<List<ChurchService>> watchServices(String churchId) async* {
    if (!_isarService.isReady) {
      yield* _supabase
          .from('church_services')
          .stream(primaryKey: ['id'])
          .eq('church_id', churchId)
          .map((data) =>
              data.map((json) => ChurchService.fromJson(json)).toList());
      return;
    }
    final isar = _isarService.db;
    yield* isar.churchServiceModels
        .filter()
        .churchIdEqualTo(churchId)
        .isDeletedEqualTo(false)
        .sortByDateDesc()
        .watch(fireImmediately: true)
        .map((models) => models.map((e) => e.toEntity()).toList());
  }

  @override
  Future<ChurchService?> getService(String id) async {
    if (!_isarService.isReady) {
      final response = await _supabase
          .from('church_services')
          .select()
          .eq('id', id)
          .single();
      return ChurchService.fromJson(response);
    }
    final isar = _isarService.db;

    try {
      final response = await _supabase
          .from('church_services')
          .select()
          .eq('id', id)
          .single();
      final service = ChurchService.fromJson(response);
      await isar.writeTxn(() async {
        await isar.churchServiceModels.put(
          ChurchServiceModel.fromEntity(service),
        );
      });
      return service;
    } catch (e) {
      AppLogger.e('Failed to fetch/sync service $id', 'CELEBRATION_REPO', e);
    }

    final model =
        await isar.churchServiceModels.filter().remoteIdEqualTo(id).findFirst();
    return model?.toEntity();
  }

  @override
  Future<void> createService(ChurchService service) async {
    if (_isarService.isReady) {
      final isar = _isarService.db;
      final model = ChurchServiceModel.fromEntity(service);

      await isar.writeTxn(() async {
        await isar.churchServiceModels.put(model);
      });
    }

    try {
      final json = service.toJson();
      json.remove('id');
      await _supabase.from('church_services').insert(json);
    } catch (e) {
      AppLogger.w(
          'Failed to create service online, registering for offline sync',
          'CELEBRATION_REPO');
      if (_isarService.isReady) {
        await _syncManager.registerAction(
          entityType: 'church_services',
          action: 'INSERT',
          payload: service.toJson(),
          recordId: service.id,
          churchId: service.churchId,
        );
      }
    }
  }

  @override
  Future<void> updateService(ChurchService service) async {
    if (_isarService.isReady) {
      final isar = _isarService.db;
      final existing = await isar.churchServiceModels
          .filter()
          .remoteIdEqualTo(service.id)
          .findFirst();

      if (existing != null) {
        final model = ChurchServiceModel.fromEntity(service);
        model.isarId = existing.isarId;

        await isar.writeTxn(() async {
          await isar.churchServiceModels.put(model);
        });
      }
    }

    try {
      await _supabase
          .from('church_services')
          .update(service.toJson())
          .eq('id', service.id);
    } catch (e) {
      AppLogger.w(
          'Failed to update service online, registering for offline sync',
          'CELEBRATION_REPO');
      if (_isarService.isReady) {
        await _syncManager.registerAction(
          entityType: 'church_services',
          action: 'UPDATE',
          payload: service.toJson(),
          recordId: service.id,
          churchId: service.churchId,
        );
      }
    }
  }

  @override
  Future<void> deleteService(String id) async {
    if (_isarService.isReady) {
      final isar = _isarService.db;
      final model = await isar.churchServiceModels
          .filter()
          .remoteIdEqualTo(id)
          .findFirst();

      if (model != null) {
        model.isDeleted = true;
        model.isSynced = false;

        await isar.writeTxn(() async {
          await isar.churchServiceModels.put(model);
        });
      }
    }

    try {
      await _supabase.from('church_services').delete().eq('id', id);
    } catch (e) {
      AppLogger.w(
          'Failed to delete service online, registering for offline sync',
          'CELEBRATION_REPO');
      if (_isarService.isReady) {
        String churchId = '';
        try {
          final isar = _isarService.db;
          final model = await isar.churchServiceModels
              .filter()
              .remoteIdEqualTo(id)
              .findFirst();
          churchId = model?.churchId ?? '';
        } catch (e2) {
          AppLogger.d('Could not infer churchId for deleted service $id: $e2');
        }

        await _syncManager.registerAction(
          entityType: 'church_services',
          action: 'DELETE',
          payload: {'id': id},
          recordId: id,
          churchId: churchId,
        );
      }
    }
  }

  @override
  Future<List<ServiceAttendance>> getAttendance(String serviceId) async {
    if (!_isarService.isReady) {
      final List<dynamic> data = await _supabase
          .from('service_attendance')
          .select()
          .eq('service_id', serviceId);
      return data.map((json) => ServiceAttendance.fromJson(json)).toList();
    }
    final isar = _isarService.db;

    try {
      final List<dynamic> data = await _supabase
          .from('service_attendance')
          .select()
          .eq('service_id', serviceId);

      await isar.writeTxn(() async {
        for (final json in data) {
          final attendance = ServiceAttendance.fromJson(json);
          await isar.serviceAttendanceModels.put(
            ServiceAttendanceModel.fromEntity(attendance),
          );
        }
      });
    } catch (e, stack) {
      AppLogger.e(
          'Error syncing service attendance', 'CELEBRATION_REPO', e, stack);
    }

    final models = await isar.serviceAttendanceModels
        .filter()
        .serviceIdEqualTo(serviceId)
        .isDeletedEqualTo(false)
        .findAll();

    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Stream<List<ServiceAttendance>> watchAttendance(String serviceId) async* {
    if (!_isarService.isReady) {
      yield* _supabase
          .from('service_attendance')
          .stream(primaryKey: ['id'])
          .eq('service_id', serviceId)
          .map((data) =>
              data.map((json) => ServiceAttendance.fromJson(json)).toList());
      return;
    }
    final isar = _isarService.db;
    yield* isar.serviceAttendanceModels
        .filter()
        .serviceIdEqualTo(serviceId)
        .isDeletedEqualTo(false)
        .watch(fireImmediately: true)
        .map((models) => models.map((e) => e.toEntity()).toList());
  }

  @override
  Future<void> saveAttendance(List<ServiceAttendance> attendance) async {
    if (_isarService.isReady) {
      final isar = _isarService.db;
      // 1. Sauvegarde locale
      await isar.writeTxn(() async {
        for (final a in attendance) {
          final existing = await isar.serviceAttendanceModels
              .filter()
              .serviceIdEqualTo(a.serviceId)
              .memberIdEqualTo(a.memberId)
              .findFirst();

          final model = ServiceAttendanceModel.fromEntity(a);
          if (existing != null) {
            model.isarId = existing.isarId;
          }
          await isar.serviceAttendanceModels.put(model);
        }
      });
    }

    // 2. Sync Supabase (Best effort)
    try {
      for (final a in attendance) {
        final json = a.toJson();
        // Remove ID if it's temporary (client-side)
        if (a.id.length < 5) json.remove('id');

        await _supabase.from('service_attendance').upsert(
              json,
              onConflict: 'service_id, member_id',
            );
      }
    } catch (e) {
      AppLogger.w('Failed to save attendance online: $e', 'CELEBRATION_REPO');
      // OfflineSyncManager will handle this later if configured
    }
  }

  @override
  Future<List<ServiceAttendance>> getAttendanceByMember(String memberId) async {
    if (!_isarService.isReady) {
      final List<dynamic> data = await _supabase
          .from('service_attendance')
          .select()
          .eq('member_id', memberId);
      return data.map((json) => ServiceAttendance.fromJson(json)).toList();
    }
    final isar = _isarService.db;

    try {
      final List<dynamic> data = await _supabase
          .from('service_attendance')
          .select()
          .eq('member_id', memberId);

      await isar.writeTxn(() async {
        for (final json in data) {
          final attendance = ServiceAttendance.fromJson(json);
          await isar.serviceAttendanceModels.put(
            ServiceAttendanceModel.fromEntity(attendance),
          );
        }
      });
    } catch (e, stack) {
      AppLogger.e(
          'Error getting celebration summary', 'CELEBRATION_REPO', e, stack);
    }

    final models = await isar.serviceAttendanceModels
        .filter()
        .memberIdEqualTo(memberId)
        .isDeletedEqualTo(false)
        .findAll();

    return models.map((e) => e.toEntity()).toList();
  }
}