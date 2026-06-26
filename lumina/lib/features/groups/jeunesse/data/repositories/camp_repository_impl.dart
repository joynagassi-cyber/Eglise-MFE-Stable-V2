import 'package:dartz/dartz.dart';
import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/error/failures.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';
import 'package:lumina/features/groups/jeunesse/data/models/camp_model.dart';
import 'package:lumina/features/groups/jeunesse/domain/entities/camp.dart';
import 'package:lumina/features/groups/jeunesse/domain/repositories/camp_repository.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/utils/app_date_time.dart';

class CampRepositoryImpl implements ICampRepository {
  final SupabaseClient _client;
  final IsarService _isar;
  final OfflineSyncManager _syncManager;

  CampRepositoryImpl(this._client, this._isar, this._syncManager);

  @override
  Future<Either<Failure, List<Camp>>> getCamps(String groupId) async {
    return getCampsByGroup(groupId);
  }

  @override
  Future<Either<Failure, List<Camp>>> getCampsByGroup(String groupId) async {
    try {
      if (_isar.isReady) {
        final localModels = await _isar.campModels
            .filter()
            .groupIdEqualTo(groupId)
            .isDeletedEqualTo(false)
            .sortByStartDateDesc()
            .findAll();

        if (localModels.isNotEmpty) {
          return Right(localModels.map((m) => m.toDomain()).toList());
        }
      }

      final response = await _client
          .from('camps')
          .select()
          .eq('group_id', groupId)
          .order('start_date', ascending: false);

      final list =
          (response as List).map((json) => Camp.fromJson(json)).toList();

      if (_isar.isReady) {
        await _saveCampsLocal(list);
      }

      return Right(list);
    } catch (e, stack) {
      AppLogger.e('Error fetching camps', 'CAMP_REPO', e, stack);
      if (_isar.isReady) {
        final localModels = await _isar.campModels
            .filter()
            .groupIdEqualTo(groupId)
            .isDeletedEqualTo(false)
            .sortByStartDateDesc()
            .findAll();
        if (localModels.isNotEmpty) {
          return Right(localModels.map((m) => m.toDomain()).toList());
        }
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Camp>> addCamp(Camp camp) async {
    final model = CampModel.fromDomain(camp)
      ..lastSyncedAt = AppDateTime.nowUtc();

    if (_isar.isReady) {
      await _isar.db.writeTxn(() => _isar.campModels.put(model));
    }

    try {
      await _client.from('camps').insert(camp.toJson());
      return Right(camp);
    } catch (e) {
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'camps',
          action: 'INSERT',
          payload: camp.toJson(),
          recordId: camp.id,
          churchId: camp.churchId,
        );
      }
      return Right(camp);
    }
  }

  @override
  Future<Either<Failure, Camp>> updateCamp(Camp camp) async {
    final model = CampModel.fromDomain(camp)
      ..lastSyncedAt = AppDateTime.nowUtc();

    if (_isar.isReady) {
      await _isar.db.writeTxn(() => _isar.campModels.put(model));
    }

    try {
      await _client.from('camps').update(camp.toJson()).eq('id', camp.id);
      return Right(camp);
    } catch (e) {
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'camps',
          action: 'UPDATE',
          payload: camp.toJson(),
          recordId: camp.id,
          churchId: camp.churchId,
        );
      }
      return Right(camp);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCamp(String id, String churchId) async {
    try {
      if (_isar.isReady) {
        final model = await _isar.campModels.filter().idEqualTo(id).findFirst();
        if (model != null) {
          await _isar.db.writeTxn(() async {
            await _isar.campModels.delete(model.isarId);
          });
        }
      }

      await _client.from('camps').delete().eq('id', id);
      return const Right(unit);
    } catch (e) {
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'camps',
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
  Future<Either<Failure, void>> syncCamps() async {
    // Implementation for manual sync if needed
    return const Right(null);
  }

  Future<void> _saveCampsLocal(List<Camp> list) async {
    await _isar.db.writeTxn(() async {
      for (var item in list) {
        final model = CampModel.fromDomain(item);
        await _isar.campModels.put(model);
      }
    });
  }
}