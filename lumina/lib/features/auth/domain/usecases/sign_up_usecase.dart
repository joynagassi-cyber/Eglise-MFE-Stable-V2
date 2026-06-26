// lib/features/auth/domain/usecases/sign_up_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/auth/domain/entities/user_session.dart';
import '../repositories/auth_repository.dart';

class SignUpParams {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  SignUpParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
}

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<Either<Failure, UserSession?>> call(SignUpParams params) {
    return _repository.register(
      name: '${params.firstName} ${params.lastName}',
      email: params.email,
      password: params.password,
    );
  }
}