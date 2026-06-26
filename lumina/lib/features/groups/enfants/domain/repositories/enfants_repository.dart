import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/child_safety_card.dart';
import '../entities/children_program.dart';
import '../entities/pedagogic_resource.dart';

abstract class EnfantsRepository {
  // Safety Cards
  Future<Either<Failure, List<ChildSafetyCard>>> getSafetyCards();
  Future<Either<Failure, ChildSafetyCard>> createSafetyCard(
      ChildSafetyCard card);
  Future<Either<Failure, ChildSafetyCard>> updateSafetyCard(
      ChildSafetyCard card);
  Future<Either<Failure, void>> deleteSafetyCard(String id, String churchId);

  // Programs
  Future<Either<Failure, List<ChildrenProgram>>> getPrograms();
  Future<Either<Failure, ChildrenProgram>> createProgram(
      ChildrenProgram program);
  Future<Either<Failure, ChildrenProgram>> updateProgram(
      ChildrenProgram program);
  Future<Either<Failure, void>> deleteProgram(String id, String churchId);

  // Resources
  Future<Either<Failure, List<PedagogicResource>>> getResources();
  Future<Either<Failure, PedagogicResource>> uploadResource(
      PedagogicResource resource);
  Future<Either<Failure, void>> deleteResource(String id, String churchId);

  // Analytics
  Future<Either<Failure, Map<String, dynamic>>> getEnfantsKpis();
}