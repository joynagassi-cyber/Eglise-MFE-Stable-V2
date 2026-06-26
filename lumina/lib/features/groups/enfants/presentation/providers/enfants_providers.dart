import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/child_safety_card.dart';
import '../../domain/entities/children_program.dart';
import '../../domain/entities/pedagogic_resource.dart';
import '../../domain/repositories/enfants_repository.dart';
import '../../data/repositories/enfants_repository_impl.dart';
import '../../../../../core/services/offline_sync_manager.dart';
import '../../../../../core/data/local/isar_service.dart';
import '../../../../../core/providers/church_provider.dart';

part 'enfants_providers.g.dart';

@riverpod
EnfantsRepository enfantsRepository(EnfantsRepositoryRef ref) {
  return EnfantsRepositoryImpl(
    Supabase.instance.client,
    ref.watch(isarServiceProvider),
    ref.watch(offlineSyncManagerProvider),
  );
}

@riverpod
class SafetyCardsNotifier extends _$SafetyCardsNotifier {
  @override
  Future<List<ChildSafetyCard>> build() async {
    final repo = ref.watch(enfantsRepositoryProvider);
    final result = await repo.getSafetyCards();
    return result.fold(
      (l) => throw Exception(l),
      (r) => r,
    );
  }

  Future<void> updateCard(ChildSafetyCard card) async {
    state = const AsyncValue.loading();
    final result =
        await ref.read(enfantsRepositoryProvider).updateSafetyCard(card);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }

  Future<void> deleteCard(String id) async {
    final churchId = ref.read(effectiveChurchIdProvider);
    final result = await ref
        .read(enfantsRepositoryProvider)
        .deleteSafetyCard(id, churchId);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }
}

@riverpod
class ChildrenProgramsNotifier extends _$ChildrenProgramsNotifier {
  @override
  Future<List<ChildrenProgram>> build() async {
    final repo = ref.watch(enfantsRepositoryProvider);
    final result = await repo.getPrograms();
    return result.fold(
      (l) => throw Exception(l),
      (r) => r,
    );
  }
}

@riverpod
class PedagogicResourcesNotifier extends _$PedagogicResourcesNotifier {
  @override
  Future<List<PedagogicResource>> build() async {
    final repo = ref.watch(enfantsRepositoryProvider);
    final result = await repo.getResources();
    return result.fold(
      (l) => throw Exception(l),
      (r) => r,
    );
  }
}

@riverpod
class EnfantsKpisNotifier extends _$EnfantsKpisNotifier {
  @override
  Future<Map<String, dynamic>> build() async {
    final repo = ref.watch(enfantsRepositoryProvider);
    final result = await repo.getEnfantsKpis();
    return result.fold(
      (l) => throw Exception(l),
      (r) => r,
    );
  }
}