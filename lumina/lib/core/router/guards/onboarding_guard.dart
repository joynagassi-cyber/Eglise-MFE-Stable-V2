import 'package:lumina/features/onboarding/domain/entities/onboarding_step.dart';
import 'package:lumina/features/onboarding/domain/entities/onboarding_progress.dart';

class OnboardingGuard {
  static const _onboardingPrefixes = [
    '/onboarding',
    '/welcome-tour',
    '/login-callback',
  ];

  static bool isOnboardingPath(String location) =>
    _onboardingPrefixes.any((p) => location == p || location.startsWith('$p/'));

  static String? redirect({
    required OnboardingProgress progress,
    required String location,
  }) {
    if (progress.canNavigateAway) return null;

    if (isOnboardingPath(location)) return null;

    return _routeFor(progress.currentStep, progress.roleRoute);
  }

  static String? _routeFor(OnboardingStep step, String? roleRoute) {
    return switch (step) {
      OnboardingStep.roleSelection => '/onboarding',
      OnboardingStep.identitySetup => '/onboarding/admin-code',
      OnboardingStep.completed     => null,
    };
  }
}
