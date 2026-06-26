import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/features/churches/presentation/providers/church_providers.dart';
import 'package:lumina/features/bergers/domain/entities/shepherd.dart';
import 'package:lumina/features/bergers/domain/entities/pastoral_visit.dart';

part 'shepherd_providers.g.dart';

// Using shepherdRepositoryProvider from global_providers.dart

@riverpod
Future<List<Shepherd>> shepherdList(ShepherdListRef ref) async {
  final repository = ref.watch(shepherdRepositoryProvider);
  final activeChurch = await ref.watch(activeChurchProvider.future);
  return repository.getShepherds(churchId: activeChurch?.id);
}

@riverpod
Future<Shepherd?> currentShepherd(CurrentShepherdRef ref, String id) {
  final repository = ref.watch(shepherdRepositoryProvider);
  return repository.getShepherdById(id);
}

// For backward compatibility with existing TeamListScreen if needed
// though I should probably update the screen to use shepherdListProvider
@riverpod
Future<List<Shepherd>> teamList(TeamListRef ref) {
  return ref.watch(shepherdListProvider.future);
}

@riverpod
Future<List<PastoralVisit>> pastoralVisits(
  PastoralVisitsRef ref, {
  String? shepherdId,
}) {
  final repository = ref.watch(shepherdRepositoryProvider);
  return repository.getPastoralVisits(shepherdId: shepherdId);
}

@riverpod
class ShepherdController extends _$ShepherdController {
  @override
  FutureOr<void> build() {}

  Future<void> logVisit(PastoralVisit visit) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(shepherdRepositoryProvider).logPastoralVisit(visit);
      ref.invalidate(pastoralVisitsProvider);
    });
  }
}
