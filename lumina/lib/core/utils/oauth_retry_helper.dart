import 'dart:async';
import 'dart:io';

class OAuthRetryHelper {
  static const _timeouts = [
    Duration(seconds: 15),
    Duration(seconds: 30),
    Duration(seconds: 45),
  ];

  static const _maxAttempts = 3;

  static Future<T> executeWithRetry<T>({
    required Future<T> Function() action,
    required String actionName,
    void Function(int attempt, Duration timeout)? onRetry,
  }) async {
    int attempt = 0;

    while (attempt < _maxAttempts) {
      try {
        return await action().timeout(
          _timeouts[attempt],
          onTimeout: () {
            if (attempt < _maxAttempts - 1) {
              throw TimeoutException('Retry attempt $attempt');
            }
            throw TimeoutException(
                'La connexion $actionName a pris trop de temps. '
                'Vérifiez votre connexion internet et réessayez.');
          },
        );
      } catch (e) {
        if (e is TimeoutException ||
            e is SocketException ||
            e is HttpException) {
          attempt++;

          if (attempt >= _maxAttempts) {
            rethrow;
          }

          onRetry?.call(attempt, _timeouts[attempt]);

          await Future.delayed(Duration(seconds: 2 * attempt));
        } else {
          rethrow;
        }
      }
    }

    throw Exception('Max attempts reached');
  }
}
