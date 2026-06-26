import 'dart:async';

/// Helper pour retry automatique avec backoff exponentiel
///
/// Usage:
/// ```dart
/// final data = await RetryHelper.withRetry(
///   operation: () => supabase.from('table').select(),
///   maxAttempts: 3,
/// );
/// ```
class RetryHelper {
  static Future<T> withRetry<T>({
    required Future<T> Function() operation,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    bool Function(dynamic)? shouldRetry,
  }) async {
    int attempt = 0;

    while (true) {
      try {
        return await operation();
      } catch (e) {
        attempt++;

        // Vérifier si on doit retry
        if (attempt >= maxAttempts) rethrow;
        if (shouldRetry != null && !shouldRetry(e)) rethrow;

        // Backoff exponentiel: 1s, 2s, 4s, 8s...
        final delay = initialDelay * (1 << (attempt - 1));
        await Future.delayed(delay);
      }
    }
  }
}
