import 'package:dartz/dartz.dart';
import 'package:lumina/core/error/failures.dart';
import 'package:lumina/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return repository.logout();
  }
}