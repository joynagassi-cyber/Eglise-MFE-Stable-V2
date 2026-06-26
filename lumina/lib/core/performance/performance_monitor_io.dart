// lib/core/performance/performance_monitor_io.dart
// Native platform implementation — uses dart:io ProcessInfo
import 'dart:io';

int getMemoryUsageMb() {
  try {
    return (ProcessInfo.currentRss / (1024 * 1024)).toInt();
  } catch (_) {
    return 0;
  }
}
