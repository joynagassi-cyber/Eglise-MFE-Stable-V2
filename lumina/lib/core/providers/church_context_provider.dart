import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/providers/auth_state_leaf.dart';
import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/logging/app_logger.dart';

/// Provider that enforces strict church context boundaries.
/// When the church ID changes, this provider clears relevant local data
/// to prevent any data leakage between churches.
final strictChurchContextProvider = Provider<void>((ref) {
  // Listen to church ID changes
  ref.listen<String?>(activeChurchIdStateProvider, (previous, next) {
    if (previous != next && previous != null && next != null) {
      AppLogger.i(
          'Church context switched from $previous to $next. Purging local caches...',
          'STRICT_CONTEXT');

      final isarService = ref.read(isarServiceProvider);
      if (isarService.isReady) {
        // Clean up Isar local collections (groups, events, etc.)
        isarService.clearChurchSpecificData().catchError((e) {
          AppLogger.e('Failed to clear church specific data on switch: $e',
              'STRICT_CONTEXT');
        });
      }
    }
  });
});
