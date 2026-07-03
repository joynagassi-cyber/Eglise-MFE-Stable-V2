// lib/features/auth/presentation/pages/sign_up_page.dart
//
// Page d'inscription — Design conforme à la maquette de référence
// En-tête gradient orange, tab toggle, champs arrondis, swipe button, Google/Apple

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/password_strength.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/auth/domain/entities/auth_state.dart' as app_auth;
import '../widgets/password_strength_indicator.dart';
import '../widgets/swipe_auth_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isEmailValid = false;
  PasswordStrength _strength = PasswordStrength.weak;
  bool _isPasswordFocused = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(authProvider.notifier).register(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            name:
                '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
          );
    }
  }

  void _handleGoogleSignUp() async {
    await ref.read(authProvider.notifier).signInWithGoogle();
  }

  void _goToSignIn() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    ref.listen<AsyncValue>(authProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: context.colors.errorBg,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      } else if (next.valueOrNull is app_auth.AuthOnboardingRequired) {
        // L'onboarding est requis, GoRouter gérera la direction vers RoleSelection
      }
    });

    return Scaffold(
      backgroundColor: context.colors.bgPage,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ─── EN-TÊTE GRADIENT ───────────────────────────────
              _buildHeader(context, screenHeight),

              // ─── CONTENU FORMULAIRE ──────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24),

                      // Tab Toggle
                      _buildTabToggle(context, isSignUpActive: true),
                      SizedBox(height: 24),

                      // Prénom + Nom
                      Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Prénom'),
                              SizedBox(height: AppSpacing.sm),
                              _buildTextField(
                                controller: _firstNameController,
                                hint: 'Jean',
                                prefixIcon: Icons.person_outline_rounded,
                                validator: AppValidators.validateFirstName,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Nom'),
                              SizedBox(height: AppSpacing.sm),
                              _buildTextField(
                                controller: _lastNameController,
                                hint: 'Dupont',
                                prefixIcon: Icons.person_outline_rounded,
                                validator: AppValidators.validateLastName,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.lg),

                      // Email
                      _buildLabel('Email'),
                      SizedBox(height: AppSpacing.sm),
                      _buildTextField(
                        controller: _emailController,
                        hint: 'Entrez votre email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidators.validateEmail,
                        onChanged: (value) {
                          setState(() {
                            _isEmailValid =
                                AppValidators.validateEmail(value) == null;
                          });
                        },
                      ),
                      SizedBox(height: AppSpacing.lg),

                      // Mot de passe
                      _buildLabel('Mot de passe'),
                      SizedBox(height: AppSpacing.sm),
                      Focus(
                        onFocusChange: (focused) =>
                            setState(() => _isPasswordFocused = focused),
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _passwordController,
                              hint: 'Entrez votre mot de passe',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: _obscurePassword,
                              validator: AppValidators.validatePassword,
                              onChanged: (value) {
                                setState(() {
                                  _strength =
                                      PasswordStrengthEvaluator.evaluate(value);
                                });
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: context.colors.textTertiary,
                                  size: AppSpacing.iconSm,
                                ),
                                tooltip: _obscurePassword
                                    ? 'Afficher le mot de passe'
                                    : 'Masquer le mot de passe',
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            PasswordStrengthIndicator(
                              strength: _strength,
                              isVisible: _isPasswordFocused ||
                                  _passwordController.text.isNotEmpty,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      // Confirmer mot de passe
                      _buildLabel('Confirmer'),
                      SizedBox(height: 8),
                      _buildTextField(
                        controller: _confirmPasswordController,
                        hint: 'Confirmez votre mot de passe',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscureConfirm,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: context.colors.textTertiary,
                            size: LuminaIcon.md,
                          ),
                          tooltip: _obscureConfirm
                              ? 'Afficher la confirmation'
                              : 'Masquer la confirmation',
                          onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                      SizedBox(height: 28),

                      // Swipe to Sign Up
                      SwipeAuthButton(
                        label: 'Glisser pour s\'inscrire',
                        isLoading: state is AsyncLoading &&
                            state.valueOrNull
                                is! app_auth.AuthOnboardingRequired,
                        isDisabled: !_isEmailValid,
                        onCompleted: _handleSignUp,
                      ),
                      SizedBox(height: 24),

                      // Séparateur
                      _buildDivider('Ou continuer avec'),
                      SizedBox(height: 20),

                      // Boutons sociaux
                      _buildSocialButton(
                        label: 'S\'inscrire avec Google',
                        icon: _buildGoogleIcon(),
                        isLoading: state is AsyncLoading,
                        onTap: _handleGoogleSignUp,
                      ),
                      SizedBox(height: 24),

                      // Lien connexion
                      Center(
                        child: GestureDetector(
                          onTap: _goToSignIn,
                          child: RichText(
                            text: TextSpan(
                              text: 'Déjà inscrit ? ',
                              style: TextStyle(
                                color: context.colors.textSecondary,
                                fontSize: 14,
                                fontFamily: LuminaFont.body,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Se connecter',
                                  style: TextStyle(
                                    color: context.colors.brandPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── WIDGETS COMPOSANTS ──────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, double screenHeight) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: screenHeight * 0.28,
      decoration: BoxDecoration(
        gradient: context.colors.brandGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Décorations circulaires
            Positioned(
              top: -30,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.glassCardBg,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: -15,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.glassCardBg,
                ),
              ),
            ),

            // Contenu
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.colors.glassCardBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_fire_department_rounded,
                      size: LuminaIcon.xl,
                      color: context.colors.textOnBrand,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Lumina MFE-JC',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: context.colors.textOnBrand.withValues(alpha: 0.9),
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Créer un Compte',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: context.colors.textOnBrand,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Rejoignez la mission aujourd\'hui.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.colors.textOnBrand.withValues(alpha: 0.85),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabToggle(BuildContext context, {required bool isSignUpActive}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colors.bgSecondary,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _goToSignIn,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isSignUpActive
                      ? context.colors.bgCard
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: !isSignUpActive && !isDark
                      ? [
                          BoxShadow(
                            color: context.colors.bgOverlay,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'Connexion',
                  style: TextStyle(
                    fontWeight:
                        !isSignUpActive ? FontWeight.bold : FontWeight.w600,
                    color: !isSignUpActive
                        ? context.colors.textPrimary
                        : context.colors.textTertiary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {}, // Already on Sign Up
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSignUpActive
                      ? context.colors.bgCard
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: isSignUpActive && !isDark
                      ? [
                          BoxShadow(
                            color: context.colors.bgOverlay,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'Inscription',
                  style: TextStyle(
                    fontWeight:
                        isSignUpActive ? FontWeight.bold : FontWeight.w600,
                    color: isSignUpActive
                        ? context.colors.textPrimary
                        : context.colors.textTertiary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: context.colors.textPrimary,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 15,
        color: context.colors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: context.colors.textTertiary,
          fontSize: 14,
        ),
        prefixIcon:
            Icon(prefixIcon, color: context.colors.textTertiary, size: LuminaIcon.md),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: context.colors.bgCard,
        contentPadding: AppSpacing.inputPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: BorderSide(color: context.colors.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: BorderSide(color: context.colors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: BorderSide(
              color: context.colors.borderFocus.withValues(alpha: 0.5), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: BorderSide(color: context.colors.errorBorder),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: BorderSide(color: context.colors.errorBorder, width: 2),
        ),
      ),
    );
  }

  Widget _buildDivider(String label) {
    return Row(
      children: [
        Expanded(
            child: Divider(color: context.colors.borderSubtle, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label,
            style: TextStyle(
              color: context.colors.textTertiary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
            child: Divider(color: context.colors.borderSubtle, thickness: 1)),
      ],
    );
  }

  Widget _buildSocialButton({
    required String label,
    required Widget icon,
    bool isLoading = false,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 56, // Standard Lumina input/button height
        decoration: BoxDecoration(
          color: context.colors.bgCard,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: context.colors.borderSubtle,
            width: 1,
          ),
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: LoadingDots(size: LuminaIcon.lg),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  SizedBox(width: AppSpacing.md),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return SvgPicture.asset(
      'assets/icon/google_logo.svg',
      width: 24,
      height: 24,
    );
  }
}
