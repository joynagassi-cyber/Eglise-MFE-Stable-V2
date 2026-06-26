import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../onboarding/presentation/providers/onboarding_progress_provider.dart';
import '../../../onboarding/domain/entities/onboarding_step.dart';
import '../../../../core/extensions/context_extension.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colors.bgPage,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(LuminaDesign.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => context.pop(),
              ),
              SizedBox(height: 40),
              
              Text("Votre Rôle", style: LuminaDesign.h1Of(context)),
              SizedBox(height: 8),
              Text(
                "Choisissez comment vous allez utiliser Lumina.",
                style: LuminaDesign.bodyLargeOf(context).copyWith(color: context.colors.textSecondary),
              ),

              SizedBox(height: 48),

              _RoleTile(
                title: "Membre de l'Église",
                description: "Participez à la vie de votre communauté, suivez vos dons et accédez aux ressources.",
                icon: Icons.person_rounded,
                onTap: () async {
                  await ref.read(authProvider.notifier).completeOnboarding();
                  if (context.mounted) {
                    ref.read(onboardingProgressNotifierProvider.notifier).advance(OnboardingStep.completed);
                    context.go('/dashboard');
                  }
                },
              ),
              
              SizedBox(height: 16),

              _RoleTile(
                title: "Staff & Administration",
                description: "Gérez les membres, validez les transactions et supervisez la croissance.",
                icon: Icons.admin_panel_settings_rounded,
                onTap: () {
                  ref.read(onboardingProgressNotifierProvider.notifier).advance(OnboardingStep.identitySetup);
                  context.push('/onboarding/admin-code');
                },
              ),

              SizedBox(height: 64),
              
              Center(
                child: TextButton.icon(
                  onPressed: () => ref.read(authProvider.notifier).logout(),
                  icon: Icon(Icons.logout_rounded, size: 18),
                  label: Text("DÉCONNEXION"),
                  style: TextButton.styleFrom(foregroundColor: LuminaDesign.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleTile({required this.title, required this.description, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LuminaCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: LuminaDesign.primary.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: LuminaDesign.primary, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: LuminaDesign.h2Of(context).copyWith(fontSize: 16)),
                SizedBox(height: 2),
                Text(description, style: LuminaDesign.labelOf(context)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: context.colors.textTertiary, size: 16),
        ],
      ),
    );
  }
}
