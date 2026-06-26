import 'package:dartz/dartz.dart';
import 'package:lumina/core/error/failures.dart';
import '../entities/training.dart';
import '../entities/mutual_aid_request.dart';

abstract class FemmesRepository {
  /// Formations
  Future<Either<Failure, List<Training>>> getTrainings(String groupId);
  Future<Either<Failure, Training>> addTraining(Training training);
  Future<Either<Failure, Training>> updateTraining(Training training);
  Future<Either<Failure, Unit>> deleteTraining(String id, String churchId);
  Future<Either<Failure, Unit>> enrollInTraining(
      String trainingId, String memberId);

  /// Entraide
  Future<Either<Failure, List<MutualAidRequest>>> getMutualAidRequests(
      String groupId);
  Future<Either<Failure, MutualAidRequest>> addMutualAidRequest(
      MutualAidRequest request);
  Future<Either<Failure, MutualAidRequest>> updateMutualAidRequest(
      MutualAidRequest request);
  Future<Either<Failure, Unit>> deleteMutualAidRequest(
      String id, String churchId);
}