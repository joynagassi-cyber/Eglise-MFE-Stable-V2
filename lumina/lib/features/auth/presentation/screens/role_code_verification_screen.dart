import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/providers/auth_provider.dart';
import 'package:lumina/core/providers/repository_providers_auth.dart';
import '../../../onboarding/presentation/providers/onboarding_progress_provider.dart';
import '../../../onboarding/domain/entities/onboarding_step.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/extensions/context_extension.dart';

class RoleCodeVerificationScreen extends ConsumerStatefulWidget {
  const RoleCodeVerificationScreen({super.key});

  @override
  ConsumerState<RoleCodeVerificationScreen> createState() =>
      _RoleCodeVerificationScreenState();
}

class _RoleCodeVerificationScreenState
    extends ConsumerState<RoleCodeVerificationScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  /// ══════════════════════════════════════════════════════════════════════════
  /// FLUX DÉTERMINISTE DE VÉRIFICATION
  ///
  /// 1. RedeemSecretCode → obtient role_code
  /// 2. AssignRoleToUser → crée user_roles + user_sessions + profiles
  /// 3. CompleteOnboarding → met l'état auth à AuthAuthenticated
  /// 4. Navigate → context.go('/dashboard')
  ///
  /// Si étape 2 échoue (RLS ou table inexistante), on continue quand même
  /// car ChurchRole.fromLabel résout le rôle côté client.
  /// ══════════════════════════════════════════════════════════════════════════
  Future<void> _verifyCode() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final roleCodeRepo = ref.read(roleCodeRepositoryProvider);
      final userId = ref.read(currentUserIdProvider);

      // ── ÉTAPE 1 : Vérifier le code ──
      AppLogger.i('Vérification code: "$code"', 'ROLE_CODE_VERIFY');
      final redemptionResult = await roleCodeRepo.redeemSecretCode(code);

      if (redemptionResult == null) {
        AppLogger.w('Code "$code" invalide', 'ROLE_CODE_VERIFY');
        if (mounted) {
          setState(() => _errorMessage = 'Code invalide. Vérifiez le format (ex: PASTEUR-0081-2026) et réessayez.');
        }
        return;
      }

      final roleCode = redemptionResult['role_code'] as String;
      AppLogger.i('Code valide ! role_code = "$roleCode"', 'ROLE_CODE_VERIFY');

      // ── ÉTAPE 2 : Assigner le rôle côté serveur (user_roles + user_sessions + profiles) ──
      if (userId != null) {
        try {
          await roleCodeRepo.assignRoleToUser(
            userId: userId,
            roleCode: roleCode,
          ).timeout(const Duration(seconds: 5));
          AppLogger.i('Rôle assigné côté serveur pour userId=$userId', 'ROLE_CODE_VERIFY');
        } catch (e) {
          // Ne pas bloquer — le rôle sera résolu côté client par ChurchRole.fromLabel
          AppLogger.w('assignRoleToUser échoué (non bloquant): $e', 'ROLE_CODE_VERIFY');
        }
      }

      // ── ÉTAPE 3 : Marquer l'onboarding comme complété AVANT completeOnboarding ──
      // Ceci empêche le RouterPolicy de rediriger vers /onboarding
      ref.read(onboardingProgressNotifierProvider.notifier)
        ..setRole(roleCode)
        ..advance(OnboardingStep.completed);

      // ── ÉTAPE 4 : Compléter l'onboarding dans le provider d'auth ──
      // completeOnboarding() va appeler getUserContext() qui, grâce à l'étape 2,
      // trouvera désormais un rôle valide dans user_roles et retournera
      // needs_onboarding=false. Si getUserContext() échoue, le fallback optimiste
      // utilise le rôle du contexte fallback.
      try {
        await ref.read(authProvider.notifier).completeOnboarding()
            .timeout(const Duration(seconds: 4));
        AppLogger.i('completeOnboarding réussi', 'ROLE_CODE_VERIFY');
      } catch (e) {
        AppLogger.w('completeOnboarding timeout/erreur (navigating anyway): $e', 'ROLE_CODE_VERIFY');
        // Forcer quand même la transition — le provider a déjà le fallback
      }

      // ── ÉTAPE 5 : Naviguer vers le dashboard ──
      if (mounted) {
        AppLogger.i('Navigation → /dashboard', 'ROLE_CODE_VERIFY');
        context.go('/dashboard');
      }
    } catch (e, st) {
      AppLogger.e('Erreur vérification code', 'ROLE_CODE_VERIFY', e, st);
      if (mounted) {
        setState(() => _errorMessage = 'Oups ! Une erreur est survenue. Réessayez.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgPage,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(LuminaDesign.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // --- ICON ---
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: LuminaDesign.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.vpn_key_outlined, color: LuminaDesign.primary, size: 48),
              ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
              
              const SizedBox(height: 32),

              // --- TITLES ---
              Text("Vérification d'accès", style: LuminaDesign.h2Of(context)).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 12),
              Text(
                "Saisissez le code secret fourni par votre église pour activer vos privilèges.",
                textAlign: TextAlign.center,
                style: LuminaDesign.bodyLargeOf(context).copyWith(color: context.colors.textSecondary),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 48),

              // --- INPUT ---
              LuminaCard(
                child: Column(
                  children: [
                    TextField(
                      controller: _codeController,
                      textAlign: TextAlign.center,
                      style: LuminaDesign.h2Of(context).copyWith(letterSpacing: 4),
                      decoration: InputDecoration(
                        hintText: "ROLE-XXXX-2026",
                        hintStyle: LuminaDesign.bodyLargeOf(context).copyWith(color: context.colors.textTertiary, letterSpacing: 1),
                        border: InputBorder.none,
                        errorText: _errorMessage,
                      ),
                      textCapitalization: TextCapitalization.characters,
                      onSubmitted: (_) => _verifyCode(),
                    ),
                  ],
                ),
              ).animate().slideY(begin: 0.2, duration: 400.ms),

              const SizedBox(height: 32),

              // --- BUTTON ---
              LuminaButton(
                label: "Valider mon rôle",
                isLoading: _isLoading,
                onPressed: _verifyCode,
              ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: 40),
              
              Text(
                "Vous n'avez pas de code ?",
                style: LuminaDesign.labelOf(context),
              ),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text("Retourner au mode membre"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
