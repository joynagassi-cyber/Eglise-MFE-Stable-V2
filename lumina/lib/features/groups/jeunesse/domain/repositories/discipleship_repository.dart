import 'package:dartz/dartz.dart';
import 'package:lumina/core/error/failures.dart';
import '../entities/discipleship_program.dart';

abstract class IDiscipleshipRepository {
  Future<Either<Failure, List<DiscipleshipProgram>>> getPrograms(
      String groupId);
  Future<Either<Failure, List<DiscipleshipProgram>>> getProgramsByGroup(
      String groupId);
  Future<Either<Failure, DiscipleshipProgram>> addProgram(
      DiscipleshipProgram program);
  Future<Either<Failure, DiscipleshipProgram>> updateProgram(
      DiscipleshipProgram program);
  Future<Either<Failure, Unit>> deleteProgram(String id, String churchId);
  Future<Either<Failure, void>> syncPrograms();
}