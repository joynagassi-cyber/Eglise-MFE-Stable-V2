import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    if (newPassword.length < 6) {
      return const Left(
          ValidationFailure('Password must be at least 6 characters'));
    }
    return repository.changePassword(
      userId: userId,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}