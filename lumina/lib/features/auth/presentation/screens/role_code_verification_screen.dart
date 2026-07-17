import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lumina/core/utils/adaptive_code_formatter.dart';
import '../../../../core/providers/auth_provider.dart';
import 'package:lumina/core/providers/repository_providers_auth.dart';
import '../../../onboarding/presentation/providers/onboarding_progress_provider.dart';
import '../../../onboarding/domain/entities/onboarding_step.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/providers/local_persistence_provider.dart';
import '../../../../core/data/models/local_user_context_model.dart';

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

  /// Flux de verification de code role - Offline-first
  /// 1. RedeemSecretCode -> obtient role_code
  /// 2. AssignRoleToUser -> cree user_roles + user_sessions + profiles
  /// 3. CompleteOnboarding -> met l'etat auth a AuthAuthenticated
  /// 4. Navigation -> deleguee au router
  ///
  /// OFFLINE-FIRST: Si l'etape 2 echoue (timeout/reseau), on sauvegarde
  /// le contexte localement et on continue. L'utilisateur n'est pas bloque.
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

      // -- ETAPE 1 : Verifier le code --
      AppLogger.i('Verification code: "$code"', 'ROLE_CODE_VERIFY');
      final redemptionResult = await roleCodeRepo.redeemSecretCode(code)
          .timeout(const Duration(seconds: 10));

      if (redemptionResult == null) {
        AppLogger.w('Code "$code" invalide', 'ROLE_CODE_VERIFY');
        if (mounted) {
          setState(() => _errorMessage = 'Code invalide. Verifiez le format (ex: PASTEUR-0081-2026) et reessayez.');
        }
        return;
      }

      final roleCode = redemptionResult['role_code'] as String;
      AppLogger.i('Code valide ! role_code = "$roleCode"', 'ROLE_CODE_VERIFY');

      // -- ETAPE 2 : Assigner le role cote serveur --
      // OFFLINE-FIRST: Si l'assignation echoue (timeout/reseau), on ne bloque pas.
      // On sauvegarde le contexte localement et on continue.
      bool serverAssigned = false;
      if (userId != null) {
        try {
          serverAssigned = await roleCodeRepo.assignRoleToUser(
            userId: userId,
            roleCode: roleCode,
          ).timeout(const Duration(seconds: 8));
        } catch (e) {
          AppLogger.w('assignRoleToUser echec (offline?): $e', 'ROLE_CODE_VERIFY');
        }

        if (serverAssigned) {
          AppLogger.i('Role assigne cote serveur pour userId=$userId', 'ROLE_CODE_VERIFY');
        } else {
          AppLogger.w('Assignation serveur echouee - mode offline, sauvegarde locale', 'ROLE_CODE_VERIFY');
        }
        // Always save locally for offline-first resilience
        unawaited(_saveContextLocally(userId, roleCode));
      }

      // -- ETAPE 3 : Marquer l'onboarding comme complete --
      ref.read(onboardingProgressNotifierProvider.notifier)
        ..setRole(roleCode)
        ..advance(OnboardingStep.completed);

      // -- ETAPE 4 : Completer l'onboarding dans le provider d'auth --
      try {
        await ref.read(authProvider.notifier).completeOnboarding()
            .timeout(const Duration(seconds: 10));
        AppLogger.i('completeOnboarding reussi', 'ROLE_CODE_VERIFY');
      } catch (e) {
        AppLogger.w('completeOnboarding timeout/erreur: $e', 'ROLE_CODE_VERIFY');
        // OFFLINE-FIRST: Le provider a deja le fallback ; le router gere la navigation.
      }

      // Navigation deleguee au router via l'etat auth.
    } catch (e, st) {
      AppLogger.e('Erreur verification code', 'ROLE_CODE_VERIFY', e, st);
      if (mounted) {
        final errorMsg = e.toString();
        if (errorMsg.contains('Timeout') || errorMsg.contains('Socket') || errorMsg.contains('Network')) {
          setState(() => _errorMessage = 'Connexion impossible. Verifiez votre reseau et reessayez.');
        } else {
          setState(() => _errorMessage = 'Oups ! Une erreur est survenue. Reessayez.');
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Sauvegarde le contexte utilisateur localement (mode offline).
  Future<void> _saveContextLocally(String userId, String roleCode) async {
    try {
      final localSvc = ref.read(localPersistenceServiceProvider);
      final localCtx = LocalUserContextModel.fromMap({
        'userId': userId,
        'roleCode': roleCode,
        'roleLabel': roleCode,
        'roleHierarchyLevel': 0,
        'isSuper': false,
        'needsOnboarding': false,
        'churchId': null,
        'groupId': null,
        'initialRoute': '/dashboard',
      });
      await localSvc.saveLocalUserContext(localCtx);
      AppLogger.i('Contexte sauvegarde localement (offline)', 'ROLE_CODE_VERIFY');
    } catch (e) {
      AppLogger.w('Erreur sauvegarde contexte local: $e', 'ROLE_CODE_VERIFY');
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
          tooltip: 'Retour',
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
                child: Icon(Icons.vpn_key_outlined, color: LuminaDesign.primary, size: 48),
              ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
              
              const SizedBox(height: 32),

              // --- TITLES ---
              Text("Verification d'acces", style: LuminaDesign.h2Of(context)).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 12),
              Text(
                "Saisissez le code secret fourni par votre eglise pour activer vos privileges.",
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
                      inputFormatters: [
                        AdaptiveCodeFormatter(),
                      ],
                      onSubmitted: (_) => _verifyCode(),
                    ),
                  ],
                ),
              ).animate().slideY(begin: 0.2, duration: 400.ms),

              const SizedBox(height: 32),

              // --- BUTTON ---
              LuminaButton(
                label: "Valider mon role",
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
