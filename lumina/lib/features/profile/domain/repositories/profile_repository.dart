import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile(String id);
  Future<Either<Failure, Profile>> updateProfile(Profile profile);
  Future<Either<Failure, Unit>> completeOnboarding(String id);
  Stream<Profile?> watchProfile(String id);
}