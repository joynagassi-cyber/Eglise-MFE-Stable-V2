// lib/features/auth/presentation/pages/sign_in_page.dart
//
// Page de connexion — Design conforme à la maquette de référence
// En-tête gradient orange, tab toggle, champs arrondis, swipe button, Google/Apple

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/auth/domain/entities/auth_state.dart' as app_auth;
import '../widgets/swipe_auth_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/three_d_cross_visual.dart';


class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

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
    _animController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(authProvider.notifier).login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  void _handleGoogleSignIn() async {
    await ref.read(authProvider.notifier).signInWithGoogle();
  }

  void _goToSignUp() {
    context.go(AppRoutes.register);
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
            backgroundColor: AppColors.errorOf(context),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      body: Stack(
        children: [
          FadeTransition(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // Tab Toggle
                      _buildTabToggle(context, isLoginActive: true),
                      const SizedBox(height: 28),

                      // Email
                      _buildLabel('Email'),
                      const SizedBox(height: AppSpacing.sm),
                      _buildTextField(
                        controller: _emailController,
                        hint: 'Entrez votre email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidators.validateEmail,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Mot de passe
                      _buildLabel('Mot de passe'),
                      const SizedBox(height: AppSpacing.sm),
                      _buildTextField(
                        controller: _passwordController,
                        hint: 'Entrez votre mot de passe',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        validator: AppValidators.validatePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textTertiary(context),
                            size: AppSpacing.iconSm,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Remember me + Forgot password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (v) =>
                                      setState(() => _rememberMe = v ?? false),
                                  activeColor: AppColors.brandOrange,
                                  checkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: BorderSide(
                                    color: AppColors.textTertiary(context),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Se souvenir de moi',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondaryOf(context),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Fonctionnalité disponible prochainement'),
                                  backgroundColor: AppColors.brandOrange,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: const Text(
                              'Mot de passe oublié ?',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.brandOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Swipe to Login
                      SwipeAuthButton(
                        label: 'Glisser pour se connecter',
                        isLoading: state is AsyncLoading &&
                            state.valueOrNull is! app_auth.AuthAuthenticated,
                        onCompleted: _handleSignIn,
                      ),
                      const SizedBox(height: 24),

                      // Séparateur
                      _buildDivider('Ou continuer avec'),
                      const SizedBox(height: 20),

                      // Boutons sociaux
                      _buildSocialButton(
                        label: 'Se connecter avec Google',
                        icon: _buildGoogleIcon(),
                        isLoading: state is AsyncLoading,
                        onTap: _handleGoogleSignIn,
                      ),
                      const SizedBox(height: 24),

                      // Lien inscription
                      Center(
                        child: GestureDetector(
                          onTap: _goToSignUp,
                          child: RichText(
                            text: TextSpan(
                              text: 'Pas de compte ? ',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondaryOf(context),
                                  ),
                              children: const [
                                TextSpan(
                                  text: 'Créer un compte',
                                  style: TextStyle(
                                    color: AppColors.brandOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
                ],
              ),
            ),
          ),
          if (state is AsyncLoading && state.valueOrNull is! app_auth.AuthAuthenticated)
            Positioned.fill(
              child: Container(
                color: context.colors.bgPage.withOpacity(0.7),
                child: const Center(
                  child: ThreeDCrossVisual(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── WIDGETS COMPOSANTS ──────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, double screenHeight) {
    final isDark = AppColors.isDark(context);
    return Container(
      width: double.infinity,
      height: screenHeight * 0.3,
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.darkGradient : AppColors.fireGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Décorations circulaires en arrière-plan
            Positioned(
              top: -30,
              left: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),

            // Contenu
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lumina MFE-JC',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Bon Retour !',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Connectez-vous pour continuer\nvotre mission.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          height: 1.4,
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

  Widget _buildTabToggle(BuildContext context, {required bool isLoginActive}) {
    final isDark = AppColors.isDark(context);
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isLoginActive
                      ? AppColors.card(context)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: isLoginActive && !isDark
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
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
                        isLoginActive ? FontWeight.bold : FontWeight.w600,
                    color: isLoginActive
                        ? AppColors.textPrimary(context)
                        : AppColors.textTertiary(context),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: _goToSignUp,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isLoginActive
                      ? AppColors.card(context)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: !isLoginActive && !isDark
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
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
                        !isLoginActive ? FontWeight.bold : FontWeight.w600,
                    color: !isLoginActive
                        ? AppColors.textPrimary(context)
                        : AppColors.textTertiary(context),
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
        color: AppColors.textPrimary(context),
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
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(
        fontSize: 15,
        color: AppColors.textPrimary(context),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.textTertiary(context),
          fontSize: 14,
        ),
        prefixIcon:
            Icon(prefixIcon, color: AppColors.textTertiary(context), size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor:
            AppColors.isDark(context) ? AppColors.surfaceDark : Colors.white,
        contentPadding: AppSpacing.inputPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: BorderSide(color: AppColors.divider(context)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: BorderSide(color: AppColors.divider(context)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: BorderSide(
              color: AppColors.brandOrange.withValues(alpha: 0.5), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: BorderSide(color: AppColors.errorOf(context)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: BorderSide(color: AppColors.errorOf(context), width: 2),
        ),
      ),
    );
  }

  Widget _buildDivider(String label) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: AppColors.divider(context), thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.textTertiary(context),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: AppColors.divider(context), thickness: 1),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String label,
    required Widget icon,
    bool isLoading = false,
    required VoidCallback? onTap,
  }) {
    final isDark = AppColors.isDark(context);
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 56, // Standard Lumina input/button height
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: isDark ? AppColors.dividerLight : AppColors.divider(context),
            width: 1,
          ),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: LoadingDots(size: 24),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.textPrimary(context),
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

