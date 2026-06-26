import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';
import 'package:lumina/core/error/failures.dart';
import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';
import '../../domain/entities/prayer_vigil.dart';
import '../../domain/entities/permanent_prayer_subject.dart';
import '../../domain/repositories/intercession_repository.dart';
import '../models/prayer_vigil_model.dart';
import '../models/permanent_prayer_subject_model.dart';

class IntercessionRepositoryImpl implements IntercessionRepository {
  final SupabaseClient _supabase;
  final IsarService _isarService;
  final OfflineSyncManager _offlineSyncManager;

  IntercessionRepositoryImpl(
      this._supabase, this._isarService, this._offlineSyncManager);

  @override
  Future<Either<Failure, List<PrayerVigil>>> getPrayerVigils(
      String groupId) async {
    try {
      final isar = _isarService.db;
      final localVigils = await isar.prayerVigilModels
          .where()
          .filter()
          .groupIdEqualTo(groupId)
          .findAll();

      if (localVigils.isNotEmpty) {
        return Right(localVigils.map((m) => m.toDomain()).toList());
      }

      final response = await _supabase
          .from('prayer_vigils')
          .select()
          .eq('group_id', groupId)
          .order('start_time', ascending: false);

      final vigils =
          (response as List).map((json) => PrayerVigil.fromJson(json)).toList();

      await isar.writeTxn(() async {
        await isar.prayerVigilModels.putAll(
          vigils.map((v) => PrayerVigilModel.fromDomain(v)).toList(),
        );
      });

      return Right(vigils);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PermanentPrayerSubject>>>
      getPermanentPrayerSubjects(String groupId) async {
    try {
      final isar = _isarService.db;
      final localSubjects = await isar.permanentPrayerSubjectModels
          .where()
          .filter()
          .groupIdEqualTo(groupId)
          .findAll();

      if (localSubjects.isNotEmpty) {
        return Right(localSubjects.map((m) => m.toDomain()).toList());
      }

      final response = await _supabase
          .from('permanent_prayer_subjects')
          .select()
          .eq('group_id', groupId)
          .order('category', ascending: true);

      final subjects = (response as List)
          .map((json) => PermanentPrayerSubject.fromJson(json))
          .toList();

      await isar.writeTxn(() async {
        await isar.permanentPrayerSubjectModels.putAll(
          subjects
              .map((s) => PermanentPrayerSubjectModel.fromDomain(s))
              .toList(),
        );
      });

      return Right(subjects);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createPrayerVigil(PrayerVigil vigil) async {
    try {
      final isar = _isarService.db;
      await isar.writeTxn(() async {
        await isar.prayerVigilModels.put(PrayerVigilModel.fromDomain(vigil));
      });

      await _offlineSyncManager.registerAction(
        entityType: 'prayer_vigils',
        action: 'INSERT',
        payload: vigil.toJson(),
        churchId: vigil.churchId,
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createPermanentPrayerSubject(
      PermanentPrayerSubject subject) async {
    try {
      final isar = _isarService.db;
      await isar.writeTxn(() async {
        await isar.permanentPrayerSubjectModels
            .put(PermanentPrayerSubjectModel.fromDomain(subject));
      });

      await _offlineSyncManager.registerAction(
        entityType: 'permanent_prayer_subjects',
        action: 'INSERT',
        payload: subject.toJson(),
        churchId: subject.churchId,
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}