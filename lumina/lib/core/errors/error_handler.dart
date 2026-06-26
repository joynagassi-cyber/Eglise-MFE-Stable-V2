import 'package:lumina/core/logging/app_logger.dart';
import 'package:lumina/core/monitoring/sentry_stub.dart';

sealed class AppException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const AppException(this.message, {this.code, this.stackTrace});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.stackTrace});
}

class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.stackTrace});
}

class ValidationException extends AppException {
  final Map<String, String> errors;
  const ValidationException(super.message, this.errors,
      {super.code, super.stackTrace});
}

class PermissionException extends AppException {
  const PermissionException(super.message, {super.code, super.stackTrace});
}

class DataException extends AppException {
  const DataException(super.message, {super.code, super.stackTrace});
}

class ErrorHandler {
  static String getUserMessage(Object error) {
    return switch (error) {
      NetworkException() => 'Problème de connexion. Vérifiez votre réseau.',
      AuthException() => 'Session expirée. Reconnectez-vous.',
      PermissionException() => 'Vous n\'avez pas les droits nécessaires.',
      ValidationException(errors: final e) => e.values.first,
      DataException() => 'Erreur de données. Réessayez.',
      _ => 'Une erreur est survenue. Réessayez.',
    };
  }

  static void logError(Object error, StackTrace? stack, {String? context}) {
    final tag = context ?? 'ERROR_HANDLER';
    AppLogger.e('Error occurred', tag, error, stack);

    if (error is! AppException) {
      Sentry.captureException(error, stackTrace: stack);
    }
  }

  static AppException wrapException(Object error, {StackTrace? stack}) {
    if (error is AppException) return error;

    final message = error.toString();

    if (message.contains('network') || message.contains('connection')) {
      return NetworkException(message, stackTrace: stack);
    }

    if (message.contains('auth') || message.contains('token')) {
      return AuthException(message, stackTrace: stack);
    }

    return DataException(message, stackTrace: stack);
  }
}
