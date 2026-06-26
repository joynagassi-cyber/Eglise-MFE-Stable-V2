import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/error/failures.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';
import 'package:lumina/core/logging/app_logger.dart';
import '../../domain/entities/group_project.dart';
import '../../domain/entities/mentorship_pair.dart';
import '../../domain/repositories/hommes_repository.dart';
import '../models/group_project_model.dart';
import '../models/mentorship_pair_model.dart';
import 'package:lumina/core/utils/app_date_time.dart';

class HommesRepositoryImpl implements HommesRepository {
  final SupabaseClient _client;
  final IsarService _isar;
  final OfflineSyncManager _syncManager;

  HommesRepositoryImpl(this._client, this._isar, this._syncManager);

  // --- PROJETS ---

  @override
  Future<Either<Failure, List<GroupProject>>> getProjects(
      String groupId) async {
    try {
      if (_isar.isReady) {
        final localModels = await _isar.groupProjectModels
            .filter()
            .groupIdEqualTo(groupId)
            .isDeletedEqualTo(false)
            .sortByCreatedAtDesc()
            .findAll();

        if (localModels.isNotEmpty) {
          return Right(localModels.map((m) => m.toDomain()).toList());
        }
      }

      final response = await _client
          .from('group_projects')
          .select()
          .eq('group_id', groupId)
          .order('created_at', ascending: false);

      final list = (response as List)
          .map((json) => GroupProject.fromJson(json))
          .toList();

      if (_isar.isReady) {
        await _saveProjectsLocal(list);
      }

      return Right(list);
    } catch (e, stack) {
      AppLogger.e('Error fetching group projects', 'HOMMES_REPO', e, stack);
      if (_isar.isReady) {
        final localModels = await _isar.groupProjectModels
            .filter()
            .groupIdEqualTo(groupId)
            .isDeletedEqualTo(false)
            .sortByCreatedAtDesc()
            .findAll();
        if (localModels.isNotEmpty) {
          return Right(localModels.map((m) => m.toDomain()).toList());
        }
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GroupProject>> addProject(GroupProject project) async {
    final model = GroupProjectModel.fromDomain(project)
      ..lastSyncedAt = AppDateTime.nowUtc();

    if (_isar.isReady) {
      await _isar.db.writeTxn(() => _isar.groupProjectModels.put(model));
    }

    try {
      await _client.from('group_projects').insert(project.toJson());
      return Right(project);
    } catch (e) {
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'group_projects',
          action: 'INSERT',
          payload: project.toJson(),
          recordId: project.id,
          churchId: project.churchId,
        );
      }
      return Right(project);
    }
  }

  @override
  Future<Either<Failure, GroupProject>> updateProject(
      GroupProject project) async {
    final model = GroupProjectModel.fromDomain(project)
      ..lastSyncedAt = AppDateTime.nowUtc();

    if (_isar.isReady) {
      await _isar.db.writeTxn(() => _isar.groupProjectModels.put(model));
    }

    try {
      await _client
          .from('group_projects')
          .update(project.toJson())
          .eq('id', project.id);
      return Right(project);
    } catch (e) {
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'group_projects',
          action: 'UPDATE',
          payload: project.toJson(),
          recordId: project.id,
          churchId: project.churchId,
        );
      }
      return Right(project);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProject(
      String id, String churchId) async {
    try {
      if (_isar.isReady) {
        final model =
            await _isar.groupProjectModels.filter().idEqualTo(id).findFirst();
        if (model != null) {
          await _isar.db
              .writeTxn(() => _isar.groupProjectModels.delete(model.isarId));
        }
      }

      await _client.from('group_projects').delete().eq('id', id);
      return const Right(unit);
    } catch (e) {
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'group_projects',
          action: 'DELETE',
          payload: {'id': id},
          recordId: id,
          churchId: churchId,
        );
      }
      return const Right(unit);
    }
  }

  // --- MENTORAT ---

  @override
  Future<Either<Failure, List<MentorshipPair>>> getMentorshipPairs(
      String groupId) async {
    try {
      if (_isar.isReady) {
        final localModels = await _isar.mentorshipPairModels
            .filter()
            .groupIdEqualTo(groupId)
            .isDeletedEqualTo(false)
            .findAll();

        if (localModels.isNotEmpty) {
          return Right(localModels.map((m) => m.toDomain()).toList());
        }
      }

      final response = await _client.from('mentorship_pairs').select('''
            *,
            mentor:mentor_id(first_name, last_name),
            mentee:mentee_id(first_name, last_name)
          ''').eq('group_id', groupId);

      final list = (response as List).map((json) {
        final mentor = json['mentor'] as Map<String, dynamic>?;
        final mentee = json['mentee'] as Map<String, dynamic>?;

        return MentorshipPair.fromJson(json).copyWith(
          mentorName: mentor != null
              ? "${mentor['first_name']} ${mentor['last_name']}"
              : null,
          menteeName: mentee != null
              ? "${mentee['first_name']} ${mentee['last_name']}"
              : null,
        );
      }).toList();

      if (_isar.isReady) {
        await _saveMentorshipPairsLocal(list);
      }

      return Right(list);
    } catch (e, stack) {
      AppLogger.e('Error fetching mentorship pairs', 'HOMMES_REPO', e, stack);
      if (_isar.isReady) {
        final localModels = await _isar.mentorshipPairModels
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
  Future<Either<Failure, MentorshipPair>> addMentorshipPair(
      MentorshipPair pair) async {
    final model = MentorshipPairModel.fromDomain(pair)
      ..lastSyncedAt = AppDateTime.nowUtc();

    if (_isar.isReady) {
      await _isar.db.writeTxn(() => _isar.mentorshipPairModels.put(model));
    }

    try {
      await _client.from('mentorship_pairs').insert(pair.toJson());
      return Right(pair);
    } catch (e) {
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'mentorship_pairs',
          action: 'INSERT',
          payload: pair.toJson(),
          recordId: pair.id,
          churchId: pair.churchId,
        );
      }
      return Right(pair);
    }
  }

  @override
  Future<Either<Failure, MentorshipPair>> updateMentorshipPair(
      MentorshipPair pair) async {
    final model = MentorshipPairModel.fromDomain(pair)
      ..lastSyncedAt = AppDateTime.nowUtc();

    if (_isar.isReady) {
      await _isar.db.writeTxn(() => _isar.mentorshipPairModels.put(model));
    }

    try {
      await _client
          .from('mentorship_pairs')
          .update(pair.toJson())
          .eq('id', pair.id);
      return Right(pair);
    } catch (e) {
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'mentorship_pairs',
          action: 'UPDATE',
          payload: pair.toJson(),
          recordId: pair.id,
          churchId: pair.churchId,
        );
      }
      return Right(pair);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMentorshipPair(
      String id, String churchId) async {
    try {
      if (_isar.isReady) {
        final model =
            await _isar.mentorshipPairModels.filter().idEqualTo(id).findFirst();
        if (model != null) {
          await _isar.db
              .writeTxn(() => _isar.mentorshipPairModels.delete(model.isarId));
        }
      }

      await _client.from('mentorship_pairs').delete().eq('id', id);
      return const Right(unit);
    } catch (e) {
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'mentorship_pairs',
          action: 'DELETE',
          payload: {'id': id},
          recordId: id,
          churchId: churchId,
        );
      }
      return const Right(unit);
    }
  }

  // --- HELPERS ---

  Future<void> _saveProjectsLocal(List<GroupProject> list) async {
    await _isar.db.writeTxn(() async {
      for (var item in list) {
        final model = GroupProjectModel.fromDomain(item);
        await _isar.groupProjectModels.put(model);
      }
    });
  }

  Future<void> _saveMentorshipPairsLocal(List<MentorshipPair> list) async {
    await _isar.db.writeTxn(() async {
      for (var item in list) {
        final model = MentorshipPairModel.fromDomain(item);
        await _isar.mentorshipPairModels.put(model);
      }
    });
  }
}