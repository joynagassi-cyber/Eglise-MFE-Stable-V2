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
                onPressed: () => ref.read(onboardingProvider.notifier).submitOnboarding(),
              ),
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(state.error!, style: const TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
