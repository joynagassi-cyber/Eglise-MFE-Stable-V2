// lib/features/auth/presentation/screens/password_recovery_screen.dart
import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/widgets/backgrounds/fire_animated_background.dart';
import '../../../../core/widgets/glass_card.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/auth_primary_button.dart';

class PasswordRecoveryScreen extends ConsumerStatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  ConsumerState<PasswordRecoveryScreen> createState() =>
      _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState
    extends ConsumerState<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSent = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleRecover() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _errorMessage = null);

    try {
      await ref.read(authProvider.notifier).requestPasswordReset(
            email: _emailController.text.trim(),
          );
      setState(() => _isSent = true);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const FireAnimatedBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Theme.of(context).colorScheme.onPrimary),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Icon(
                    Icons.lock_reset_rounded,
                    size: LuminaIcon.giga,
                    color: context.colors.brandPrimary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Récupération',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Entrez votre email pour réinitialiser votre mot de passe',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withValues(alpha: 0.7)),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  GlassCard(
                    child: _isSent
                        ? Column(
                            children: [
                              Icon(Icons.check_circle_outline_rounded,
                                  color: context.colors.successText, size: LuminaIcon.xxl),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'Email envoyé !',
                                style: theme.textTheme.titleLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Consultez votre boîte de réception pour les instructions.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7)),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              AuthPrimaryButton(
                                label: 'RETOUR',
                                onPressed: () => context.pop(),
                              ),
                            ],
                          )
                        : Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (_errorMessage != null) ...[
                                  Text(
                                    _errorMessage!,
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(color: context.colors.errorText),
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                ],
                                AuthFormField(
                                  label: 'Email',
                                  hint: 'votre@email.com',
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icons.email_outlined,
                                  textInputAction: TextInputAction.done,
                                  onEditingComplete: _handleRecover,
                                  validator: (v) =>
                                      (v == null || !v.contains('@'))
                                          ? 'Email invalide'
                                          : null,
                                ),
                                const SizedBox(height: AppSpacing.xl),
                                AuthPrimaryButton(
                                  label: 'ENVOYER LES INSTRUCTIONS',
                                  onPressed: _handleRecover,
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
