import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:lumina/core/monitoring/sentry_stub.dart';
import '../logging/app_logger.dart';

// Conditional dart:io import — ProcessInfo not available on web
import 'performance_monitor_io.dart'
    if (dart.library.html) 'performance_monitor_web.dart' as platform;

/// Monitoring de performance unifié pour Lumina
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._();

  final _startupStopwatch = Stopwatch();
  int? _coldStartupMs;
  final Map<String, Stopwatch> _activeTraces = {};

  // Callback pour les mises à jour UI (Riverpod)
  void Function(double fps, int memoryMb)? _onStatsUpdate;

  // Rétention des tags globaux (Church, User)
  final Map<String, String> _tags = {};

  // Monitoring des Frames
  int _frameCount = 0;
  int _droppedFrames = 0;
  Timer? _fpsTimer;

  // Monitoring Réseau
  final Map<String, DateTime> _pendingRequests = {};

  /// Définit des tags globaux pour toutes les métriques suivantes
  void setTags(Map<String, String> tags) {
    _tags.addAll(tags);
    Sentry.configureScope((scope) {
      tags.forEach((key, value) => scope.setTag(key, value));
    });
  }

  /// Démarre le chrono au lancement de l'app
  void startMonitoring() {
    _startupStopwatch.start();
  }

  /// Enregistre la fin du démarrage à froid
  void recordColdStartup() {
    if (_coldStartupMs != null) return;
    _coldStartupMs = _startupStopwatch.elapsedMilliseconds;
    _startupStopwatch.stop();

    _logMetric('app_startup_cold', _coldStartupMs!, {
      'type': 'startup',
    });

    if (kDebugMode) {
      debugPrint(' Cold startup: ${_coldStartupMs}ms');
    }
  }

  /// Démarre une trace personnalisée
  void startTrace(String name) {
    _activeTraces[name] = Stopwatch()..start();
  }

  /// Arrête une trace et enregistre la durée
  void stopTrace(String name, {Map<String, dynamic>? metadata}) {
    final stopwatch = _activeTraces.remove(name);
    if (stopwatch != null) {
      stopwatch.stop();
      _logMetric('trace_$name', stopwatch.elapsedMilliseconds, metadata);
    }
  }

  /// Mesure une opération asynchrone
  Future<T> measureAsync<T>(
    String operationName,
    Future<T> Function() operation, {
    Map<String, dynamic>? metadata,
  }) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await operation();
      stopwatch.stop();
      _logMetric(operationName, stopwatch.elapsedMilliseconds, {
        if (metadata != null) ...metadata,
        'success': true,
      });
      return result;
    } catch (e) {
      stopwatch.stop();
      _logMetric(operationName, stopwatch.elapsedMilliseconds, {
        if (metadata != null) ...metadata,
        'success': false,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Active le monitoring des frames (FPS/Drops)
  void startFrameMonitoring() {
    if (_fpsTimer != null) return;

    SchedulerBinding.instance.addTimingsCallback(_onFrameTimings);

    // Rapport toutes les 30 secondes
    _fpsTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _reportStats();
    });
  }

  void _onFrameTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      _frameCount++;
      // Un frame est considéré comme "dropped" s'il dépasse 16.67ms (cible 60fps)
      if (timing.totalSpan.inMilliseconds > 16) {
        _droppedFrames++;
      }
    }
  }

  /// Mesure la latence réseau (début)
  void startNetworkRequest(String url) {
    _pendingRequests[url] = DateTime.now();
  }

  /// Mesure la latence réseau (fin)
  void stopNetworkRequest(String url, {int? statusCode}) {
    final startTime = _pendingRequests.remove(url);
    if (startTime != null) {
      final latency = DateTime.now().difference(startTime).inMilliseconds;
      _logMetric('network_latency', latency, {
        'url': url,
        'status_code': statusCode,
      });
    }
  }

  void _reportStats() {
    if (_frameCount == 0) return;

    final dropRate = (_droppedFrames / _frameCount * 100);

    // Log des stats de fluidité
    _logMetric('ui_frame_stats', _frameCount, {
      'dropped_frames': _droppedFrames,
      'drop_rate_percent': dropRate.toStringAsFixed(2),
    });

    // Log de la mémoire (RSS) - Non supporté sur Web
    int memoryUsageMb = 0;
    if (!kIsWeb) {
      try {
        memoryUsageMb = platform.getMemoryUsageMb();
        if (memoryUsageMb > 0) {
          _logMetric('memory_usage_mb', memoryUsageMb, {
            'type': 'rss',
          });
        }
      } catch (e, stack) {
        AppLogger.e('Error recording memory usage', 'PERF_MONITOR', e, stack);
      }
    }

    // Reset counters
    _frameCount = 0;
    _droppedFrames = 0;

    // Notify listener
    _onStatsUpdate?.call(60 - (dropRate * 0.6), memoryUsageMb);
  }

  void setStatsListener(void Function(double fps, int memoryMb) listener) {
    _onStatsUpdate = listener;
  }

  /// Démarre une transaction Sentry manuelle
  ISentrySpan? startSentryTransaction(String name, String op,
      {Map<String, dynamic>? tags}) {
    final transaction = Sentry.startTransaction(name, op, bindToScope: true);
    if (tags != null) {
      tags.forEach((key, value) => transaction.setData(key, value));
    }
    return transaction;
  }

  /// Log interne vers Sentry et AppLogger
  void _logMetric(String name, num value, [Map<String, dynamic>? metadata]) {
    final fullMetadata = {
      if (metadata != null) ...metadata,
      ..._tags,
    };

    // 1. Log Local
    AppLogger.d('Metric [$name]: $value $fullMetadata', 'PERF');

    // 2. Sentry (si initialisé)
    final activeTransaction = Sentry.getSpan();
    if (activeTransaction != null) {
      activeTransaction.setMeasurement(name, value);
    } else {
      Sentry.configureScope((scope) {
        scope.setExtra(name, value);
        fullMetadata.forEach((key, val) => scope.setExtra('$name.$key', val));
      });
    }
  }

  void dispose() {
    _fpsTimer?.cancel();
    _fpsTimer = null;
    _startupStopwatch.stop();
    _activeTraces.clear();
  }

  int? get coldStartupMs => _coldStartupMs;
}
