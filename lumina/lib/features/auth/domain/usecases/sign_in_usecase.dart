// lib/features/auth/domain/usecases/sign_in_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/auth/domain/entities/user_session.dart';
import '../repositories/auth_repository.dart';

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}

class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<Either<Failure, UserSession>> call(SignInParams params) {
    return _repository.login(
      email: params.email,
      password: params.password,
    );
  }
}