import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/features/bergers/domain/entities/shepherd.dart';
import 'package:lumina/features/bergers/domain/entities/pastoral_visit.dart';
import 'package:lumina/features/bergers/domain/repositories/i_shepherd_repository.dart';
import 'package:lumina/features/bergers/data/models/shepherd_model.dart';
import 'package:lumina/features/bergers/data/models/pastoral_visit_model.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';

class ShepherdRepositoryImpl implements IShepherdRepository {
  final SupabaseClient _supabase;
  final IsarService _isar;
  final OfflineSyncManager _syncManager;

  ShepherdRepositoryImpl(this._supabase, this._isar, this._syncManager);

  @override
  Future<List<Shepherd>> getShepherds({String? churchId}) async {
    if (_isar.isReady) {
      var shepherds = await _isar.getAllShepherds();

      if (churchId != null) {
        shepherds = shepherds.where((s) => s.churchId == churchId).toList();
      }

      if (shepherds.isNotEmpty) {
        return shepherds.map((s) => s.toDomain()).toList();
      }
    }

    try {
      var query = _supabase.from('shepherds').select();
      if (churchId != null) {
        query = query.eq('church_id', churchId);
      }
      final records = await query.timeout(const Duration(seconds: 20));
      final list = records.map((json) => Shepherd.fromJson(json)).toList();

      if (_isar.isReady) {
        for (var s in list) {
          await _isar.saveShepherd(ShepherdModel.fromDomain(s));
        }
      }
      return list;
    } catch (e, stack) {
      AppLogger.e('Failed to fetch shepherds', 'ShepherdRepo', e, stack);
      return [];
    }
  }

  @override
  Future<Shepherd?> getShepherdById(String id) async {
    if (_isar.isReady) {
      final shepherds = await _isar.getAllShepherds();
      final model = shepherds.cast<ShepherdModel?>().firstWhere(
            (s) => s?.id == id,
            orElse: () => null,
          );
      if (model != null) return model.toDomain();
    }

    try {
      final response = await _supabase
          .from('shepherds')
          .select()
          .eq('id', id)
          .maybeSingle()
          .timeout(const Duration(seconds: 20));
      if (response == null) return null;
      return Shepherd.fromJson(response);
    } catch (e, stack) {
      AppLogger.e('Failed to fetch shepherd $id', 'ShepherdRepo', e, stack);
      return null;
    }
  }

  @override
  Future<Shepherd?> getShepherdByMemberId(String memberId) async {
    if (_isar.isReady) {
      final shepherds = await _isar.getAllShepherds();
      final model = shepherds.cast<ShepherdModel?>().firstWhere(
            (s) => s?.memberId == memberId,
            orElse: () => null,
          );
      if (model != null) return model.toDomain();
    }

    try {
      final response = await _supabase
          .from('shepherds')
          .select()
          .eq('member_id', memberId)
          .maybeSingle();
      if (response == null) return null;
      return Shepherd.fromJson(response);
    } catch (e) {
      AppLogger.e(
          'Failed to fetch shepherd for member $memberId', 'ShepherdRepo', e);
      return null;
    }
  }

