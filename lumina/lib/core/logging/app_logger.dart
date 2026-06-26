// lib/core/logging/app_logger.dart
// ============================================================================
// OBSERVABILITY LAYER - Frontend Logger
// Connects Flutter app to Supabase activity_log table
// ============================================================================

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Structured log entry for activity tracking
class LogEntry {
  final String action;
  final String? targetType;
  final String? targetId;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? relatedIds;
  final int? durationMs;
  final DateTime timestamp;

  LogEntry({
    required this.action,
    this.targetType,
    this.targetId,
    this.metadata,
    this.relatedIds,
    this.durationMs,
  }) : timestamp = DateTime.now().toUtc();

  Map<String, dynamic> toJson() => {
        'p_action': action,
        'p_target_type': targetType,
        'p_target_id': targetId,
        'p_metadata': {
          ...?metadata,
          'duration_ms': durationMs,
          'client_timestamp': timestamp.toIso8601String(),
        },
        'p_related_ids': relatedIds ?? {},
      };
}

/// Severity levels for logging
enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}

/// Main application logger - Singleton
class AppLogger {
  static AppLogger? _instance;
  static AppLogger get instance => _instance ??= AppLogger._();

  AppLogger._();

  // ============================================================================
  // SIMPLE LOGGING METHODS (for easy migration from debugPrint)
  // ============================================================================

  /// Debug log (filtered out in production)
  static void d(String message, [String? tag, Object? error]) {
    if (kReleaseMode) return; //  Désactivé en production
    final prefix = tag != null ? '[$tag] ' : '';
    debugPrint('🔍 DEBUG: $prefix$message');
    if (error != null && kDebugMode) {
      debugPrint('  └─ $error');
    }
  }

  /// Info log (visible in production, but not stored remotely)
  static void i(String message, [String? tag]) {
    final prefix = tag != null ? '[$tag] ' : '';
    debugPrint('ℹ️ INFO: $prefix$message');
  }

  /// Warning log
  static void w(String message, [String? tag]) {
    final prefix = tag != null ? '[$tag] ' : '';
    debugPrint(' WARNING: $prefix$message');
  }

  /// Error log (always shown, stored remotely)
  static void e(String message,
      [String? tag, Object? error, StackTrace? stackTrace]) {
    final prefix = tag != null ? '[$tag] ' : '';
    debugPrint('❌ ERROR: $prefix$message');
    if (error != null) {
      debugPrint('  └─ Error details: $error');
    }
    if (stackTrace != null && kDebugMode) {
      debugPrint('  └─ Stack trace:\n$stackTrace');
    }

    // Log to remote if initialized
    if (_instance?._initialized == true) {
      _instance!
          .logError(message, stackTrace: stackTrace.toString(), context: tag);
    }
  }

  /// Fatal/Critical error log
  static void f(String message,
      [String? tag, Object? error, StackTrace? stackTrace]) {
    final prefix = tag != null ? '[$tag] ' : '';
    debugPrint(' FATAL: $prefix$message');
    if (error != null) {
      debugPrint('  └─ Error details: $error');
    }
    if (stackTrace != null) {
      debugPrint('  └─ Stack trace:\n$stackTrace');
    }

    // Log to remote if initialized
    if (_instance?._initialized == true) {
      _instance!.logError(message,
          stackTrace: stackTrace.toString(),
          context: tag,
          level: LogLevel.critical);
    }
  }

  // ============================================================================
  // INSTANCE METHODS
  // ============================================================================

  // Configuration
  bool _initialized = false;
  String _appVersion = 'unknown';
  String _deviceType = 'unknown';
  String _deviceName = 'unknown';
  String? _sessionId;
  dynamic _localLogFile; // File? on native, null on web

  // Buffering for batch sending
  final List<LogEntry> _buffer = [];
  static const int _bufferSize = 10;
  Timer? _flushTimer;

