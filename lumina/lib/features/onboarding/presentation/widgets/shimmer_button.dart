// lib/features/onboarding/presentation/widgets/shimmer_button.dart
import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lumina/core/theme/lumina_colors_extension.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/utils/haptic_helper.dart';

/// Bouton avec gradient premium et animation shimmer continue
class ShimmerButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool enabled;

  const ShimmerButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.enabled = true,
  });

  @override
  State<ShimmerButton> createState() => _ShimmerButtonState();
}

class _ShimmerButtonState extends State<ShimmerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: AppAnimations.shimmerDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: widget.text,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.enabled
              ? () async {
                  await HapticHelper.medium();
                  widget.onPressed();
                }
              : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: context.colors.brandGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: context.colors.brandPrimary.withValues(alpha: 0.25),
                  blurRadius: 12.0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Shimmer overlay
                AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment(
                            -1.0 - _shimmerController.value * 2,
                            0,
                          ),
                          end: Alignment(
                            1.0 - _shimmerController.value * 2,
                            0,
                          ),
                          colors: [
                            Colors.transparent,
                            context.colors.textInverse.withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Content
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.text,
                        style: TextStyle(
                          color: context.colors.textInverse,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (widget.icon != null) ...[
                        const SizedBox(width: 12),
                        Icon(
                          widget.icon,
                          color: context.colors.textInverse,
                          size: LuminaIcon.md,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scaleXY(
                begin: 1.0,
                end: AppAnimations.tapScaleFactor,
                duration: 150.ms,
                curve: Curves.easeInOut,
              ),
        ),
      ),
    );
  }
}
