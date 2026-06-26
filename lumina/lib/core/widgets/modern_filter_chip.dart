// lib/core/widgets/modern_filter_chip.dart
// Modern filter chip with gradient and animations

import 'package:flutter/material.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../theme/app_animations.dart';

class ModernFilterChip extends StatefulWidget {
  final String label;
  final bool selected;
  final Color color;
  final ValueChanged<bool> onSelected;

  const ModernFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.color,
    required this.onSelected,
  });

  @override
  State<ModernFilterChip> createState() => _ModernFilterChipState();
}

class _ModernFilterChipState extends State<ModernFilterChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onSelected(!widget.selected);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: AppAnimations.micro,
        curve: AppAnimations.defaultCurve,
        transform:
            _isPressed ? (Matrix4.identity()..scale(0.95)) : Matrix4.identity(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: widget.selected
              ? LinearGradient(
                  colors: [
                    widget.color,
                    widget.color.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: widget.selected ? null : theme.cardColor,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: widget.selected
                ? widget.color
                : widget.color.withValues(alpha: 0.3),
            width: widget.selected ? 2 : 1,
          ),
          boxShadow: widget.selected
              ? [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          widget.label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: widget.selected ? Colors.white : widget.color,
            fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
