import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/church_service.dart';
import '../../../../features/churches/presentation/providers/church_providers.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';

final celebrationsProvider = StreamProvider<List<ChurchService>>((ref) {
  final repository = ref.watch(celebrationRepositoryProvider);
  final activeChurchAsync = ref.watch(activeChurchProvider);

  return activeChurchAsync.when(
    data: (church) {
      if (church == null) {
        return Stream.value([]);
      }
      return repository.watchServices(church.id);
    },
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
});

// Helper for filtering by type if needed
final celebrationsByTypeProvider =
    StreamProvider.family<List<ChurchService>, ServiceType>((ref, type) {
  final celebrations = ref.watch(celebrationsProvider).value ?? [];
  return Stream.value(celebrations.where((s) => s.type == type).toList());
});
