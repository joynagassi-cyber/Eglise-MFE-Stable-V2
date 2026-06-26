// lib/core/logging/instrumented_repository.dart
// ============================================================================
// INSTRUMENTED REPOSITORY WRAPPER
// Automatically logs all repository operations with timing and error tracking
// ============================================================================

import 'package:flutter/foundation.dart';
import 'app_logger.dart';
import 'error_reporter.dart';

/// Mixin for adding instrumentation to repositories
mixin InstrumentedRepository {
  String get repositoryName;

  /// Wrap a repository operation with logging, timing, and error handling
  Future<T> instrumented<T>(
    String operation,
    Future<T> Function() action, {
    String? targetType,
    String? targetId,
    Map<String, dynamic>? metadata,
  }) async {
    final fullEventName = '$repositoryName.$operation';
    final stopwatch = Stopwatch()..start();

    try {
      final result = await action();
      stopwatch.stop();

      logger.logAction(
        fullEventName,
        targetType: targetType ?? repositoryName,
        targetId: targetId,
        metadata: {
          ...?metadata,
          'success': true,
          'duration_ms': stopwatch.elapsedMilliseconds,
        },
      );

      if (kDebugMode && stopwatch.elapsedMilliseconds > 500) {
        AppLogger.w(
            'PERF WARNING: $fullEventName took ${stopwatch.elapsedMilliseconds}ms',
            'REPO_TRACE');
      }

      return result;
    } catch (e, st) {
      stopwatch.stop();

      logger.logAction(
        '$fullEventName.error',
        targetType: targetType ?? repositoryName,
        targetId: targetId,
        metadata: {
          ...?metadata,
          'success': false,
          'duration_ms': stopwatch.elapsedMilliseconds,
          'error_type': e.runtimeType.toString(),
        },
      );

      errorReporter.reportError(
        e,
        stackTrace: st,
        context: fullEventName,
        metadata: {
          'repository': repositoryName,
          'operation': operation,
          'target_id': targetId,
        },
      );

      rethrow;
    }
  }

  /// Wrap a stream-returning operation
  Stream<T> instrumentedStream<T>(
    String operation,
    Stream<T> Function() streamProvider, {
    String? targetType,
    Map<String, dynamic>? metadata,
  }) {
    final fullEventName = '$repositoryName.$operation.stream';

    logger.logAction(
      '$fullEventName.subscribed',
      targetType: targetType ?? repositoryName,
      metadata: metadata,
    );

    return streamProvider().handleError((error, stackTrace) {
      logger.logAction(
        '$fullEventName.error',
        targetType: targetType ?? repositoryName,
        metadata: {
          ...?metadata,
          'error': error.toString(),
        },
      );
    });
  }
}

/// Utility class for logging CRUD operations
class CrudLogger {
  final String entityType;

  CrudLogger(this.entityType);

  void logCreate(String? id, {Map<String, dynamic>? metadata}) {
    logger.logAction(
      '$entityType.created',
      targetType: entityType,
      targetId: id,
      metadata: metadata,
    );
  }

  void logRead(String? id, {Map<String, dynamic>? metadata}) {
    logger.logAction(
      '$entityType.viewed',
      targetType: entityType,
      targetId: id,
      metadata: metadata,
    );
  }

  void logUpdate(String? id, {Map<String, dynamic>? metadata}) {
    logger.logAction(
      '$entityType.updated',
      targetType: entityType,
      targetId: id,
      metadata: metadata,
    );
  }

  void logDelete(String? id, {Map<String, dynamic>? metadata}) {
    logger.logAction(
      '$entityType.deleted',
      targetType: entityType,
      targetId: id,
      metadata: metadata,
    );
  }

  void logList({int? count, Map<String, dynamic>? metadata}) {
    logger.logAction(
      '$entityType.listed',
      targetType: entityType,
      metadata: {
        ...?metadata,
        'result_count': count,
      },
    );
  }

  void logSearch(String query,
      {int? resultCount, Map<String, dynamic>? metadata}) {
    logger.logAction(
      '$entityType.searched',
      targetType: entityType,
      metadata: {
        ...?metadata,
        'query_length': query.length,
        'result_count': resultCount,
      },
    );
  }

  void logExport(String format, {int? count, Map<String, dynamic>? metadata}) {
    logger.logAction(
      '$entityType.exported',
      targetType: entityType,
      metadata: {
        ...?metadata,
        'format': format,
        'record_count': count,
      },
    );
  }
}

/// Pre-configured CRUD loggers for common entities
class EntityLoggers {
  static final member = CrudLogger('member');
  static final transaction = CrudLogger('transaction');
  static final budget = CrudLogger('budget');
  static final event = CrudLogger('event');
  static final celebration = CrudLogger('celebration');
  static final sacrament = CrudLogger('sacrament');
  static final annonce = CrudLogger('annonce');
  static final post = CrudLogger('post');
  static final message = CrudLogger('message');
  static final team = CrudLogger('team');
  static final church = CrudLogger('church');
  static final category = CrudLogger('category');
  static final group = CrudLogger('group');
}
