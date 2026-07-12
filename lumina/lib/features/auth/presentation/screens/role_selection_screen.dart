import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/repository_providers_auth.dart';
import '../../../../core/router/app_routes.dart';
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
  bool _isProcessingStaff = false;

  /// Détermine si on est en train de traiter un choix (pour désactiver les tuiles).
  bool get _isProcessing => _isProcessingMembre || _isProcessingStaff;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset du flag staff quand on revient sur l'écran (retour de /admin-code)
    if (_isProcessingStaff && !_isProcessingMembre) {
      setState(() => _isProcessingStaff = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Garde irréversible : si le membre a été choisi, les deux tuiles
    // restent désactivées (visuellement grisées, non cliquables).
    final locked = _isProcessingStaff && !_isProcessingMembre
        ? false
        : _isProcessingMembre;

    return Scaffold(
      backgroundColor: context.colors.bgPage,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(LuminaDesign.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        const SizedBox(height: 20),
              // Pas de bouton retour quand le choix membre est en cours
              // ou terminé (irréversible)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                tooltip: 'Retour',
                onPressed: _isProcessingMembre ? null : () => context.pop(),
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
                isLocked: locked,
                onTap: _isProcessingMembre ? null : _handleMembreSelection,
              ),

              const SizedBox(height: 16),

              _RoleTile(
                title: "Staff & Administration",
                description: "Gérez les membres, validez les transactions et supervisez la croissance.",
                icon: Icons.admin_panel_settings_rounded,
                isLoading: _isProcessingStaff,
                isLocked: locked,
                onTap: _isProcessingStaff ? null : _handleStaffSelection,
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
  /// Membre : flux irréversible
  ///
  /// 1. Avance progress → completed (pour que OnboardingGuard laisse passer)
  /// 2. assign_user_role('membre_simple') en DB (BLOCANT — pas de fallback)
  /// 3. completeOnboarding() (needs_onboarding = false en DB)
  /// 4. context.go('/dashboard') — remplace la pile, retour impossible
  ///
  /// Si l'assignation serveur échoue, on reset le progress pour permettre
  /// un nouveau choix. Sinon l'utilisateur est verrouillé comme membre.
  /// ═══════════════════════════════════════════════════════════════════
  Future<void> _handleMembreSelection() async {
    // Garde anti-double-clic / double-entrée
    if (_isProcessing) return;
    setState(() {
      _isProcessingMembre = true;
      _isProcessingStaff = true; // Verrouille aussi Staff
    });

    try {
      ref.read(onboardingProgressNotifierProvider.notifier)
        ..setRole('consultation', route: '/dashboard')
        ..advance(OnboardingStep.completed);

      final userId = ref.read(currentUserIdProvider);
      if (userId == null) {
        throw Exception('Utilisateur non connecté. Réessayez.');
      }

      final roleCodeRepo = ref.read(roleCodeRepositoryProvider);
      final assigned = await roleCodeRepo.assignRoleToUser(
        userId: userId,
        roleCode: 'membre_simple',
      ).timeout(const Duration(seconds: 10));

      if (!assigned) {
        // Reset progress pour permettre un nouveau choix
        ref.read(onboardingProgressNotifierProvider.notifier).reset();
        throw Exception('Impossible d\'assigner le rôle membre. Réessayez.');
      }
      AppLogger.i('Rôle membre_simple assigné (irréversible)', 'ROLE_SELECTION');

      await ref.read(authProvider.notifier).completeOnboarding()
          .timeout(const Duration(seconds: 10));

      if (mounted) {
        // context.go remplace la pile de navigation — retour impossible
        context.go(AppRoutes.dashboard);
      }
    } catch (e) {
      AppLogger.e('Erreur onboarding membre', 'ROLE_SELECTION', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: context.colors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingMembre = false;
        });
      }
    }
  }

  /// ═══════════════════════════════════════════════════════════════════
  /// Staff : verrouille Membre, puis navigue vers le code secret
  /// ═══════════════════════════════════════════════════════════════════
  void _handleStaffSelection() {
    if (_isProcessing) return; // Garde anti-double-clic
    setState(() => _isProcessingStaff = true);
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
  final bool isLocked;

  const _RoleTile({
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
    this.isLoading = false,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = (onTap == null && !isLoading) || isLocked;
    return LuminaCard(
      onTap: disabled ? null : onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: disabled
                  ? context.colors.borderSubtle.withOpacity(0.2)
                  : LuminaDesign.primary.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(LuminaDesign.primary),
                    ),
                  )
                : Icon(
                    icon,
                    color: disabled
                        ? context.colors.textTertiary.withOpacity(0.4)
                        : LuminaDesign.primary,
                    size: 24,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: (LuminaDesign.h2Of(context).copyWith(fontSize: 16))
                      .copyWith(color: disabled ? context.colors.textTertiary.withOpacity(0.4) : null),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: LuminaDesign.labelOf(context).copyWith(
                    color: disabled ? context.colors.textTertiary.withOpacity(0.3) : null,
                  ),
                ),
              ],
            ),
          ),
          if (!isLoading && !disabled)
            Icon(Icons.chevron_right, color: context.colors.textTertiary, size: 16),
        ],
      ),
    );
  }
}
