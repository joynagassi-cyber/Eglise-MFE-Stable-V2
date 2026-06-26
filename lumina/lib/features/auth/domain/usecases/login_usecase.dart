import 'package:dartz/dartz.dart';
import 'package:lumina/core/error/failures.dart';
import 'package:lumina/core/auth/domain/entities/user_session.dart';
import 'package:lumina/features/auth/domain/repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserSession>> call(LoginParams params) async {
    return repository.login(
      email: params.email,
      password: params.password,
    );
  }
}