// lib/core/widgets/stat_card.dart
// Widget réutilisable pour les cartes de statistiques premium (Fire Identity)

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../theme/app_animations.dart';

/// Carte de statistique réutilisable (Fire Identity)
class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? change;
  final IconData icon;
  final Color color;
  final bool isPrimary;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.change,
    this.isPrimary = false,
    this.onTap,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: AppAnimations.normal,
        curve: AppAnimations.defaultCurve,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppSpacing.borderRadiusCard,
            splashColor: widget.color.withOpacity(0.1),
            highlightColor: widget.color.withOpacity(0.05),
            child: AnimatedContainer(
              duration: AppAnimations.normal,
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                color:
                    widget.isPrimary ? widget.color : context.colors.bgCard,
                borderRadius: AppSpacing.borderRadiusCard,
                border: Border.all(
                  color: widget.isPrimary
                      ? Colors.transparent
                      : context.colors.borderSubtle,
                  width: 1,
                ),
                boxShadow: _isHovered
                    ? context.colors.brandGlow
                    : (widget.isPrimary
                        ? AppSpacing.shadowPrimary(widget.color)
                        : AppSpacing.shadowSm),
              ),
              child: widget.isPrimary
                  ? _buildPrimaryContent(context)
                  : _buildStandardContent(context, isDark),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryContent(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: Icon(widget.icon, color: Colors.white, size: 20),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                widget.value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      // L'utilisation de TextTheme injecte déjà Outfit pour headlineMedium
                    ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.colors.textOnBrand.withValues(alpha: 0.9),
                    ),
              ),
              if (widget.subtitle != null) ...[
                SizedBox(height: AppSpacing.xs),
                Text(
                  widget.subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.colors.textOnBrand,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ],
          ),
        ),
        Icon(
          widget.icon,
          size: 80,
          color: Colors.white.withOpacity(0.1),
        ),
      ],
    );
  }

  Widget _buildStandardContent(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.1),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Icon(widget.icon, color: widget.color, size: 20),
            ),
            if (widget.change != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.change!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: widget.color,
                      ),
                ),
              ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          widget.value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
        ),
        if (widget.subtitle != null) ...[
          SizedBox(height: AppSpacing.xs),
          Text(
            widget.subtitle!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.colors.textTertiary,
                ),
          ),
        ],
      ],
    );
  }
}
