import 'package:flutter/foundation.dart';

/// Base des erreurs de l'application Lumina
@immutable
sealed class AppFailure {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppFailure({required this.message, this.code, this.originalError});

  @override
  String toString() => 'AppFailure(message: $message, code: $code)';
}

/// Erreur provenant du serveur (Supabase)
final class ServerFailure extends AppFailure {
  const ServerFailure({required super.message, super.code, super.originalError});
}

/// Erreur provenant de la base locale (Isar)
final class CacheFailure extends AppFailure {
  const CacheFailure({required super.message, super.code, super.originalError});
}

/// Erreur de sécurité (Multi-tenant)
final class SecurityFailure extends AppFailure {
  const SecurityFailure({required super.message, super.code, super.originalError});
}

/// Erreur de réseau
final class NetworkFailure extends AppFailure {
  const NetworkFailure({required super.message, super.code, super.originalError});
}
