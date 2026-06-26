// lib/features/auth/presentation/widgets/swipe_auth_button.dart
// Bouton "Swipe to Login / Sign up" inspiré du design de référence

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/theme/app_spacing.dart';
class SwipeAuthButton extends StatefulWidget {
  final String label;
  final VoidCallback? onCompleted;
  final bool isLoading;
  final bool isDisabled;

  const SwipeAuthButton({
    super.key,
    required this.label,
    this.onCompleted,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  State<SwipeAuthButton> createState() => _SwipeAuthButtonState();
}

class _SwipeAuthButtonState extends State<SwipeAuthButton>
    with SingleTickerProviderStateMixin {
  double _dragPosition = 0;
  bool _completed = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  static const double _thumbSize = 56;
  static const double _trackHeight = 60;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxDrag = constraints.maxWidth - _thumbSize - 8;

        return AnimatedContainer(
          duration: AppSpacing.animationNormal,
          height: _trackHeight,
          decoration: BoxDecoration(
            gradient: widget.isDisabled
                ? LinearGradient(
                    colors: [context.colors.textDisabled, context.colors.borderStrong],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : context.colors.brandGradient,
            borderRadius: BorderRadius.circular(_trackHeight / 2),
            boxShadow: [
              if (!widget.isDisabled)
                BoxShadow(
                  color: context.colors.brandPrimary.withOpacity(0.3),
                  blurRadius: 12.0,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Label texte
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: widget.isLoading
                    ? 0.0
                    : (1 - (_dragPosition / maxDrag)).clamp(0.3, 1.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.isDisabled
                          ? Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withValues(alpha: 0.7)
                          : Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              // Loading indicator
              if (widget.isLoading)
                const SizedBox(
                  height: 24,
                  width: 24,
                  child: LoadingDots(size: LuminaIcon.lg),
                ),

              // Thumb draggable
              if (!widget.isLoading)
                Positioned(
                  left: 4 + _dragPosition,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (_completed || widget.isDisabled) return;
                      setState(() {
                        _dragPosition = (_dragPosition + details.delta.dx)
                            .clamp(0, maxDrag);
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      if (_completed || widget.isDisabled) return;
                      if (_dragPosition > maxDrag * 0.7) {
                        setState(() {
                          _dragPosition = maxDrag;
                          _completed = true;
                        });
                        widget.onCompleted?.call();
                        // Reset après un délai
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            setState(() {
                              _dragPosition = 0;
                              _completed = false;
                            });
                          }
                        });
                      } else {
                        setState(() {
                          _dragPosition = 0;
                        });
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Container(
                          width: _thumbSize,
                          height: _thumbSize - 8,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius:
                                BorderRadius.circular((_thumbSize - 8) / 2),
                            boxShadow: [
                              BoxShadow(
                                color: context.colors.bgOverlay,
                                blurRadius: 8 + (_pulseAnimation.value / 2),
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            _completed
                                ? Icons.check_rounded
                                : Icons.keyboard_double_arrow_right_rounded,
                            color: widget.isDisabled
                                ? context.colors.iconSecondary
                                : context.colors.brandPrimary,
                            size: 28,
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
