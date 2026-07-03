import 'dart:async';
import 'package:lumina/core/extensions/context_extension.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/providers/auth_controller.dart';
import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/adaptive_code_formatter.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../../../core/widgets/animated_entrance.dart';
import '../widgets/auth_primary_button.dart';

class AdminCodeVerificationScreen extends ConsumerStatefulWidget {
  const AdminCodeVerificationScreen({super.key});

  @override
  ConsumerState<AdminCodeVerificationScreen> createState() =>
      _AdminCodeVerificationScreenState();
}

class _AdminCodeVerificationScreenState
    extends ConsumerState<AdminCodeVerificationScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    if (!_formKey.currentState!.validate()) {
      await HapticHelper.warning();
      return;
    }

    await HapticHelper.light();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await ref
          .read(authControllerProvider.notifier)
          .verifyAdminCode(_codeController.text);

      if (result && mounted) {
        await HapticHelper.success();
        if (mounted) {
          unawaited(context.push('${AppRoutes.onboardingSuperadmin}?verified=true'));
        }
      } else if (mounted) {
        setState(() {
          _errorMessage = "Code inexistant, expiré ou déjà utilisé.";
        });
      }
    } catch (e) {
      await HapticHelper.error();
      if (mounted) {
        setState(() {
          _errorMessage = "Erreur technique lors de la vérification.";
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Dynamique
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: context.colors.brandGradient,
              ),
            ),
          ),

          // Orbes de lumière décoratives (Premium touch)
          if (!isDark) ...[
            Positioned(
              top: -100,
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.glassCardBg,
                ),
              ),
            ),
          ],
          SafeArea(
            child: Column(
              children: [
                // AppBar Custom Glass
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontalPadding,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.colors.stateHoverBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: context.colors.glassCardBorder,
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: LuminaIcon.md,
                                color: context.colors.textOnBrand,
                              ),
                              tooltip: 'Retour',
                              onPressed: () => context.pop(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.screenHorizontalPadding),
                      child: AnimatedEntrance.fade(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: ClipRRect(
                            borderRadius: AppSpacing.borderRadiusCard,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: context.colors.glassCardBg,
                                  borderRadius: AppSpacing.borderRadiusCard,
                                  border: Border.all(
                                    color: context.colors.glassCardBorder,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: context.colors.bgOverlay,
                                      blurRadius: 12.0,
                                      offset: const Offset(0, 20),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(AppSpacing.xl),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Icône Animée
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0, end: 1),
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.elasticOut,
                                        builder: (context, value, child) {
                                          return Transform.scale(
                                            scale: value,
                                            child: Container(
                                              padding: const EdgeInsets.all(AppSpacing.lg),
                                              decoration: BoxDecoration(
                                                color: context.colors.brandPrimary.withValues(alpha: 0.1),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: context.colors.brandPrimary.withValues(alpha: 0.2),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.shield_rounded,
                                                size: 40,
                                                color: context.colors.brandPrimary,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: AppSpacing.xl),

                                      // Titre en Lora (Spirituel/Éditorial)
                                      Text(
                                        'Vérification',
                                        style: TextStyle(
                                          fontFamily: LuminaFont.display,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w700,
                                          color: context.colors.textPrimary,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      SizedBox(height: AppSpacing.sm),
                                      
                                      Text(
                                        'ADMINISTRATION LUMINA',
                                        style: AppTypography.labelSmall.copyWith(
                                          color: context.colors.brandPrimary,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                      SizedBox(height: AppSpacing.xl),

                                      // Champ de Saisie Stylisé
                                      TextFormField(
                                        controller: _codeController,
                                        obscureText: true,
                                        textAlign: TextAlign.center,
                                        textCapitalization: TextCapitalization.characters,
                                        inputFormatters: [AdaptiveCodeFormatter()],
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 4,
                                          color: context.colors.textPrimary,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'SUPER-ADMIN-XXXX-2026',
                                          hintStyle: AppTypography.bodySmall.copyWith(
                                            color: context.colors.textTertiary,
                                            letterSpacing: 2,
                                          ),
                                          filled: true,
                                          fillColor: isDark 
                                              ? context.colors.bgTertiary
                                              : context.colors.bgSecondary,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            borderSide: BorderSide.none,
                                          ),
                                          errorStyle: TextStyle(color: context.colors.errorText),
                                        ),
                                        validator: (v) => v?.isEmpty ?? true ? 'Code requis' : null,
                                      ),
                                      SizedBox(height: AppSpacing.xl),

                                      // Bouton avec Gradient (AuthPrimaryButton mis à jour)
                                      AuthPrimaryButton(
                                        label: 'VÉRIFIER L\'ACCÈS',
                                        isLoading: _isLoading,
                                        onPressed: _verifyCode,
                                      ),

                                      if (_errorMessage != null) ...[
                                        SizedBox(height: AppSpacing.md),
                                        Text(
                                          _errorMessage!,
                                          style: TextStyle(
                                            color: context.colors.errorText,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],

                                      SizedBox(height: AppSpacing.xl),

                                      // Note info Glass
                                      Container(
                                        padding: const EdgeInsets.all(AppSpacing.md),
                                        decoration: BoxDecoration(
                                          color: context.colors.infoText.withValues(alpha: 0.05),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: context.colors.infoText.withValues(alpha: 0.1),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.info_outline_rounded, size: 18, color: context.colors.infoText),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                'Ce code sécurise l\'accès aux outils de pilotage de votre église.',
                                                style: AppTypography.bodySmall.copyWith(
                                                  color: context.colors.textSecondary,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
