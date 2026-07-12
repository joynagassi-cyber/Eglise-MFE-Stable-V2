import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/providers/auth_provider.dart';
import 'package:lumina/core/providers/repository_providers_auth.dart';
import '../../../../core/router/app_routes.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_progress_provider.dart';
import '../../domain/entities/onboarding_step.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/extensions/context_extension.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colors.bgPage,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: LuminaDesign.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              // --- HEADER ---
              Text(
                "Bienvenue sur Lumina",
                style: LuminaDesign.h1Of(context),
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
              SizedBox(height: 8),
              Text(
                "Pour commencer, quel est votre rôle ?",
                style: LuminaDesign.bodyLargeOf(context).copyWith(color: context.colors.textSecondary),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),

              SizedBox(height: 48),

              // --- ROLE SELECTION ---
              Expanded(
                child: ListView(
                  children: [
                    _RoleCard(
                      title: "Membre",
                      description: "Accédez à la Bible, aux chants et aux actualités de votre église.",
                      icon: Icons.person_outline_rounded,
                      onTap: () => _handleRoleSelection(context, ref, 'member'),
                    ),
                    _RoleCard(
                      title: "Responsable / Staff",
                      description: "Gérez vos groupes, vos membres et le suivi pastoral.",
                      icon: Icons.groups_outlined,
                      onTap: () => context.push('/onboarding/admin-code'),
                    ),
                    _RoleCard(
                      title: "Administrateur",
                      description: "Contrôle total de l'antenne, des finances et de la sécurité.",
                      icon: Icons.admin_panel_settings_outlined,
                      onTap: () => context.push('/onboarding/admin-code'),
                    ),
                  ].animate(interval: 100.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1),
                ),
              ),

              // --- FOOTER INFO ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    "Besoin d'aide ? Contactez votre secrétariat.",
                    style: LuminaDesign.labelOf(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ═══════════════════════════════════════════════════════════════════
  /// Membre : flux irréversible
  ///
  /// 1. assign_user_role('membre_simple') en DB — BLOCANT
  /// 2. progress → completed
  /// 3. completeOnboarding() → needs_onboarding = false en DB
  /// 4. context.go('/dashboard') — remplace la pile, retour impossible
  ///
  /// Si l'assignation serveur échoue → reset progress + erreur.
  /// ═══════════════════════════════════════════════════════════════════
  void _handleRoleSelection(BuildContext context, WidgetRef ref, String role) async {
    if (role != 'member') return;

    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Utilisateur non connecté. Déconnectez-vous et réessayez.')),
      );
      return;
    }

    final roleCodeRepo = ref.read(roleCodeRepositoryProvider);
    final assigned = await roleCodeRepo.assignRoleToUser(
      userId: userId,
      roleCode: 'membre_simple',
    ).timeout(const Duration(seconds: 10));

    if (!assigned) {
      AppLogger.e('Échec assignation membre_simple', 'ONBOARDING');
      ref.read(onboardingProgressNotifierProvider.notifier).reset();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'enregistrer votre profil. Réessayez.')),
        );
      }
      return;
    }
    AppLogger.i('Rôle membre_simple assigné (irréversible)', 'ONBOARDING');

    // Marquer l'onboarding comme complété avant la navigation
    ref.read(onboardingProgressNotifierProvider.notifier)
      ..setRole('consultation', route: '/dashboard')
      ..advance(OnboardingStep.completed);

    // Compléter dans auth provider (needs_onboarding = false)
    try {
      await ref.read(authProvider.notifier).completeOnboarding()
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      AppLogger.w('completeOnboarding timeout, navigation quand même: $e', 'ONBOARDING');
    }

    // Navigation irréversible
    if (context.mounted) {
      context.go(AppRoutes.dashboard);
    }
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LuminaCard(
      onTap: onTap,
      padding: const EdgeInsets.all(LuminaDesign.paddingLg),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: LuminaDesign.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: LuminaDesign.primary, size: 28),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: LuminaDesign.h2Of(context).copyWith(fontSize: 18)),
                SizedBox(height: 4),
                Text(
                  description,
                  style: LuminaDesign.bodyLargeOf(context).copyWith(
                    fontSize: 14,
                    color: context.colors.textSecondary
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 16, color: context.colors.textTertiary),
        ],
      ),
    );
  }
}
