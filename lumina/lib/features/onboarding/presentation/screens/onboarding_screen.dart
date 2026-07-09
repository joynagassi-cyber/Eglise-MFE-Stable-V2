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
                      onTap: () => context.push('/onboarding/admin-code'), // Vers la saisie de code
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

  void _handleRoleSelection(BuildContext context, WidgetRef ref, String role) async {
    // Pour un membre, l'onboarding peut être quasi-instantané
    if (role == 'member') {
      // ── ÉTAPE 1 : Assigner le rôle côté serveur ──
      // Le rôle "membre" dans la base = consultation (pas de code secret requis)
      // FIX #3a : l'assignation serveur est maintenant bloquante.
      final userId = ref.read(currentUserIdProvider);
      if (userId != null) {
        final roleCodeRepo = ref.read(roleCodeRepositoryProvider);
        bool assigned = await roleCodeRepo.assignRoleToUser(
          userId: userId,
          roleCode: 'membre',
        ).timeout(const Duration(seconds: 8));

        if (!assigned) {
          assigned = await roleCodeRepo.assignRoleToUser(
            userId: userId,
            roleCode: 'consultation',
          ).timeout(const Duration(seconds: 8));
        }

        if (!assigned) {
          throw Exception('Impossible d\'assigner le rôle membre côté serveur. Réessayez.');
        }
        AppLogger.i('Rôle membre assigné côté serveur: $assigned', 'ONBOARDING');
      }

      // ── ÉTAPE 2 : Marquer le progress d'onboarding AVANT completeOnboarding ──
      // pour que le RouterPolicy ne bloque pas la navigation
      ref.read(onboardingProgressNotifierProvider.notifier)
        ..setRole('consultation', route: '/dashboard')
        ..advance(OnboardingStep.completed);
      
      // ── ÉTAPE 3 : Compléter l'onboarding dans le provider d'auth ──
      try {
        await ref.read(authProvider.notifier).completeOnboarding()
            .timeout(const Duration(seconds: 4));
        AppLogger.i('completeOnboarding réussi (membre)', 'ONBOARDING');
      } catch (e) {
        AppLogger.w('completeOnboarding timeout (membre, navigating anyway): $e', 'ONBOARDING');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Expanded(child: Text('Finalisation en cours, veuillez patienter…')),
                ],
              ),
              backgroundColor: Colors.blue.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }

      if (context.mounted) {
        AppLogger.i('Navigation membre → /dashboard', 'ONBOARDING');
        context.go(AppRoutes.dashboard);
      }
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
    required this.onTap
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
