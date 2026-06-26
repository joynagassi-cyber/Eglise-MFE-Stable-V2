import 'dart:ui';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../utils/haptic_helper.dart';

/// Carte avec effet glassmorphism allégé (Version 2026 - Performance & Clarté)
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? blur;
  final VoidCallback? onTap;
  final bool elevated;
  final bool showShine;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.backgroundColor,
    this.borderColor,
    this.blur,
    this.onTap,
    this.elevated = false,
    this.showShine = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? context.colors.glassCardBg.withOpacity(0.4);
    final border = borderColor ?? context.colors.glassCardBorder.withOpacity(0.1);

    final Widget content = Container(
      padding: padding ?? AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: border,
          width: 0.5,
        ),
      ),
      child: child,
    );

    final Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: elevated ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ] : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: (blur ?? 4.0).clamp(0.0, 4.0), // Flou plafonné à 4.0 (Performance & Design Standard 2026)
            sigmaY: (blur ?? 4.0).clamp(0.0, 4.0),
          ),
          child: content,
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: () async {
          await HapticHelper.light();
          onTap!();
        },
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      ).withTouchTarget();
    }

    return card;
  }
}
