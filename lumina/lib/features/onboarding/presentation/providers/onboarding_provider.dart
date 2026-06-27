import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import '../../data/repositories/onboarding_repository.dart';
import 'package:lumina/features/profile/presentation/providers/profile_provider.dart';
import 'onboarding_progress_provider.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(Supabase.instance.client);
});

class OnboardingState {
  final bool isSubmitting;
  final String? error;

  const OnboardingState({
    this.isSubmitting = false,
    this.error,
  });

  OnboardingState copyWith({
    bool? isSubmitting,
    String? error,
  }) =>
      OnboardingState(
        isSubmitting: isSubmitting ?? this.isSubmitting,
        error: error,
      );

  bool get canSubmit => !isSubmitting;
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref);
});

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final Ref _ref;

  OnboardingNotifier(this._ref) : super(const OnboardingState());

  /// Méthode unique d'onboarding — unifie les 3 implémentations dupliquées
  /// précédentes (submitOnboarding, completeOnboardingAction, completeSimpleOnboarding).
  /// Met à jour le profile distant, complète le statut, puis navigue vers le dashboard.
  ///
  /// Les deux appels sont dans des try-catch séparés pour que l'échec du premier
  /// (timeout 3s) ne bloque pas le second (timeout 8s).
  Future<void> submitOnboarding() async {
    state = state.copyWith(isSubmitting: true, error: null);

    final userId = _ref.read(currentUserIdProvider);

    // Étape 1 : marquer needs_onboarding=false dans profiles
    if (userId != null) {
      try {
        await _ref.read(onboardingRepositoryProvider)
            .completeSimpleOnboarding(userId)
            .timeout(const Duration(seconds: 3));
      } catch (e) {
        // ignore: avoid_print
        print('Onboarding simple non-bloquant: $e');
      }
    }

    // Étape 2 : compléter l'onboarding dans l'auth provider
    try {
      await _ref.read(authProvider.notifier)
          .completeOnboarding()
          .timeout(const Duration(seconds: 8));
    } catch (e) {
      // ignore: avoid_print
      print('Onboarding auth non-bloquant: $e');
    }

    _ref.read(onboardingProgressNotifierProvider.notifier).reset();
    _ref.invalidate(profileStateProvider);
    state = state.copyWith(isSubmitting: false);
  }
}

