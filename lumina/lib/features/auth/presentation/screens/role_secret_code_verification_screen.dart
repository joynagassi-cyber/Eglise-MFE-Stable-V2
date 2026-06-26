import 'dart:ui';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/auth/domain/entities/enums/role_level.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/utils/adaptive_code_formatter.dart';
import '../../../../core/utils/haptic_helper.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../data/repositories/role_code_repository.dart';

// ─── Provider pour les patterns du formateur ──────────────────────────────────
final roleCodePatternsProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final repo = ref.read(roleCodeRepositoryProvider);
  return repo.fetchAllPatterns();
});

final roleCodeRepositoryProvider = Provider<RoleCodeRepository>((ref) {
  // Compatible avec le provider existant de votre injection de dépendances.
  // Si vous utilisez déjà un provider different, remplacez cette ligne.
  throw UnimplementedError(
    'roleCodeRepositoryProvider doit être override dans ProviderScope. '
    'Vérifiez votre main.dart ou app_providers.dart.',
  );
});

class RoleSecretCodeVerificationScreen extends ConsumerStatefulWidget {
  final RoleLevel role;
  final Function(String code) onCodeVerified;

  const RoleSecretCodeVerificationScreen({
    super.key,
    required this.role,
    required this.onCodeVerified,
  });

  @override
  ConsumerState<RoleSecretCodeVerificationScreen> createState() =>
      _RoleSecretCodeVerificationScreenState();
}

