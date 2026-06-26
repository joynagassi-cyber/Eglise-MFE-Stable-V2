import 'package:lumina/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/camp.dart';

abstract class ICampRepository {
  Future<Either<Failure, List<Camp>>> getCamps(String groupId);
  Future<Either<Failure, List<Camp>>> getCampsByGroup(String groupId);
  Future<Either<Failure, Camp>> createCamp(Camp camp);
  Future<Either<Failure, Camp>> updateCamp(Camp camp);
  Future<Either<Failure, void>> deleteCamp(String id);
  Future<Either<Failure, void>> syncCamps();
}