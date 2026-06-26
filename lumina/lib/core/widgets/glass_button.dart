import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/widgets/glass_card.dart';

class GlassButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;

  const GlassButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  factory GlassButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return GlassButton(
      key: key,
      onPressed: onPressed,
      color: color,
      child: _GlassButtonIconContent(
        icon: icon,
        label: label,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onPressed,
      padding: padding,
      child: child,
    );
  }
}

class _GlassButtonIconContent extends StatelessWidget {
  final IconData icon;
  final String label;

  const _GlassButtonIconContent({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: context.colors.iconPrimary,
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
