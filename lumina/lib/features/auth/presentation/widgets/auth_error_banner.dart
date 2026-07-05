// lib/features/auth/presentation/widgets/auth_error_banner.dart

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
class AuthErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const AuthErrorBanner({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.smd,
      ),
      decoration: BoxDecoration(
        color: context.colors.errorBg,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: context.colors.errorBorder, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: context.colors.errorText, size: LuminaIcon.md),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.colors.errorText,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: Icon(Icons.close, color: context.colors.errorText, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
