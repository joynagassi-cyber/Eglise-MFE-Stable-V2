// lib/core/widgets/section_header.dart
// Widget réutilisable pour les en-têtes de section

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
/// En-tête de section avec titre, icône optionnelle et action
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final LinearGradient? gradient;
  final Widget? trailing;
  final VoidCallback? onTrailingTap;
  final String? trailingLabel;
  final bool showDivider;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.gradient,
    this.trailing,
    this.onTrailingTap,
    this.trailingLabel,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = context.colors.textPrimary;

    final Widget header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: iconColor ?? context.colors.brandPrimary,
                size: 24,
              ),
              SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.colors.textSecondary,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (trailingLabel != null && onTrailingTap != null)
              TextButton(
                onPressed: onTrailingTap,
                child: Text(trailingLabel!),
              ),
          ],
        ),
        if (showDivider) ...[
          SizedBox(height: AppSpacing.md),
          Divider(
            color: context.colors.borderSubtle,
          ),
        ],
      ],
    );

    if (gradient != null) {
      return Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.smd),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              SizedBox(height: AppSpacing.md),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
              ),
            ],
          ],
        ),
      );
    }

    return header;
  }
}
