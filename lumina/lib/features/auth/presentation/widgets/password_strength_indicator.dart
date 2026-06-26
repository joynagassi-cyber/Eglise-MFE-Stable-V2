// lib/features/auth/presentation/widgets/password_strength_indicator.dart

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/utils/password_strength.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;
  final bool isVisible;

  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: AppSpacing.animationNormal,
      opacity: isVisible ? 1.0 : 0.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.sm),
          Row(
            children: List.generate(4, (index) {
              final bool isActive = _getStrengthIndex(strength) >= index;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == 3 ? 0 : 4),
                  child: AnimatedContainer(
                    duration: AppSpacing.animationMedium,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isActive
                          ? strength.color(context.colors)
                          : context.colors.borderDefault,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            strength.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: strength.color(context.colors),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  int _getStrengthIndex(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 0;
      case PasswordStrength.fair:
        return 1;
      case PasswordStrength.strong:
        return 2;
      case PasswordStrength.veryStrong:
        return 3;
    }
  }
}
