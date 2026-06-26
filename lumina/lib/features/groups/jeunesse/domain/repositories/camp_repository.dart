import 'package:dartz/dartz.dart';
import 'package:lumina/core/error/failures.dart';
import '../entities/camp.dart';

abstract class ICampRepository {
  Future<Either<Failure, List<Camp>>> getCamps(String groupId);
  Future<Either<Failure, List<Camp>>> getCampsByGroup(String groupId);
  Future<Either<Failure, Camp>> addCamp(Camp camp);
  Future<Either<Failure, Camp>> updateCamp(Camp camp);
  Future<Either<Failure, Unit>> deleteCamp(String id, String churchId);
  Future<Either<Failure, void>> syncCamps();
}