  /// Initialize logger with device info
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Get app version with safety timeout
      final packageInfo = await PackageInfo.fromPlatform().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          debugPrint('[AppLogger] PackageInfo timeout - using defaults');
          return PackageInfo(
            appName: 'Lumina',
            packageName: 'com.lumina.app',
            version: '1.0.0',
            buildNumber: '1',
          );
        },
      );
      _appVersion = packageInfo.version;

      // Get device info with safety timeout
      final deviceInfo = DeviceInfoPlugin();
      if (kIsWeb) {
        _deviceType = 'web';
        try {
          final webInfo = await deviceInfo.webBrowserInfo.timeout(
            const Duration(seconds: 3),
          );
          _deviceName = webInfo.browserName.name;
        } catch (e) {
          debugPrint('[AppLogger] Web DeviceInfo failed/timed out: $e');
          _deviceName = 'unknown-browser';
        }
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        _deviceType = 'android';
        _deviceName = '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        _deviceType = 'ios';
        _deviceName = iosInfo.utsname.machine;
      }
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
        _deviceType = 'windows';
        _deviceName = 'Windows Desktop';

        // Initialisation du fichier de log local pour Windows (dart:io only)
        try {
          final dir = await getApplicationSupportDirectory();
          final logFile = File('${dir.path}/app_errors.log');
          if (!await logFile.exists()) {
            await logFile.create(recursive: true);
          }
          _localLogFile = logFile;
        } catch (e) {
          debugPrint('[AppLogger] Failed to init local log file: $e');
        }
      }

      // Generate session ID
      _sessionId = DateTime.now().millisecondsSinceEpoch.toRadixString(36);

      // Start periodic flush timer
      _flushTimer = Timer.periodic(
        const Duration(seconds: 30),
        (_) => _flushBuffer(),
      );

      _initialized = true;
      debugPrint('[AppLogger] Initialized: $_deviceType / $_appVersion');
    } catch (e) {
      debugPrint('[AppLogger] Init error: $e');
    }
  }

  /// Get current user ID from Supabase session
  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  /// Log a user action (navigation, button click, form submit, etc.)
  void logAction(
    String action, {
    String? targetType,
    String? targetId,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? relatedIds,
  }) {
    final entry = LogEntry(
      action: action,
      targetType: targetType,
      targetId: targetId,
      metadata: {
        ...?metadata,
        'device_type': _deviceType,
        'device_name': _deviceName,
        'app_version': _appVersion,
        'session_id': _sessionId,
      },
      relatedIds: relatedIds,
    );

    _addToBuffer(entry);

    if (kDebugMode) {
      debugPrint('[LOG] $action ${targetType ?? ''} ${targetId ?? ''}');
    }
  }

  /// Log with timing measurement
  Future<T> logTimed<T>(
    String action,
    Future<T> Function() operation, {
    String? targetType,
    String? targetId,
    Map<String, dynamic>? metadata,
  }) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await operation();
      stopwatch.stop();

      final entry = LogEntry(
        action: action,
        targetType: targetType,
        targetId: targetId,
        durationMs: stopwatch.elapsedMilliseconds,
        metadata: {
          ...?metadata,
          'success': true,
          'device_type': _deviceType,
          'app_version': _appVersion,
          'session_id': _sessionId,
        },
      );
      _addToBuffer(entry);

      return result;
    } catch (e) {
      stopwatch.stop();

      final entry = LogEntry(
        action: '$action.error',
        targetType: targetType,
        targetId: targetId,
        durationMs: stopwatch.elapsedMilliseconds,
        metadata: {
          ...?metadata,
          'success': false,
          'error': e.toString(),
          'device_type': _deviceType,
          'app_version': _appVersion,
          'session_id': _sessionId,
        },
      );
      _addToBuffer(entry);

      rethrow;
    }
  }

  /// Log a screen view
  void logScreenView(String screenName, {Map<String, dynamic>? params}) {
    logAction(
      'screen.view',
      targetType: 'screen',
      targetId: screenName,
      metadata: params,
    );
  }

  /// Log a feature usage
  void logFeatureUsage(String feature,
      {String? action, Map<String, dynamic>? metadata}) {
    logAction(
      'feature.${action ?? 'used'}',
      targetType: 'feature',
      targetId: feature,
      metadata: metadata,
    );
  }

  /// Log an error
  void logError(
    String error, {
    String? stackTrace,
    String? context,
    LogLevel level = LogLevel.error,
  }) {
    logAction(
      'app.error',
      targetType: 'error',
      metadata: {
        'error_message': error,
        'stack_trace': stackTrace,
        'context': context,
        'level': level.name,
      },
    );

    // Persistance locale sur Windows (dart:io only, skip on web)
    if (!kIsWeb && _deviceType == 'windows' && _localLogFile != null) {
      _writeToLocalLog('[$level] [$context] $error\n$stackTrace');
    }
  }

  Future<void> _writeToLocalLog(String content) async {
    if (kIsWeb || _localLogFile == null) return;
    try {
      final timestamp = DateTime.now().toIso8601String();
      final file = _localLogFile as File;
      await file.writeAsString(
        '[$timestamp] $content\n---\n',
        mode: FileMode.append,
        flush: true,
      );
    } catch (e) {
      debugPrint('[AppLogger] Echec écriture locale: $e');
    }
  }

  /// Log authentication events
  void logAuth(String event, {String? method, bool success = true}) {
    logAction(
      'auth.$event',
      targetType: 'auth',
      metadata: {
        'method': method,
        'success': success,
      },
    );
  }

  /// Log API/repository calls
  void logApiCall(
    String endpoint, {
    String? method,
    int? statusCode,
    int? durationMs,
    bool success = true,
  }) {
    logAction(
      'api.call',
      targetType: 'api',
      targetId: endpoint,
      metadata: {
        'method': method,
        'status_code': statusCode,
        'duration_ms': durationMs,
        'success': success,
      },
    );
  }

  // Buffer management
  void _addToBuffer(LogEntry entry) {
    _buffer.add(entry);
    if (_buffer.length >= _bufferSize) {
      _flushBuffer();
    }
  }

  Future<void> _flushBuffer() async {
    if (_buffer.isEmpty) return;
    if (_currentUserId == null) {
      // Not logged in, clear buffer
      _buffer.clear();
      return;
    }

    final entriesToSend = List<LogEntry>.from(_buffer);
    _buffer.clear();

    try {
      final client = Supabase.instance.client;

      for (final entry in entriesToSend) {
        await client.rpc('log_activity', params: {
          ...entry.toJson(),
          'p_actor_user_id': _currentUserId,
          'p_actor_type': 'user',
        });
      }

      if (kDebugMode) {
        debugPrint('[AppLogger] Flushed ${entriesToSend.length} entries');
      }
    } catch (e) {
      // Re-add failed entries to buffer (limited retry)
      if (_buffer.length < _bufferSize * 2) {
        _buffer.insertAll(0, entriesToSend);
      }
      debugPrint('[AppLogger] Flush error: $e');
    }
  }

  /// Force flush (call on app pause/close)
  Future<void> flush() async {
    await _flushBuffer();
  }

  /// Dispose resources
  void dispose() {
    _flushTimer?.cancel();
    _flushBuffer();
  }
}

// Convenience global accessor
AppLogger get logger => AppLogger.instance;
