import 'package:lumina/core/services/offline_sync_worker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OfflineSyncWorker backoff', () {
    test('backoffDelayForAttempts uses exponential seconds', () {
      expect(
        OfflineSyncWorker.backoffDelayForAttempts(1),
        const Duration(seconds: 2),
      );
      expect(
        OfflineSyncWorker.backoffDelayForAttempts(2),
        const Duration(seconds: 4),
      );
      expect(
        OfflineSyncWorker.backoffDelayForAttempts(3),
        const Duration(seconds: 8),
      );
    });

    test('shouldSkipDueToBackoff returns false when attempts <= 0', () {
      final now = DateTime.utc(2026, 1, 1);

      expect(
        OfflineSyncWorker.shouldSkipDueToBackoff(
          now: now,
          attempts: 0,
          lastUpdated: now,
        ),
        isFalse,
      );
      expect(
        OfflineSyncWorker.shouldSkipDueToBackoff(
          now: now,
          attempts: -1,
          lastUpdated: now,
        ),
        isFalse,
      );
    });

    test('shouldSkipDueToBackoff returns false when lastUpdated is null', () {
      final now = DateTime.utc(2026, 1, 1, 0, 0, 10);

      expect(
        OfflineSyncWorker.shouldSkipDueToBackoff(
          now: now,
          attempts: 1,
          lastUpdated: null,
        ),
        isFalse,
      );
    });

    test('shouldSkipDueToBackoff returns true when still in backoff window',
        () {
      final now = DateTime.utc(2026, 1, 1, 0, 0, 10);
      final lastUpdated = DateTime.utc(2026, 1, 1, 0, 0, 9);

      expect(
        OfflineSyncWorker.shouldSkipDueToBackoff(
          now: now,
          attempts: 1, // backoff = 2s -> nextRetry = 00:00:11
          lastUpdated: lastUpdated,
        ),
        isTrue,
      );
    });

    test('shouldSkipDueToBackoff returns false when backoff window elapsed',
        () {
      final now = DateTime.utc(2026, 1, 1, 0, 0, 10);
      final lastUpdated = DateTime.utc(2026, 1, 1, 0, 0, 7);

      expect(
        OfflineSyncWorker.shouldSkipDueToBackoff(
          now: now,
          attempts: 1, // nextRetry = 00:00:09
          lastUpdated: lastUpdated,
        ),
        isFalse,
      );
    });

    test('nextRetryAt returns now when lastUpdated is null', () {
      final now = DateTime.utc(2026, 1, 1, 0, 0, 10);

      expect(
        OfflineSyncWorker.nextRetryAt(
          now: now,
          attempts: 2,
          lastUpdated: null,
        ),
        now,
      );
    });
  });
}
