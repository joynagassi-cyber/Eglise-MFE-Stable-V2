// lib/core/logging/error_reporter.dart
// ============================================================================
// ERROR REPORTER
// Centralized error handling and reporting
// ============================================================================

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'app_logger.dart';
import 'analytics_events.dart';

/// Error severity levels
enum ErrorSeverity {
  low,
  medium,
  high,
  critical,
}

/// Structured error report
class ErrorReport {
  final dynamic error;
  final StackTrace? stackTrace;
  final String? context;
  final ErrorSeverity severity;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  ErrorReport({
    required this.error,
    this.stackTrace,
    this.context,
    this.severity = ErrorSeverity.medium,
    this.metadata,
  }) : timestamp = DateTime.now();

  Map<String, dynamic> toJson() => {
        'error_type': error.runtimeType.toString(),
        'error_message': error.toString(),
        'stack_trace': stackTrace?.toString(),
        'context': context,
        'severity': severity.name,
        'timestamp': timestamp.toIso8601String(),
        ...?metadata,
      };
}

/// Centralized error reporter
class ErrorReporter {
  static ErrorReporter? _instance;
  static ErrorReporter get instance => _instance ??= ErrorReporter._();

  ErrorReporter._();

  /// Report an error with context
  void reportError(
    dynamic error, {
    StackTrace? stackTrace,
    String? context,
    ErrorSeverity severity = ErrorSeverity.medium,
    Map<String, dynamic>? metadata,
  }) {
    final report = ErrorReport(
      error: error,
      stackTrace: stackTrace,
      context: context,
      severity: severity,
      metadata: metadata,
    );

    // Log to console/local
    if (severity == ErrorSeverity.critical) {
      AppLogger.f(error.toString(), context, error, stackTrace);
    } else {
      AppLogger.e(error.toString(), context, error, stackTrace);
    }

    // Send to activity_log (already covered by AppLogger.e/f if initialized)
    // Mais on garde pour la structure spécifique si besoin
    _sendToActivityLog(report);
  }

  /// Report a network/API error
  void reportApiError(
    String endpoint,
    dynamic error, {
    int? statusCode,
    String? method,
    StackTrace? stackTrace,
  }) {
    reportError(
      error,
      stackTrace: stackTrace,
      context: 'API: $method $endpoint',
      severity: _getApiErrorSeverity(statusCode),
      metadata: {
        'endpoint': endpoint,
        'method': method,
        'status_code': statusCode,
        'error_category': ErrorEvents.apiError,
      },
    );
  }

  /// Report a validation error
  void reportValidationError(
    String field,
    String message, {
    dynamic value,
    String? screen,
  }) {
    logger.logAction(
      ErrorEvents.validationError,
      targetType: 'validation',
      targetId: field,
      metadata: {
        'field': field,
        'message': message,
        'value_type': value?.runtimeType.toString(),
        'screen': screen,
      },
    );
  }

  /// Report a permission denied error
  void reportPermissionDenied(
    String permission, {
    String? attemptedAction,
    String? resource,
  }) {
    reportError(
      'Permission denied: $permission',
      context: attemptedAction,
      severity: ErrorSeverity.medium,
      metadata: {
        'permission': permission,
        'attempted_action': attemptedAction,
        'resource': resource,
        'error_category': ErrorEvents.permissionDenied,
      },
    );
  }

  ErrorSeverity _getApiErrorSeverity(int? statusCode) {
    if (statusCode == null) return ErrorSeverity.high;

    if (statusCode >= 500) return ErrorSeverity.critical;
    if (statusCode == 401 || statusCode == 403) return ErrorSeverity.medium;
    if (statusCode >= 400) return ErrorSeverity.low;

    return ErrorSeverity.low;
  }

  void _sendToActivityLog(ErrorReport report) {
    logger.logAction(
      'error.reported',
      targetType: 'error',
      metadata: report.toJson(),
    );
  }

  /// Setup global error handlers
  void setupGlobalHandlers() {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      reportError(
        details.exception,
        stackTrace: details.stack,
        context: 'Flutter Framework: ${details.library}',
        severity: ErrorSeverity.high,
        metadata: {
          'library': details.library,
          'context': details.context?.toString(),
        },
      );

      // Still print to console in debug mode
      if (kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };

    // Catch async errors not caught by Flutter
    PlatformDispatcher.instance.onError = (error, stack) {
      reportError(
        error,
        stackTrace: stack,
        context: 'Platform Async Error',
        severity: ErrorSeverity.critical,
      );
      return true; // Handled
    };
  }
}

// Convenience accessor
ErrorReporter get errorReporter => ErrorReporter.instance;

/// Zone wrapper for catching all errors in a zone
R runWithErrorReporting<R>(R Function() body) {
  return runZonedGuarded(
    body,
    (error, stackTrace) {
      errorReporter.reportError(
        error,
        stackTrace: stackTrace,
        context: 'Uncaught Zone Error',
        severity: ErrorSeverity.critical,
      );
    },
  ) as R;
}
