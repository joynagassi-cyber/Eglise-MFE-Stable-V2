import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:isar/isar.dart';
import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/error/failures.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';
import '../../domain/entities/training.dart';
import '../../domain/entities/mutual_aid_request.dart';
import '../../domain/repositories/femmes_repository.dart';
import '../models/training_model.dart';
import '../models/mutual_aid_request_model.dart';
import 'package:lumina/core/utils/app_date_time.dart';

class FemmesRepositoryImpl implements FemmesRepository {
  final SupabaseClient _supabase;
  final IsarService _isarService;
  final OfflineSyncManager _syncManager;

  FemmesRepositoryImpl(this._supabase, this._isarService, this._syncManager);

  @override
  Future<Either<Failure, List<Training>>> getTrainings(String groupId) async {
    if (!_isarService.isReady) {
      try {
        final response = await _supabase
            .from('trainings')
            .select()
            .eq('group_id', groupId)
            .order('date', ascending: true);

        return Right(response.map((json) => Training.fromJson(json)).toList());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }

    final isar = _isarService.db;
    try {
      final response = await _supabase
          .from('trainings')
          .select()
          .eq('group_id', groupId)
          .order('date', ascending: true);

      final trainings =
          response.map((json) => Training.fromJson(json)).toList();

      // Sync with local Isar
      await isar.writeTxn(() async {
        for (final training in trainings) {
          await isar.trainingModels.put(TrainingModel.fromDomain(training));
        }
      });
      return Right(trainings);
    } catch (e) {
      AppLogger.e(
          'Failed to fetch/sync trainings for $groupId', 'FEMMES_REPO', e);
      // Fallback to local data
      final models =
          await isar.trainingModels.filter().groupIdEqualTo(groupId).findAll();
      return Right(models.map((m) => m.toDomain()).toList());
    }
  }

  @override
  Future<Either<Failure, Training>> addTraining(Training training) async {
    if (_isarService.isReady) {
      final model = TrainingModel.fromDomain(training);
      model.lastSyncedAt = AppDateTime.nowUtc();
      await _isarService.db.writeTxn(() async {
        await _isarService.db.trainingModels.put(model);
      });
    }

    try {
      final json = training.toJson()..remove('id');
      final response =
          await _supabase.from('trainings').insert(json).select().single();

      return Right(Training.fromJson(response));
    } catch (e) {
      AppLogger.w('Failed to add training online, registering for offline sync',
          'FEMMES_REPO');
      if (_isarService.isReady) {
        await _syncManager.registerAction(
          entityType: 'trainings',
          action: 'INSERT',
          payload: training.toJson(),
          recordId: training.id,
          churchId: training.churchId,
        );
      }
      return Right(training);
    }
  }

  @override
  Future<Either<Failure, Training>> updateTraining(Training training) async {
    if (_isarService.isReady) {
      final model = TrainingModel.fromDomain(training);
      model.lastSyncedAt = AppDateTime.nowUtc();
      await _isarService.db.writeTxn(() async {
        final existing = await _isarService.db.trainingModels
            .filter()
            .originalIdEqualTo(training.id)
            .findFirst();
        if (existing != null) model.isarId = existing.isarId;
        await _isarService.db.trainingModels.put(model);
      });
    }

    try {
      final response = await _supabase
          .from('trainings')
          .update(training.toJson())
          .eq('id', training.id)
          .select()
          .single();

      return Right(Training.fromJson(response));
    } catch (e) {
      if (_isarService.isReady) {
        await _syncManager.registerAction(
          entityType: 'trainings',
          action: 'UPDATE',
          payload: training.toJson(),
          recordId: training.id,
          churchId: training.churchId,
        );
      }
      return Right(training);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTraining(
      String id, String churchId) async {
    if (_isarService.isReady) {
      await _isarService.db.writeTxn(() async {
        await _isarService.db.trainingModels
            .filter()
            .originalIdEqualTo(id)
            .deleteAll();
      });
    }

    try {
      await _supabase.from('trainings').delete().eq('id', id);
      return const Right(unit);
    } catch (e) {
      if (_isarService.isReady) {
        await _syncManager.registerAction(
          entityType: 'trainings',
          action: 'DELETE',
          payload: {'id': id},
          recordId: id,
          churchId: churchId,
        );
      }
      return const Right(unit);
    }
  }

  @override
  Future<Either<Failure, Unit>> enrollInTraining(
      String trainingId, String memberId) async {
    try {
      // Corrected call to RPC with parameters matching the TEXT primary key
      await _supabase.rpc('increment_training_enrollment',
          params: {'training_id': trainingId});
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MutualAidRequest>>> getMutualAidRequests(
      String groupId) async {
    if (!_isarService.isReady) {
      try {
        final response = await _supabase
            .from('mutual_aid_requests')
            .select()
            .eq('group_id', groupId)
            .order('created_at', ascending: false);

        return Right(
            response.map((json) => MutualAidRequest.fromJson(json)).toList());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }

    final isar = _isarService.db;
    try {
      final response = await _supabase
          .from('mutual_aid_requests')
          .select()
          .eq('group_id', groupId)
          .order('created_at', ascending: false);

      final requests =
          response.map((json) => MutualAidRequest.fromJson(json)).toList();

      await isar.writeTxn(() async {
        for (final request in requests) {
          await isar.mutualAidRequestModels
              .put(MutualAidRequestModel.fromDomain(request));
        }
      });
      return Right(requests);
    } catch (e) {
      AppLogger.e('Failed to fetch/sync mutual aid requests for $groupId',
          'FEMMES_REPO', e);
      final models = await isar.mutualAidRequestModels
          .filter()
          .groupIdEqualTo(groupId)
          .findAll();
      return Right(models.map((m) => m.toDomain()).toList());
    }
  }

  @override
  Future<Either<Failure, MutualAidRequest>> addMutualAidRequest(
      MutualAidRequest request) async {
    if (_isarService.isReady) {
      final model = MutualAidRequestModel.fromDomain(request);
      model.lastSyncedAt = AppDateTime.nowUtc();
      await _isarService.db.writeTxn(() async {
        await _isarService.db.mutualAidRequestModels.put(model);
      });
    }

    try {
      final json = request.toJson()..remove('id');
      final response = await _supabase
          .from('mutual_aid_requests')
          .insert(json)
          .select()
          .single();

      return Right(MutualAidRequest.fromJson(response));
    } catch (e) {
      if (_isarService.isReady) {
        await _syncManager.registerAction(
          entityType: 'mutual_aid_requests',
          action: 'INSERT',
          payload: request.toJson(),
          recordId: request.id,
          churchId: request.churchId,
        );
      }
      return Right(request);
    }
  }

  @override
  Future<Either<Failure, MutualAidRequest>> updateMutualAidRequest(
      MutualAidRequest request) async {
    if (_isarService.isReady) {
      final model = MutualAidRequestModel.fromDomain(request);
      model.lastSyncedAt = AppDateTime.nowUtc();
      await _isarService.db.writeTxn(() async {
        final existing = await _isarService.db.mutualAidRequestModels
            .filter()
            .originalIdEqualTo(request.id)
            .findFirst();
        if (existing != null) model.isarId = existing.isarId;
        await _isarService.db.mutualAidRequestModels.put(model);
      });
    }

    try {
      final response = await _supabase
          .from('mutual_aid_requests')
          .update(request.toJson())
          .eq('id', request.id)
          .select()
          .single();

      return Right(MutualAidRequest.fromJson(response));
    } catch (e) {
      if (_isarService.isReady) {
        await _syncManager.registerAction(
          entityType: 'mutual_aid_requests',
          action: 'UPDATE',
          payload: request.toJson(),
          recordId: request.id,
          churchId: request.churchId,
        );
      }
      return Right(request);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMutualAidRequest(
      String id, String churchId) async {
    if (_isarService.isReady) {
      await _isarService.db.writeTxn(() async {
        await _isarService.db.mutualAidRequestModels
            .filter()
            .originalIdEqualTo(id)
            .deleteAll();
      });
    }

    try {
      await _supabase.from('mutual_aid_requests').delete().eq('id', id);
      return const Right(unit);
    } catch (e) {
      if (_isarService.isReady) {
        await _syncManager.registerAction(
          entityType: 'mutual_aid_requests',
          action: 'DELETE',
          payload: {'id': id},
          recordId: id,
          churchId: churchId,
        );
      }
      return const Right(unit);
    }
  }
}