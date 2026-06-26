import 'package:lumina/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/discipleship_program.dart';

abstract class IDiscipleshipRepository {
  Future<Either<Failure, List<DiscipleshipProgram>>> getPrograms(
      String groupId);
  Future<Either<Failure, List<DiscipleshipProgram>>> getProgramsByGroup(
      String groupId);
  Future<Either<Failure, DiscipleshipProgram>> createProgram(
      DiscipleshipProgram program);
  Future<Either<Failure, DiscipleshipProgram>> updateProgram(
      DiscipleshipProgram program);
  Future<Either<Failure, void>> deleteProgram(String id);
  Future<Either<Failure, void>> syncPrograms();
}