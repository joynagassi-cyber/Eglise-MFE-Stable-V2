import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';

/// Barre de progression premium (déterminée ou indéterminée)
/// Remplace le LinearProgressIndicator natif.
class AppProgressBar extends StatefulWidget {
  final double? value; // null pour indéterminé
  final Color? color;
  final Color? backgroundColor;
  final double height;
  final double? width;
  final double? borderRadius;

  const AppProgressBar({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.height = 4.0,
    this.width,
    this.borderRadius,
  });

  @override
  State<AppProgressBar> createState() => _AppProgressBarState();
}

class _AppProgressBarState extends State<AppProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AppProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && oldWidget.value != null) {
      _controller.repeat();
    } else if (widget.value != null && oldWidget.value == null) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? context.colors.brandPrimary.withValues(alpha: 0.1);
    final valueColor = widget.color ?? context.colors.brandPrimary;

    return Container(
      height: widget.height,
      width: widget.width ?? double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(widget.height / 2),
      ),
      clipBehavior: Clip.hardEdge,
      child: widget.value != null
          ? FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: widget.value!.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: valueColor,
                  borderRadius: BorderRadius.circular(widget.height / 2),
                ),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final slide = _controller.value * (width + 100) - 100;
                    return Stack(
                      children: [
                        Positioned(
                          left: slide,
                          width: 100,
                          height: widget.height,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  valueColor.withValues(alpha: 0.0),
                                  valueColor,
                                  valueColor.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }
}
