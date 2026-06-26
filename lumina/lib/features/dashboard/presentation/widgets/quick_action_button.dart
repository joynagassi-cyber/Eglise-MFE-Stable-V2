import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../../core/utils/haptic_helper.dart';

class QuickActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool useDuoTone;

  const QuickActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.useDuoTone = true,
  });

  @override
  State<QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<QuickActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      label: widget.label,
      hint: 'Action rapide: ${widget.label}',
      button: true,
      enabled: true,
      child: Tooltip(
        message: widget.label,
        child: ElasticPressable(
          onTap: widget.onTap,
          hapticType: HapticFeedbackType.medium,
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 72,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Iconic Container (Solid Soft Tint)
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(isDark ? 0.2 : 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.color.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: widget.useDuoTone
                        ? DuoToneIcon(
                            icon: widget.icon,
                            color: widget.color,
                            size: 32,
                            backgroundOpacity: 0.25,
                          )
                        : Icon(
                            widget.icon,
                            color: widget.color,
                            size: 32,
                          ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