  @override
  Future<Shepherd> createShepherd(Shepherd shepherd) async {
    if (_isar.isReady) {
      final model = ShepherdModel.fromDomain(shepherd);
      await _isar.saveShepherd(model);
    }

    try {
      final json = shepherd.toJson();
      json.remove('id');
      final response = await _supabase
          .from('shepherds')
          .insert(json)
          .select()
          .single()
          .timeout(const Duration(seconds: 20));
      return Shepherd.fromJson(response);
    } catch (e, stack) {
      AppLogger.e('Failed to create shepherd', 'ShepherdRepo', e, stack);
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'shepherds',
          action: 'INSERT',
          payload: shepherd.toJson(),
          recordId: shepherd.id,
          churchId: shepherd.churchId,
        );
      }
      return shepherd;
    }
  }

  @override
  Future<Shepherd> updateShepherd(Shepherd shepherd) async {
    if (_isar.isReady) {
      final model = ShepherdModel.fromDomain(shepherd);
      await _isar.saveShepherd(model);
    }

    try {
      final response = await _supabase
          .from('shepherds')
          .update(shepherd.toJson())
          .eq('id', shepherd.id)
          .select()
          .single()
          .timeout(const Duration(seconds: 20));
      return Shepherd.fromJson(response);
    } catch (e, stack) {
      AppLogger.e(
          'Failed to update shepherd ${shepherd.id}', 'ShepherdRepo', e, stack);
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'shepherds',
          action: 'UPDATE',
          payload: shepherd.toJson(),
          recordId: shepherd.id,
          churchId: shepherd.churchId,
        );
      }
      return shepherd;
    }
  }

  @override
  Future<void> deleteShepherd(String id) async {
    if (_isar.isReady) {
      final shepherds = await _isar.getAllShepherds();
      final model = shepherds.firstWhere(
        (s) => s.id == id,
        orElse: () => ShepherdModel()..id = 'not_found',
      );
      if (model.id != 'not_found') {
        await _isar.deleteShepherd(model.isarId);
      }
    }

    try {
      await _supabase
          .from('shepherds')
          .delete()
          .eq('id', id)
          .timeout(const Duration(seconds: 20));
    } catch (e, stack) {
      AppLogger.e('Failed to delete shepherd $id', 'ShepherdRepo', e, stack);
      if (_isar.isReady) {
        // Need churchId to correctly sync deletion, but only ID is passed.
        // We will try to fetch the churchId from the local model before it's deleted.
        String? churchId;
        try {
          final sModel = await _isar.getAllShepherds();
          final theModel = sModel.firstWhere((s) => s.id == id);
          churchId = theModel.churchId;
        } catch (e) {
          AppLogger.d('Could not infer churchId for deleted shepherd $id: $e');
        }

        await _syncManager.registerAction(
          entityType: 'shepherds',
          action: 'DELETE',
          payload: {'id': id},
          recordId: id,
          churchId: churchId ?? '',
        );
      }
    }
  }

  @override
  Future<List<PastoralVisit>> getPastoralVisits({String? shepherdId}) async {
    if (_isar.isReady) {
      final models = await _isar.getPastoralVisits(shepherdId: shepherdId);
      if (models.isNotEmpty) {
        return models.map((m) => m.toDomain()).toList();
      }
    }

    try {
      var query = _supabase.from('pastoral_visits').select();
      if (shepherdId != null) {
        query = query.eq('shepherd_id', shepherdId);
      }
      final records = await query.timeout(const Duration(seconds: 20));
      return records.map((json) => PastoralVisit.fromJson(json)).toList();
    } catch (e, stack) {
      AppLogger.e('Failed to fetch pastoral visits', 'ShepherdRepo', e, stack);
      return [];
    }
  }

  @override
  Future<void> logPastoralVisit(PastoralVisit visit) async {
    if (_isar.isReady) {
      final model = PastoralVisitModel.fromDomain(visit);
      await _isar.savePastoralVisit(model);
    }

    try {
      await _supabase
          .from('pastoral_visits')
          .insert(visit.toJson())
          .timeout(const Duration(seconds: 20));
    } catch (e, stack) {
      AppLogger.e('Failed to log pastoral visit', 'ShepherdRepo', e, stack);
      if (_isar.isReady) {
        String? churchId;
        // Infer churchId from the shepherd
        try {
          final shepherds = await _isar.getAllShepherds();
          final sh = shepherds.firstWhere((s) => s.id == visit.shepherdId);
          churchId = sh.churchId;
        } catch (e) {
          AppLogger.d(
              'Could not infer churchId for visit shepherd ${visit.shepherdId}: $e');
        }

        await _syncManager.registerAction(
          entityType: 'pastoral_visits',
          action: 'INSERT',
          payload: visit.toJson(),
          recordId: visit.id,
          churchId: churchId ?? '',
        );
      }
    }
  }
}