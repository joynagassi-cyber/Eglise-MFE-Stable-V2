// lib/core/widgets/app_button.dart
// Bouton standardisé pour l'application

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'scale_button_wrapper.dart';
import 'loading_dots.dart';

enum AppButtonVariant { filled, outlined, text, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final AppButtonVariant variant;
  final double? width;
  final double height;
  final Color? color;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.variant = AppButtonVariant.filled,
    this.width,
    this.height = 48,
    this.color,
    this.textColor,
  });

  const factory AppButton.filled({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool loading,
    IconData? icon,
    double? width,
    double height,
    Color? color,
  }) = _AppButtonFilled;

  const factory AppButton.outlined({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool loading,
    IconData? icon,
    double? width,
    double height,
    Color? color,
  }) = _AppButtonOutlined;

  const factory AppButton.text({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool loading,
    IconData? icon,
    double? width,
    double height,
    Color? color,
  }) = _AppButtonText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading) ...[
          LoadingDots(
            size: 18,
            color: variant == AppButtonVariant.filled
                ? context.colors.textOnBrand
                : (color ?? context.colors.brandPrimary),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: 18, color: _getTextColor(context, isDark)),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: _getTextColor(context, isDark),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    Widget button;
    switch (variant) {
      case AppButtonVariant.filled:
        button = SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: loading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? context.colors.brandPrimary,
              foregroundColor: context.colors.textOnBrand,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: content,
          ),
        );
        break;
      case AppButtonVariant.outlined:
        button = SizedBox(
          width: width,
          height: height,
          child: OutlinedButton(
            onPressed: loading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: color ?? context.colors.brandPrimary,
              side: BorderSide(color: color ?? context.colors.brandPrimary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: content,
          ),
        );
        break;
      case AppButtonVariant.text:
      case AppButtonVariant.ghost:
        button = SizedBox(
          width: width,
          height: height,
          child: TextButton(
            onPressed: loading ? null : onPressed,
            style: TextButton.styleFrom(
              foregroundColor: color ?? context.colors.brandPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: content,
          ),
        );
        break;
    }

    return ScaleButtonWrapper(
      enabled: !loading && onPressed != null,
      child: button,
    );
  }

  Color _getTextColor(BuildContext context, bool isDark) {
    if (textColor != null) return textColor!;
    switch (variant) {
      case AppButtonVariant.filled:
        return context.colors.textOnBrand;
      case AppButtonVariant.outlined:
      case AppButtonVariant.text:
      case AppButtonVariant.ghost:
        return color ?? context.colors.brandPrimary;
    }
  }
}

class _AppButtonFilled extends AppButton {
  const _AppButtonFilled({
    super.key,
    required super.label,
    super.onPressed,
    super.loading,
    super.icon,
    super.width,
    super.height,
    super.color,
  }) : super(variant: AppButtonVariant.filled);
}

class _AppButtonOutlined extends AppButton {
  const _AppButtonOutlined({
    super.key,
    required super.label,
    super.onPressed,
    super.loading,
    super.icon,
    super.width,
    super.height,
    super.color,
  }) : super(variant: AppButtonVariant.outlined);
}

class _AppButtonText extends AppButton {
  const _AppButtonText({
    super.key,
    required super.label,
    super.onPressed,
    super.loading,
    super.icon,
    super.width,
    super.height,
    super.color,
  }) : super(variant: AppButtonVariant.text);
}