class _RoleSecretCodeVerificationScreenState
    extends ConsumerState<RoleSecretCodeVerificationScreen> {
  final _codeController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isVerifying = false;
  bool _isCodeVisible = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    final rawInput = _codeController.text;
    if (rawInput.isEmpty) {
      setState(() => _errorMessage = 'Veuillez entrer le code secret');
      await HapticHelper.error();
      return;
    }

    // Normalisation finale : strip des tirets + majuscules.
    // Le serveur fait la même normalisation côté SQL.
    final normalizedCode = rawInput
        .trim()
        .toUpperCase()
        .replaceAll(RegExp(r'-+$'), ''); // supprime les tirets finaux résiduels

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      await widget.onCodeVerified(normalizedCode);
      await HapticHelper.success();
    } catch (e) {
      setState(() {
        _errorMessage = 'Code invalide. Vérifiez le code et réessayez.';
        _codeController.clear();
      });
      await HapticHelper.error();
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final roleColor = Color(
      int.parse(widget.role.color.replaceAll('#', '0xFF')),
    );

    // Charger les patterns pour le formateur adaptatif
    final patternsAsync = ref.watch(roleCodePatternsProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient:
                  context.colors.brandGradient,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.all(
                    AppSpacing.screenHorizontalPadding,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: isDark
                              ? context.colors.textPrimary
                              : context.colors.textPrimary,
                        ),
                        onPressed: () async {
                          await HapticHelper.light();
                          if (context.mounted) context.pop();
                        },
                        style: IconButton.styleFrom(
                          backgroundColor:
                              context.colors.bgCard.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(
                        AppSpacing.screenHorizontalPadding,
                      ),
                      child: ClipRRect(
                        borderRadius: AppSpacing.borderRadiusCard,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 500),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? context.colors.bgCard.withValues(alpha: 0.9)
                                  : context.colors.bgCard.withValues(alpha: 0.95),
                              borderRadius: AppSpacing.borderRadiusCard,
                              border: Border.all(
                                color: roleColor.withValues(alpha: 0.3),
                                width: 2,
                              ),
                              boxShadow: AppSpacing.shadowLg,
                            ),
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Icône de rôle
                                AnimatedEntrance.fromBottom(
                                  delay: const Duration(milliseconds: 100),
                                  child: Container(
                                    padding: const EdgeInsets.all(AppSpacing.lg),
                                    decoration: BoxDecoration(
                                      color: roleColor.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.lock_outline_rounded,
                                      size: LuminaIcon.mega,
                                      color: roleColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.lg),

                                // Titre
                                AnimatedEntrance.fromBottom(
                                  delay: const Duration(milliseconds: 150),
                                  child: Text(
                                    'Code Secret Requis',
                                    style:
                                        AppTypography.headlineMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? context.colors.textPrimary
                                          : context.colors.textPrimary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.sm),

                                // Sous-titre
                                AnimatedEntrance.fromBottom(
                                  delay: const Duration(milliseconds: 200),
                                  child: Text(
                                    'Entrez le code pour ${widget.role.label}',
                                    style: AppTypography.bodyLarge.copyWith(
                                      color: isDark
                                          ? context.colors.textSecondary
                                          : context.colors.textSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.md),

                                // Indicateur de format
                                AnimatedEntrance.fade(
                                  delay: const Duration(milliseconds: 220),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.md,
                                      vertical: AppSpacing.xs,
                                    ),
                                    decoration: BoxDecoration(
                                      color: roleColor.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Format : MOT-MOT-XXXX-2026',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: roleColor,
                                        fontFamily: LuminaFont.display,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xxl),

                                // Champ de saisie adaptatif
                                AnimatedEntrance.fromBottom(
                                  delay: const Duration(milliseconds: 250),
                                  child: patternsAsync.when(
                                    loading: () => _buildCodeField(
                                      context,
                                      isDark,
                                      theme,
                                      roleColor,
                                      formatter: null,
                                    ),
                                    error: (_, __) => _buildCodeField(
                                      context,
                                      isDark,
                                      theme,
                                      roleColor,
                                      formatter: null,
                                    ),
                                    data: (patterns) => _buildCodeField(
                                      context,
                                      isDark,
                                      theme,
                                      roleColor,
                                      formatter: AdaptiveCodeFormatter(expectedPatterns: patterns),
                                    ),
                                  ),
                                ),

                                // Message d'erreur
                                if (_errorMessage != null) ...[
                                  SizedBox(height: AppSpacing.md),
                                  AnimatedEntrance.fade(
                                    child: Container(
                                      padding:
                                          const EdgeInsets.all(AppSpacing.md),
                                      decoration: BoxDecoration(
                                        color: context.colors.errorText
                                            .withValues(alpha: 0.1),
                                        borderRadius: AppSpacing.borderRadiusMd,
                                        border: Border.all(
                                          color: context.colors.errorText
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline_rounded,
                                            color: context.colors.errorText,
                                            size: AppSpacing.iconMd,
                                          ),
                                          SizedBox(width: AppSpacing.sm),
                                          Expanded(
                                            child: Text(
                                              _errorMessage!,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: context.colors.errorText,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],

                                SizedBox(height: AppSpacing.xl),

                                // Bouton Vérifier
                                AnimatedEntrance.fromBottom(
                                  delay: const Duration(milliseconds: 300),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed:
                                          _isVerifying ? null : _verifyCode,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: roleColor,
                                        foregroundColor: context.colors.textOnBrand,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: AppSpacing.md,
                                        ),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              AppSpacing.borderRadiusMd,
                                        ),
                                      ),
                                      child: _isVerifying
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: LoadingDots(size: LuminaIcon.lg),
                                            )
                                          : Text(
                                              'VÉRIFIER',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                letterSpacing: 1.1,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: AppSpacing.lg),

                                // Aide
                                AnimatedEntrance.fade(
                                  delay: const Duration(milliseconds: 350),
                                  child: Text(
                                    'Contactez votre administrateur si vous n\'avez pas reçu le code',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: isDark
                                          ? context.colors.textTertiary
                                          : context.colors.textTertiary,
                                    ),
                                    textAlign: TextAlign.center,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeField(
    BuildContext context,
    bool isDark,
    ThemeData theme,
    Color roleColor, {
    required AdaptiveCodeFormatter? formatter,
  }) {
    return TextField(
      controller: _codeController,
      focusNode: _focusNode,
      autofocus: true,
      obscureText: !_isCodeVisible,
      textAlign: TextAlign.center,
      // Force le clavier à s'ouvrir en MAJUSCULES
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.visiblePassword,
      inputFormatters: [
        if (formatter != null) formatter,
      ],
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 4,
        fontFamily: LuminaFont.display,
        color: isDark
            ? context.colors.textPrimary
            : context.colors.textPrimary,
      ),
      onSubmitted: (_) => _verifyCode(),
      decoration: InputDecoration(
        hintText: 'MOT-MOT-XXXX-2026',
        hintStyle: theme.textTheme.bodyLarge?.copyWith(
          color: isDark
              ? context.colors.textTertiary
              : context.colors.textTertiary,
          letterSpacing: 2,
        ),
        filled: true,
        fillColor: isDark
            ? context.colors.bgPage
            : context.colors.bgPage,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(
            color: isDark ? context.colors.borderSubtle : context.colors.borderSubtle,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: roleColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        // Bouton afficher/masquer le code
        suffixIcon: IconButton(
          icon: Icon(
            _isCodeVisible
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
            color: isDark
                ? context.colors.textSecondary
                : context.colors.textSecondary,
          ),
          onPressed: () {
            setState(() => _isCodeVisible = !_isCodeVisible);
            // Garder le focus après le toggle
            _focusNode.requestFocus();
          },
          tooltip: _isCodeVisible ? 'Masquer le code' : 'Afficher le code',
        ),
      ),
    );
  }
}
