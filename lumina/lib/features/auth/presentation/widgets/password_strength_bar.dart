// lib/features/auth/presentation/widgets/password_strength_bar.dart
import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
enum PasswordStrength { none, weak, fair, strong, veryStrong }

class PasswordStrengthBar extends StatelessWidget {
  final String password;

  const PasswordStrengthBar({
    super.key,
    required this.password,
  });

  PasswordStrength _evaluate(String p) {
    if (p.isEmpty) return PasswordStrength.none;
    int score = 0;
    if (p.length >= 8) score++;
    if (p.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(p)) score++;
    if (RegExp(r'[0-9]').hasMatch(p)) score++;
    if (RegExp(r'[!@#\$&*~]').hasMatch(p)) score++;

    // Pas de séquences simples (ex: 123, abc) - Simplifié
    if (!RegExp(r'(123|abc|qwerty)').hasMatch(p.toLowerCase())) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 3) return PasswordStrength.fair;
    if (score <= 5) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  Color _getColor(BuildContext context, PasswordStrength s) => switch (s) {
        PasswordStrength.none => Colors.transparent,
        PasswordStrength.weak => context.colors.errorText,
        PasswordStrength.fair => context.colors.warningText,
        PasswordStrength.strong => context.colors.successText,
        PasswordStrength.veryStrong => context.colors.successText,
      };

  String _getLabel(PasswordStrength s) => switch (s) {
        PasswordStrength.none => '',
        PasswordStrength.weak => 'Faible',
        PasswordStrength.fair => 'Moyen',
        PasswordStrength.strong => 'Fort',
        PasswordStrength.veryStrong => 'Très fort',
      };

  double _getPercent(PasswordStrength s) => switch (s) {
        PasswordStrength.none => 0.0,
        PasswordStrength.weak => 0.25,
        PasswordStrength.fair => 0.5,
        PasswordStrength.strong => 0.75,
        PasswordStrength.veryStrong => 1.0,
      };

  @override
  Widget build(BuildContext context) {
    final strength = _evaluate(password);
    if (strength == PasswordStrength.none) return const SizedBox.shrink();

    final color = _getColor(context, strength);
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      duration: AppSpacing.animationMedium,
      curve: Curves.easeOut,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Stack(
                        children: [
                          Container(
                            height: 4,
                            color: theme.brightness == Brightness.dark
                                ? context.colors.borderSubtle
                                : context.colors.borderSubtle,
                          ),
                          AnimatedContainer(
                            duration: AppSpacing.animationMedium,
                            height: 4,
                            width: MediaQuery.of(context).size.width *
                                _getPercent(strength),
                            decoration: BoxDecoration(
                              color: color,
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.4),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    _getLabel(strength),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
