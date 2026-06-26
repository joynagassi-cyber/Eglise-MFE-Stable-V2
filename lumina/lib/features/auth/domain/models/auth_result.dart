// lib/features/auth/domain/models/auth_result.dart

import 'package:equatable/equatable.dart';

class AuthResult extends Equatable {
  final String idToken;
  final String accessToken;
  final String? email;
  final String? name;

  const AuthResult({
    required this.idToken,
    required this.accessToken,
    this.email,
    this.name,
  });

  @override
  List<Object?> get props => [idToken, accessToken, email, name];
}
