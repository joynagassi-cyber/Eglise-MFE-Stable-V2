import 'package:dartz/dartz.dart';
import 'package:lumina/core/error/failures.dart';
import 'package:lumina/core/auth/domain/entities/user_session.dart';
import 'package:lumina/features/auth/domain/repositories/auth_repository.dart';

class SignupParams {
  final String email;
  final String password;
  final String name;

  const SignupParams({
    required this.email,
    required this.password,
    required this.name,
  });
}

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<Either<Failure, UserSession?>> call(SignupParams params) async {
    if (params.email.isEmpty || !params.email.contains('@')) {
      return const Left(ValidationFailure('Invalid email'));
    }
    if (params.password.length < 6) {
      return const Left(
          ValidationFailure('Password must be at least 6 characters'));
    }

    return repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}