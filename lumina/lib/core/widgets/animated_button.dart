import 'package:lumina/core/extensions/context_extension.dart';
// lib/core/widgets/animated_button.dart
// Widget de bouton avec animations premium pour micro-interactions

import 'package:flutter/material.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'loading_dots.dart';

/// Type d'animation pour le bouton
enum ButtonAnimationType {
  scale, // Rétrécissement au press
  elevation, // Changement d'ombre
  shimmer, // Effet de lumière
  slideUp, // Glissement vers le haut
  bounce, // Effet rebond
}

/// Widget AnimatedButton premium avec micro-interactions
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonAnimationType animationType;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool isLoading;
  final bool enabled;
  final Widget? icon;
  final Widget? trailing;
  final double? elevation;
  final FocusNode? focusNode;
  final Size? size;
  final String? tooltip;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.animationType = ButtonAnimationType.scale,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.trailing,
    this.elevation,
    this.focusNode,
    this.size,
    this.tooltip,
  });

  /// Bouton primaire stylisé
  factory AnimatedButton.primary({
    required Widget child,
    required BuildContext context,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool enabled = true,
    Widget? icon,
    Widget? trailing,
    String? tooltip,
  }) {
    return AnimatedButton(
      onPressed: onPressed,
      backgroundColor: context.colors.brandPrimary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      animationType: ButtonAnimationType.scale,
      padding: AppSpacing.buttonPadding,
      isLoading: isLoading,
      enabled: enabled,
      icon: icon,
      trailing: trailing,
      tooltip: tooltip,
      child: child,
    );
  }

  /// Bouton secondaire
  factory AnimatedButton.secondary({
    required Widget child,
    required BuildContext context,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool enabled = true,
    Widget? icon,
    Widget? trailing,
    String? tooltip,
  }) {
    return AnimatedButton(
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      foregroundColor: context.colors.brandPrimary,
      animationType: ButtonAnimationType.elevation,
      padding: AppSpacing.buttonPadding,
      isLoading: isLoading,
      enabled: enabled,
      icon: icon,
      trailing: trailing,
      tooltip: tooltip,
      child: child,
    );
  }

  /// Bouton d'action (FAB style)
  factory AnimatedButton.floating({
    required Widget child,
    required BuildContext context,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool enabled = true,
    String? tooltip,
  }) {
    return AnimatedButton(
      onPressed: onPressed,
      backgroundColor: context.colors.brandPrimary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      animationType: ButtonAnimationType.bounce,
      elevation: 6,
      size: const Size(56, 56),
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      isLoading: isLoading,
      enabled: enabled,
      tooltip: tooltip,
      child: child,
    );
  }

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  final bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppSpacing.animationNormal,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _elevationAnimation = Tween<double>(begin: 2.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.enabled || widget.isLoading) return;

    setState(() {
      _isPressed = true;
    });

    switch (widget.animationType) {
      case ButtonAnimationType.scale:
      case ButtonAnimationType.bounce:
        _controller.forward();
        break;
      case ButtonAnimationType.shimmer:
        break;
      default:
        break;
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.enabled || widget.isLoading) return;

    setState(() {
      _isPressed = false;
    });

    switch (widget.animationType) {
      case ButtonAnimationType.scale:
      case ButtonAnimationType.bounce:
        _controller.reverse();
        widget.onPressed?.call();
        _addRippleEffect(details.localPosition);
        break;
      case ButtonAnimationType.shimmer:
        widget.onPressed?.call();
        break;
      default:
        widget.onPressed?.call();
        break;
    }
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });

    if (_controller.isAnimating) {
      _controller.reverse();
    }
  }

  void _addRippleEffect(Offset position) {
    // Ajouter effet ripple personnalisé
  }

  Widget _buildButtonContent() {
    if (widget.isLoading) {
      return LoadingDots(
        size: 20,
        color: widget.foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
      );
    }

    final child = widget.child;

    if (widget.icon != null || widget.trailing != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            widget.icon!,
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(child: child),
          if (widget.trailing != null) ...[
            const SizedBox(width: AppSpacing.sm),
            widget.trailing!,
          ],
        ],
      );
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = widget.backgroundColor ??
        (isDark ? context.colors.bgCardElevated : context.colors.bgCard);
    final foregroundColor =
        widget.foregroundColor ?? context.colors.textPrimary;

    Widget button = Container(
      width: widget.size?.width,
      height: widget.size?.height,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: widget.borderRadius ?? AppSpacing.borderRadiusLg,
        boxShadow: widget.enabled
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: _elevationAnimation.value,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
        border: widget.animationType == ButtonAnimationType.elevation
            ? Border.all(
                color: foregroundColor.withValues(alpha: 0.3),
                width: 1,
              )
            : null,
      ),
      child: Center(
        child: DefaultTextStyle(
          style: DefaultTextStyle.of(context).style.copyWith(
                color: widget.enabled
                    ? foregroundColor
                    : foregroundColor.withValues(alpha: 0.5),
              ),
          child: _buildButtonContent(),
        ),
      ),
    );

    // Ajouter shimmer effect si nécessaire
    if (widget.animationType == ButtonAnimationType.shimmer && _isHovered) {
      button = ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            colors: [
              foregroundColor.withValues(alpha: 0.5),
              foregroundColor,
              foregroundColor.withValues(alpha: 0.5),
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(bounds);
        },
        child: button,
      );
    }

    if (widget.tooltip != null && widget.enabled) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    // Ajouter focus highlight pour accessibilité
    button = FocusableActionDetector(
      focusNode: widget.focusNode,
      onShowFocusHighlight: (hasFocus) {
        // Gérer le highlight focus
      },
      child: button,
    );

    // Appliquer transformation selon le type d'animation
    switch (widget.animationType) {
      case ButtonAnimationType.scale:
      case ButtonAnimationType.bounce:
        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                child: button,
              ),
            );
          },
        );
      case ButtonAnimationType.slideUp:
        return AnimatedContainer(
          duration: AppSpacing.animationFast,
          transform: _isPressed
              ? Matrix4.translationValues(0, -2, 0)
              : Matrix4.translationValues(0, 0, 0),
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: button,
          ),
        );
      default:
        return GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: button,
        );
    }
  }
}
