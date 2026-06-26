import 'onboarding_step.dart';

class OnboardingProgress {
  final OnboardingStep currentStep;
  final List<OnboardingStep> history;
  final String? selectedRole;
  final String? roleRoute;

  const OnboardingProgress({
    required this.currentStep,
    required this.history,
    this.selectedRole,
    this.roleRoute,
  });

  bool get canNavigateAway => currentStep == OnboardingStep.completed;

  OnboardingProgress copyWith({
    OnboardingStep? currentStep,
    List<OnboardingStep>? history,
    String? selectedRole,
    String? roleRoute,
  }) {
    return OnboardingProgress(
      currentStep: currentStep ?? this.currentStep,
      history: history ?? this.history,
      selectedRole: selectedRole ?? this.selectedRole,
      roleRoute: roleRoute ?? this.roleRoute,
    );
  }

  OnboardingProgress push(OnboardingStep step) => copyWith(
        currentStep: step,
        history: [...history, currentStep],
      );

  OnboardingProgress pop() => copyWith(
        currentStep: history.last,
        history: history.sublist(0, history.length - 1),
      );

  Map<String, dynamic> toJson() {
    return {
      'currentStep': currentStep.name,
      'history': history.map((e) => e.name).toList(),
      'selectedRole': selectedRole,
      'roleRoute': roleRoute,
    };
  }

  factory OnboardingProgress.fromJson(Map<String, dynamic> json) {
    return OnboardingProgress(
      currentStep: OnboardingStep.values.firstWhere(
        (e) => e.name == json['currentStep'],
        orElse: () => OnboardingStep.roleSelection,
      ),
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => OnboardingStep.values.firstWhere(
                    (s) => s.name == e,
                    orElse: () => OnboardingStep.roleSelection,
                  ))
              .toList() ??
          [],
      selectedRole: json['selectedRole'] as String?,
      roleRoute: json['roleRoute'] as String?,
    );
  }
}
