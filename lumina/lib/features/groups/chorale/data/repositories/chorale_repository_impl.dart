import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/error/failures.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:isar/isar.dart';
import '../../domain/entities/sheet_music.dart';
import '../../domain/entities/rehearsal.dart';
import '../../domain/repositories/chorale_repository.dart';
import '../models/sheet_music_model.dart';
import '../models/rehearsal_model.dart';
import 'package:lumina/core/utils/app_date_time.dart';

class ChoraleRepositoryImpl implements ChoraleRepository {
  final SupabaseClient _client;
  final IsarService _isar;
  final OfflineSyncManager _syncManager;

  ChoraleRepositoryImpl(this._client, this._isar, this._syncManager);

  @override
  Future<Either<Failure, List<SheetMusic>>> getSheetMusic(
      String groupId) async {
    try {
      if (_isar.isReady) {
        final localModels = await _isar.sheetMusicModels
            .filter()
            .groupIdEqualTo(groupId)
            .isDeletedEqualTo(false)
            .findAll();

        if (localModels.isNotEmpty) {
          return Right(localModels.map((m) => m.toDomain()).toList());
        }
      }

      final response = await _client
          .from('sheet_music')
          .select()
          .eq('group_id', groupId)
          .order('title');

      final list =
          (response as List).map((json) => SheetMusic.fromJson(json)).toList();

      if (_isar.isReady) {
        await _saveSheetMusicLocal(list);
      }

      return Right(list);
    } catch (e, stack) {
      AppLogger.e('Error fetching sheet music', 'CHORALE_REPO', e, stack);

      // Fallback to local if exists
      if (_isar.isReady) {
        final localModels = await _isar.sheetMusicModels
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
  Future<Either<Failure, SheetMusic>> addSheetMusic(
      SheetMusic sheetMusic) async {
    final model = SheetMusicModel.fromDomain(sheetMusic)
      ..lastSyncedAt = AppDateTime.nowUtc();

    if (_isar.isReady) {
      await _isar.db.writeTxn(() => _isar.sheetMusicModels.put(model));
    }

    try {
      final json = sheetMusic.toJson();
      // Remove id if it's new and we want Supabase to generate it,
      // but here we generate UUID locally for offline support.
      await _client.from('sheet_music').insert(json);

      return Right(sheetMusic);
    } catch (e) {
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'sheet_music',
          action: 'INSERT',
          payload: sheetMusic.toJson(),
          recordId: sheetMusic.id,
          churchId: sheetMusic.churchId,
        );
      }
      return Right(sheetMusic);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSheetMusic(
      String id, String churchId) async {
    try {
      if (_isar.isReady) {
        final model =
            await _isar.sheetMusicModels.filter().idEqualTo(id).findFirst();
        if (model != null) {
          await _isar.db
              .writeTxn(() => _isar.sheetMusicModels.delete(model.isarId));
        }
      }

      await _client.from('sheet_music').delete().eq('id', id);
      return const Right(unit);
    } catch (e) {
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'sheet_music',
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
  Future<Either<Failure, List<Rehearsal>>> getRehearsals(String groupId) async {
    try {
      if (_isar.isReady) {
        final localModels = await _isar.rehearsalModels
            .filter()
            .groupIdEqualTo(groupId)
            .isDeletedEqualTo(false)
            .sortByDateDesc()
            .findAll();

        if (localModels.isNotEmpty) {
          return Right(localModels.map((m) => m.toDomain()).toList());
        }
      }

      final response = await _client
          .from('rehearsals')
          .select()
          .eq('group_id', groupId)
          .order('date', ascending: false);

      final list =
          (response as List).map((json) => Rehearsal.fromJson(json)).toList();

      if (_isar.isReady) {
        await _saveRehearsalsLocal(list);
      }

      return Right(list);
    } catch (e, stack) {
      AppLogger.e('Error fetching rehearsals', 'CHORALE_REPO', e, stack);
      if (_isar.isReady) {
        final localModels = await _isar.rehearsalModels
            .filter()
            .groupIdEqualTo(groupId)
            .isDeletedEqualTo(false)
            .sortByDateDesc()
            .findAll();
        if (localModels.isNotEmpty) {
          return Right(localModels.map((m) => m.toDomain()).toList());
        }
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Rehearsal>> addRehearsal(Rehearsal rehearsal) async {
    final model = RehearsalModel.fromDomain(rehearsal)
      ..lastSyncedAt = AppDateTime.nowUtc();

    if (_isar.isReady) {
      await _isar.db.writeTxn(() => _isar.rehearsalModels.put(model));
    }

    try {
      await _client.from('rehearsals').insert(rehearsal.toJson());
      return Right(rehearsal);
    } catch (e) {
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'rehearsals',
          action: 'INSERT',
          payload: rehearsal.toJson(),
          recordId: rehearsal.id,
          churchId: rehearsal.churchId,
        );
      }
      return Right(rehearsal);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRehearsal(
      String id, String churchId) async {
    try {
      if (_isar.isReady) {
        final model =
            await _isar.rehearsalModels.filter().idEqualTo(id).findFirst();
        if (model != null) {
          await _isar.db
              .writeTxn(() => _isar.rehearsalModels.delete(model.isarId));
        }
      }

      await _client.from('rehearsals').delete().eq('id', id);
      return const Right(unit);
    } catch (e) {
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'rehearsals',
          action: 'DELETE',
          payload: {'id': id},
          recordId: id,
          churchId: churchId,
        );
      }
      return const Right(unit);
    }
  }

  Future<void> _saveSheetMusicLocal(List<SheetMusic> list) async {
    await _isar.db.writeTxn(() async {
      for (var item in list) {
        final model = SheetMusicModel.fromDomain(item);
        await _isar.sheetMusicModels.put(model);
      }
    });
  }

  Future<void> _saveRehearsalsLocal(List<Rehearsal> list) async {
    await _isar.db.writeTxn(() async {
      for (var item in list) {
        final model = RehearsalModel.fromDomain(item);
        await _isar.rehearsalModels.put(model);
      }
    });
  }
}