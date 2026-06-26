import 'package:dartz/dartz.dart';
import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/error/failures.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';
import 'package:lumina/features/groups/jeunesse/data/models/discipleship_program_model.dart';
import 'package:lumina/features/groups/jeunesse/domain/entities/discipleship_program.dart';
import 'package:lumina/features/groups/jeunesse/domain/repositories/discipleship_repository.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/utils/app_date_time.dart';

class DiscipleshipRepositoryImpl implements IDiscipleshipRepository {
  final SupabaseClient _client;
  final IsarService _isar;
  final OfflineSyncManager _syncManager;

  DiscipleshipRepositoryImpl(this._client, this._isar, this._syncManager);

  @override
  Future<Either<Failure, List<DiscipleshipProgram>>> getPrograms(
      String groupId) async {
    return getProgramsByGroup(groupId);
  }

  @override
  Future<Either<Failure, List<DiscipleshipProgram>>> getProgramsByGroup(
      String groupId) async {
    try {
      if (_isar.isReady) {
        final localModels = await _isar.discipleshipProgramModels
            .filter()
            .groupIdEqualTo(groupId)
            .isDeletedEqualTo(false)
            .findAll();

        if (localModels.isNotEmpty) {
          return Right(localModels.map((m) => m.toDomain()).toList());
        }
      }

      final response = await _client
          .from('discipleship_programs')
          .select()
          .eq('group_id', groupId)
          .order('created_at', ascending: false);

      final list = (response as List)
          .map((json) => DiscipleshipProgram.fromJson(json))
          .toList();

      if (_isar.isReady) {
        await _saveProgramsLocal(list);
      }

      return Right(list);
    } catch (e, stack) {
      AppLogger.e(
          'Error fetching discipleship programs', 'DISCIPLE_REPO', e, stack);
      if (_isar.isReady) {
        final localModels = await _isar.discipleshipProgramModels
            .filter()
            .groupIdEqualTo(groupId)
            .isDeletedEqualTo(false)
            .findAll();
        if (localModels.isNotEmpty) {
          return Right(localModels.map((m) => m.toDomain()).toList());
        }
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DiscipleshipProgram>> addProgram(
      DiscipleshipProgram program) async {
    final model = DiscipleshipProgramModel.fromDomain(program)
      ..lastSyncedAt = AppDateTime.nowUtc();

    if (_isar.isReady) {
      await _isar.db.writeTxn(() => _isar.discipleshipProgramModels.put(model));
    }

    try {
      await _client.from('discipleship_programs').insert(program.toJson());
      return Right(program);
    } catch (e) {
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'discipleship_programs',
          action: 'INSERT',
          payload: program.toJson(),
          recordId: program.id,
          churchId: program.churchId,
        );
      }
      return Right(program);
    }
  }

  @override
  Future<Either<Failure, DiscipleshipProgram>> updateProgram(
      DiscipleshipProgram program) async {
    final model = DiscipleshipProgramModel.fromDomain(program)
      ..lastSyncedAt = AppDateTime.nowUtc();

    if (_isar.isReady) {
      await _isar.db.writeTxn(() => _isar.discipleshipProgramModels.put(model));
    }

    try {
      await _client
          .from('discipleship_programs')
          .update(program.toJson())
          .eq('id', program.id);
      return Right(program);
    } catch (e) {
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'discipleship_programs',
          action: 'UPDATE',
          payload: program.toJson(),
          recordId: program.id,
          churchId: program.churchId,
        );
      }
      return Right(program);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProgram(
      String id, String churchId) async {
    try {
      if (_isar.isReady) {
        final model = await _isar.discipleshipProgramModels
            .filter()
            .idEqualTo(id)
            .findFirst();
        if (model != null) {
          await _isar.db.writeTxn(() async {
            await _isar.discipleshipProgramModels.delete(model.isarId);
          });
        }
      }

      await _client.from('discipleship_programs').delete().eq('id', id);
      return const Right(unit);
    } catch (e) {
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'discipleship_programs',
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
  Future<Either<Failure, void>> syncPrograms() async {
    return const Right(null);
  }

  Future<void> _saveProgramsLocal(List<DiscipleshipProgram> list) async {
    await _isar.db.writeTxn(() async {
      for (var item in list) {
        final model = DiscipleshipProgramModel.fromDomain(item);
        await _isar.discipleshipProgramModels.put(model);
      }
    });
  }
}