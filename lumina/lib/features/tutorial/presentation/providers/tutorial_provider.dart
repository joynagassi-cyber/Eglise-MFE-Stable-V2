import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/providers/user_context_provider.dart';
import '../../data/tutorial_configs.dart';
import '../../domain/entities/tutorial_step.dart';

/// État du tutoriel avec les étapes complétées.
class TutorialState {
  final TutorialConfig config;
  final List<String> completedStepIds;

  const TutorialState({
    required this.config,
    this.completedStepIds = const [],
  });

  bool isStepCompleted(String stepId) => completedStepIds.contains(stepId);

  int get completedCount => completedStepIds.length;
  int get totalSteps => config.steps.length;
  bool get allCompleted => completedCount >= totalSteps;

  double get progressPercentage =>
      totalSteps == 0 ? 1.0 : completedCount / totalSteps;

  TutorialState copyWith({List<String>? completedStepIds}) {
    return TutorialState(
      config: config,
      completedStepIds: completedStepIds ?? this.completedStepIds,
    );
  }
}

/// Notifier pour gérer l'état du tutoriel interactif.
class TutorialNotifier extends StateNotifier<AsyncValue<TutorialState>> {
  final Ref _ref;
  final String _roleCode;

  TutorialNotifier(this._ref, this._roleCode)
      : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final service = await _ref.read(tutorialServiceProvider.future);
      final config = TutorialConfigs.getConfigForRole(_roleCode);
      final completed = service.getCompletedSteps(_roleCode);

      state = AsyncValue.data(
        TutorialState(config: config, completedStepIds: completed),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Marque une étape comme complétée.
  Future<void> markStepCompleted(String stepId) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    try {
      final service = await _ref.read(tutorialServiceProvider.future);
      await service.markStepCompleted(_roleCode, stepId);

      final updated = List<String>.from(currentState.completedStepIds);
      if (!updated.contains(stepId)) {
        updated.add(stepId);
      }
      state = AsyncValue.data(currentState.copyWith(completedStepIds: updated));
    } catch (e) {
      debugPrint('Erreur markStepCompleted: $e');
    }
  }

  /// Réinitialise le tutoriel pour ce rôle.
  Future<void> resetTutorial() async {
    try {
      final service = await _ref.read(tutorialServiceProvider.future);
      await service.resetTutorialForRole(_roleCode);
      final config = TutorialConfigs.getConfigForRole(_roleCode);
      state = AsyncValue.data(
        TutorialState(config: config, completedStepIds: []),
      );
    } catch (e) {
      debugPrint('Erreur resetTutorial: $e');
    }
  }
}

/// Provider famille indexé par roleCode.
final tutorialProvider = StateNotifierProvider.autoDispose
    .family<TutorialNotifier, AsyncValue<TutorialState>, String>(
  (ref, roleCode) => TutorialNotifier(ref, roleCode),
);

/// Provider de convenance qui utilise le rôle courant du UserContext.
final currentRoleTutorialProvider = Provider.autoDispose<String>((ref) {
  final userContext = ref.watch(userContextNotifierProvider).valueOrNull;
  return userContext?.role.code ?? 'generic';
});

/// Provider pour vérifier si le banner d'aide doit être affiché.
final tutorialBannerVisibleProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, roleCode) async {
  final service = await ref.read(tutorialServiceProvider.future);
  return !service.isBannerDismissed(roleCode);
});