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

  Future<void> submitOnboarding() async {
    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final userId = _ref.read(currentUserIdProvider);
      if (userId != null) {
        try {
          await _ref.read(onboardingRepositoryProvider)
              .completeSimpleOnboarding(userId)
              .timeout(const Duration(seconds: 3));
        } catch (_) {}
      }
    } catch (_) {}

    try {
      await _ref.read(authProvider.notifier)
          .completeOnboarding()
          .timeout(const Duration(seconds: 8));
    } catch (_) {}

    _ref.read(onboardingProgressNotifierProvider.notifier).reset();
    _ref.invalidate(profileStateProvider);
    state = state.copyWith(isSubmitting: false);
  }

  Future<void> completeOnboardingAction() async {
    final userId = _ref.read(currentUserIdProvider);
    if (userId != null) {
      try {
        await _ref.read(onboardingRepositoryProvider)
            .completeSimpleOnboarding(userId)
            .timeout(const Duration(seconds: 3));
      } catch (_) {}
    }
    try {
      await _ref.read(authProvider.notifier)
          .completeOnboarding()
          .timeout(const Duration(seconds: 8));
    } catch (_) {}
    _ref.read(onboardingProgressNotifierProvider.notifier).reset();
    _ref.invalidate(profileStateProvider);
  }

  Future<void> completeSimpleOnboarding() async {
    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final userId = _ref.read(currentUserIdProvider);
      if (userId != null) {
        await _ref.read(onboardingRepositoryProvider)
            .completeSimpleOnboarding(userId)
            .timeout(const Duration(seconds: 3));
      }
      await _ref.read(authProvider.notifier)
          .completeOnboarding()
          .timeout(const Duration(seconds: 8));
    } catch (_) {}

    _ref.read(onboardingProgressNotifierProvider.notifier).reset();
    _ref.invalidate(profileStateProvider);
    state = state.copyWith(isSubmitting: false);
  }
}

