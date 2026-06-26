// lib/features/onboarding/presentation/widgets/stories_progress_indicator.dart
import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import '../../../../core/theme/app_animations.dart';

/// Indicateur de progression style Instagram Stories
class StoriesProgressIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color? activeColor;
  final Color? inactiveColor;
  final double height;
  final double spacing;

  const StoriesProgressIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.activeColor,
    this.inactiveColor,
    this.height = 4.0,
    this.spacing = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? context.colors.brandPrimary;
    final inactive = inactiveColor ?? context.colors.borderSubtle;

    return Semantics(
      label: 'Page ${currentIndex + 1} sur $count',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (index) {
          final isActive = index <= currentIndex;

          return Expanded(
            child: Container(
              height: height,
              margin: EdgeInsets.symmetric(horizontal: spacing / 2),
              decoration: BoxDecoration(
                color: inactive,
                borderRadius: BorderRadius.circular(height / 2),
              ),
              child: AnimatedContainer(
                duration: AppAnimations.progressFillDuration,
                curve: AppAnimations.progressFillCurve,
                width: isActive ? double.infinity : 0,
                decoration: BoxDecoration(
                  color: active,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
