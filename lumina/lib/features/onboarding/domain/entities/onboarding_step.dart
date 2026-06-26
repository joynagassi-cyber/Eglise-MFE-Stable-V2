enum OnboardingStep {
  roleSelection,         // 1. Qui êtes-vous ?
  identitySetup,         // 2. Vos informations (Simplifié)
  completed;             // 3. Terminé ! -> Dashboard

  bool get isTerminal => this == completed;
  
  String? get route {
    return switch (this) {
      OnboardingStep.roleSelection => '/onboarding',
      OnboardingStep.identitySetup => '/onboarding/admin-code',
      OnboardingStep.completed     => '/dashboard',
    };
  }
}
