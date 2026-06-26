import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lumina/core/theme/app_spacing.dart';
class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color? iconColor;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container with Subtle Glow
          Semantics(
            label: 'Icône de ${title.replaceAll('\n', ' ')}',
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.bgCard,
                boxShadow: [
                  BoxShadow(
                    color: context.colors.brandPrimary.withValues(alpha: 0.12),
                    blurRadius: 12.0,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: AppSpacing.iconHero,
                color: context.colors.brandPrimary,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xxl),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: AppSpacing.lg),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: context.colors.textSecondary,
                height: 1.6,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(
        begin: 0.1, end: 0, duration: 600.ms, curve: Curves.easeOutCubic);
  }
}
