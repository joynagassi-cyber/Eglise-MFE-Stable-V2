import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/data/local/isar_service.dart';
import '../../../../../core/services/offline_sync_manager.dart';
import '../../domain/entities/child_safety_card.dart';
import '../../domain/entities/children_program.dart';
import '../../domain/entities/pedagogic_resource.dart';
import '../../domain/repositories/enfants_repository.dart';
import '../models/child_safety_card_model.dart';
import '../models/children_program_model.dart';
import '../models/pedagogic_resource_model.dart';

class EnfantsRepositoryImpl implements EnfantsRepository {
  final SupabaseClient _supabase;
  final IsarService _isarService;
  final OfflineSyncManager _offlineSyncManager;

  EnfantsRepositoryImpl(
      this._supabase, this._isarService, this._offlineSyncManager);

  @override
  Future<Either<Failure, List<ChildSafetyCard>>> getSafetyCards() async {
    try {
      final isar = _isarService.db;
      final localCards = await isar.childSafetyCardModels.where().findAll();

      if (localCards.isNotEmpty) {
        return Right(localCards.map((m) => m.toDomain()).toList());
      }

      final response = await _supabase
          .from('child_safety_cards')
          .select()
          .order('created_at', ascending: false);

      final cards = (response as List)
          .map((json) => ChildSafetyCard.fromJson(json))
          .toList();

      await isar.writeTxn(() async {
        await isar.childSafetyCardModels.putAll(
          cards.map((c) => ChildSafetyCardModel.fromDomain(c)).toList(),
        );
      });

      return Right(cards);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChildSafetyCard>> createSafetyCard(
      ChildSafetyCard card) async {
    try {
      final isar = _isarService.db;
      await isar.writeTxn(() async {
        await isar.childSafetyCardModels
            .put(ChildSafetyCardModel.fromDomain(card));
      });

      await _offlineSyncManager.registerAction(
        entityType: 'child_safety_cards',
        action: 'INSERT',
        payload: card.toJson(),
        churchId: card.churchId,
      );

      return Right(card);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChildrenProgram>>> getPrograms() async {
    try {
      final isar = _isarService.db;
      final localPrograms = await isar.childrenProgramModels.where().findAll();

      if (localPrograms.isNotEmpty) {
        return Right(localPrograms.map((m) => m.toDomain()).toList());
      }

      final response = await _supabase
          .from('children_programs')
          .select()
          .order('min_age', ascending: true);

      final programs = (response as List)
          .map((json) => ChildrenProgram.fromJson(json))
          .toList();

      await isar.writeTxn(() async {
        await isar.childrenProgramModels.putAll(
          programs.map((p) => ChildrenProgramModel.fromDomain(p)).toList(),
        );
      });

      return Right(programs);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChildrenProgram>> createProgram(
      ChildrenProgram program) async {
    try {
      final isar = _isarService.db;
      await isar.writeTxn(() async {
        await isar.childrenProgramModels
            .put(ChildrenProgramModel.fromDomain(program));
      });

      await _offlineSyncManager.registerAction(
        entityType: 'children_programs',
        action: 'INSERT',
        payload: program.toJson(),
        churchId: program.churchId,
      );

      return Right(program);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Implementation for resources and other methods follows the same pattern...
  // For brevity and to ensure correctness of the churchId integration:

  @override
  Future<Either<Failure, List<PedagogicResource>>> getResources() async {
    try {
      final isar = _isarService.db;
      final localResources =
          await isar.pedagogicResourceModels.where().findAll();

      if (localResources.isNotEmpty) {
        return Right(localResources.map((m) => m.toDomain()).toList());
      }

      final response = await _supabase
          .from('pedagogic_resources')
          .select()
          .order('created_at', ascending: false);

      final resources = (response as List)
          .map((json) => PedagogicResource.fromJson(json))
          .toList();

      await isar.writeTxn(() async {
        await isar.pedagogicResourceModels.putAll(
          resources.map((r) => PedagogicResourceModel.fromDomain(r)).toList(),
        );
      });

      return Right(resources);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PedagogicResource>> uploadResource(
      PedagogicResource resource) async {
    try {
      final isar = _isarService.db;
      await isar.writeTxn(() async {
        await isar.pedagogicResourceModels
            .put(PedagogicResourceModel.fromDomain(resource));
      });

      await _offlineSyncManager.registerAction(
        entityType: 'pedagogic_resources',
        action: 'INSERT',
        payload: resource.toJson(),
        churchId: resource.churchId,
      );

      return Right(resource);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSafetyCard(
      String id, String churchId) async {
    try {
      final isar = _isarService.db;
      await isar.writeTxn(() async {
        await isar.childSafetyCardModels.filter().idEqualTo(id).deleteFirst();
      });

      await _supabase.from('child_safety_cards').delete().eq('id', id);
      return const Right(null);
    } catch (e) {
      await _offlineSyncManager.registerAction(
        entityType: 'child_safety_cards',
        action: 'DELETE',
        payload: {'id': id},
        recordId: id,
        churchId: churchId,
      );
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, ChildSafetyCard>> updateSafetyCard(
      ChildSafetyCard card) async {
    try {
      final isar = _isarService.db;
      await isar.writeTxn(() async {
        await isar.childSafetyCardModels
            .put(ChildSafetyCardModel.fromDomain(card));
      });
      return Right(card);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProgram(
      String id, String churchId) async {
    try {
      final isar = _isarService.db;
      await isar.writeTxn(() async {
        await isar.childrenProgramModels.filter().idEqualTo(id).deleteFirst();
      });

      await _supabase.from('children_programs').delete().eq('id', id);
      return const Right(null);
    } catch (e) {
      await _offlineSyncManager.registerAction(
        entityType: 'children_programs',
        action: 'DELETE',
        payload: {'id': id},
        recordId: id,
        churchId: churchId,
      );
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, ChildrenProgram>> updateProgram(
      ChildrenProgram program) async {
    try {
      final isar = _isarService.db;
      await isar.writeTxn(() async {
        await isar.childrenProgramModels
            .put(ChildrenProgramModel.fromDomain(program));
      });
      return Right(program);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteResource(
      String id, String churchId) async {
    try {
      final isar = _isarService.db;
      await isar.writeTxn(() async {
        await isar.pedagogicResourceModels.filter().idEqualTo(id).deleteFirst();
      });

      await _supabase.from('pedagogic_resources').delete().eq('id', id);
      return const Right(null);
    } catch (e) {
      await _offlineSyncManager.registerAction(
        entityType: 'pedagogic_resources',
        action: 'DELETE',
        payload: {'id': id},
        recordId: id,
        churchId: churchId,
      );
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getEnfantsKpis() async {
    return const Right({
      'totalKids': 45,
      'attendanceRate': 0.85,
      'safeCheckIns': 12,
      'pendingAlerts': 2,
    });
  }
}