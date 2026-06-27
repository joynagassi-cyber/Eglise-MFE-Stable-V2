import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/repository_providers_auth.dart';
import '../../../onboarding/presentation/providers/onboarding_progress_provider.dart';
import '../../../onboarding/domain/entities/onboarding_step.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/logging/app_logger.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  bool _isProcessingMembre = false;
  final bool _isProcessingStaff = false;

  /// Détermine si on est en train de traiter un choix (pour désactiver les tuiles).
  bool get _isProcessing => _isProcessingMembre || _isProcessingStaff;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgPage,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(LuminaDesign.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        const SizedBox(height: 20),
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: _isProcessing ? null : () => context.pop(),
              ),
              const SizedBox(height: 40),
              
              Text("Votre Rôle", style: LuminaDesign.h1Of(context)),
              const SizedBox(height: 8),
              Text(
                "Choisissez comment vous allez utiliser Lumina.",
                style: LuminaDesign.bodyLargeOf(context).copyWith(color: context.colors.textSecondary),
              ),

              _RoleTile(
                title: "Membre de l'Église",
                description: "Participez à la vie de votre communauté, suivez vos dons et accédez aux ressources.",
                icon: Icons.person_rounded,
                isLoading: _isProcessingMembre,
                onTap: _isProcessing ? null : _handleMembreSelection,
              ),
              
              const SizedBox(height: 16),

              _RoleTile(
                title: "Staff & Administration",
                description: "Gérez les membres, validez les transactions et supervisez la croissance.",
                icon: Icons.admin_panel_settings_rounded,
                isLoading: _isProcessingStaff,
                onTap: _isProcessing ? null : _handleStaffSelection,
              ),

              const SizedBox(height: 64),
              
              Center(
                child: TextButton.icon(
             onPressed: _isProcessing ? null : () => ref.read(authProvider.notifier).logout(),
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text("DÉCONNEXION"),
                  style: TextButton.styleFrom(foregroundColor: LuminaDesign.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ═══════════════════════════════════════════════════════════════════
  /// Membre : ordre déterministe
  ///
  /// 1. Avance progress → completed   (pour que OnboardingGuard laisse passer)
  /// 2. completeOnboarding()          (transition AuthOnboardingRequired → Authenticated)
  /// 3. navigate /dashboard           (après que l'état auth soit cohérent)
  /// ═══════════════════════════════════════════════════════════════════
  Future<void> _handleMembreSelection() async {
    setState(() => _isProcessingMembre = true);
    try {
      // ÉTAPE 1 : marquer l'onboarding terminé AVANT completeOnboarding
      // pour que le RouterPolicy oardingGuard ne bloquent pas la navigation
      ref.read(onboardingProgressNotifierProvider.notifier)
        ..setRole('consultation', route: '/dashboard')
        ..advance(OnboardingStep.completed);

      // ÉTAPE 2 : assigner le rôle "membre" serveur (non-bloquant)
      final userId = ref.read(currentUserIdProvider);
      if (userId != null) {
   try {
          final roleCodeRepo = ref.read(roleCodeRepositoryProvider);
          bool assigned = await roleCodeRepo.assignRoleToUser(
            userId: userId,
            roleCode: 'membre',
          ).timeout(const Duration(seconds: 5));
          
          if (!assigned) {
            assigned = await roleCodeRepo.assignRoleToUser(
              userId: userId,
              roleCode: 'consultation',
            ).timeout(const Duration(seconds: 5));
          }
          AppLogger.i('Rôle membre assigné côté serveur: $assigned', 'ONBOARDING');
        } catch (e) {
          AppLogger.w('assignRoleToUser échoué (non bloquant): $e', 'ONBOARDING');
        }
      }

      // ÉTAPE 3 : compléter l'onboardins le provider d'auth
      await ref.read(authProvider.notifier).completeOnboarding()
          .timeout(const Duration(seconds: 4));

      // ÉTAPE 4 : naviguer
      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      AppLogger.e('Erreur onboarding membre', 'ROLE_SELECTION', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Une erreur est survenue. Réessayez.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessingMembre = false);
    }
  }

  /// ═══════════════════════════════════════════════════════════════════
  /// Staff : avance vers l'étape de vérification de code
  /// ═══════════════════════════════════════════════════════════════════
  void _handleStaffSelection() {
    ref.read(onboardingProgressNotifierProvider.notifier)
      .advance(OnboardingStep.identitySetup);
    if (mounted) {
      context.push('/onboarding/admin-code');
    }
  }
}

class _RoleTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isLoading;

  const _RoleTile({
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
    this.isLoading = false,
  });

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
            const child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(LuminaDesign.primary),
                    ),
                  )
                : Icon(icon, color: LuminaDesign.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: LuminaDesign.h2Of(context).copyWith(fontSize: 16)),
                const SizedBox(height: 2),
                Text(description, style: LuminaDesign.labelOf(context)),
              ],
            ),
          ),
          if (!isLoading)
            Icon(Icons.chevron_right, color: context.colors.textTertiary, size: 16),
        ],
      ),
    );
  }
}
