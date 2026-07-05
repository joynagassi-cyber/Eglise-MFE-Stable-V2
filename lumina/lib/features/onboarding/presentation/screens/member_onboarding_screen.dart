import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/onboarding_provider.dart';
import '../../../../core/extensions/context_extension.dart';

class MemberOnboardingScreen extends ConsumerWidget {
  const MemberOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);

    return LuminaPage(
      showBackButton: false,
      showHomeButton: false,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(LuminaDesign.paddingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.celebration_rounded, size: 80, color: LuminaDesign.primary)
                  .animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
              SizedBox(height: 32),
              Text("Bienvenue dans la Famille !", textAlign: TextAlign.center, style: LuminaDesign.h1Of(context)),
              SizedBox(height: 16),
              Text(
                "Votre profil est prêt. Vous allez maintenant accéder à votre espace personnalisé.",
                textAlign: TextAlign.center,
                style: LuminaDesign.bodyLargeOf(context).copyWith(color: context.colors.textSecondary),
              ),
              SizedBox(height: 48),
              LuminaButton(
                label: "Terminer",
                isLoading: state.isSubmitting,
                onPressed: () async {
                  await ref.read(onboardingProvider.notifier).submitOnboarding();
                  final updatedState = ref.read(onboardingProvider);
                  if (updatedState.error != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 12),
                            Expanded(child: Text(updatedState.error!)),
                          ],
                        ),
                        backgroundColor: Colors.red.shade700,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        duration: Duration(seconds: 4),
                        action: SnackBarAction(
                          label: 'Réessayer',
                          textColor: Colors.white,
                          onPressed: () => ref.read(onboardingProvider.notifier).submitOnboarding(),
                        ),
                      ),
                    );
                  }
                },
              ),
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: context.colors.errorText.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.colors.errorText.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: context.colors.errorText, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.error!,
                            style: TextStyle(color: context.colors.errorText, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
