import 'dart:convert';
import 'package:lumina/core/providers/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/onboarding_step.dart';
import '../../domain/entities/onboarding_progress.dart';

part 'onboarding_progress_provider.g.dart';

@Riverpod(keepAlive: true)
class OnboardingProgressNotifier extends _$OnboardingProgressNotifier {
  static const _storageKey = 'onboarding_progress';

  @override
  OnboardingProgress build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      try {
        final saved = OnboardingProgress.fromJson(json.decode(jsonString));
        if (saved.currentStep == OnboardingStep.completed) {
          prefs.remove(_storageKey);
          return _initial();
        }
        return saved;
      } catch (_) {}
    }

    return _initial();
  }

  static OnboardingProgress _initial() => const OnboardingProgress(
        currentStep: OnboardingStep.roleSelection,
        history: <OnboardingStep>[],
      );

  void _persist(OnboardingProgress nextState) {
    state = nextState;
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_storageKey, json.encode(nextState.toJson()));
  }

  void advance(OnboardingStep step) {
    _persist(state.push(step));
  }

  void goBack() {
    if (state.history.isNotEmpty) {
      _persist(state.pop());
    }
  }

  void complete() {
    _persist(state.copyWith(currentStep: OnboardingStep.completed));
  }

  void reset() {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.remove(_storageKey);
    state = _initial();
  }

  void setRole(String role, {String? route}) {
    _persist(state.copyWith(selectedRole: role, roleRoute: route));
  }
}
