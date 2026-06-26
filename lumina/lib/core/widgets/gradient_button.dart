// lib/core/widgets/gradient_button.dart
// Boutons avec gradient
import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import '../theme/app_typography.dart';
import '../theme/ember_aurum_shadows.dart';
import 'loading_dots.dart';

/// Bouton avec gradient
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final double? width;
  final double height;
  final double borderRadius;
  final IconData? icon;
  final bool isLoading;
  final bool outlined;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.gradient,
    this.width,
    this.height = 52,
    this.borderRadius = 12,
    this.icon,
    this.isLoading = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return _InteractiveScale(
      onPressed: isLoading ? null : onPressed,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    final effectiveGradient = gradient ?? context.colors.brandGradient;

    if (outlined) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: effectiveGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(borderRadius - 2),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(borderRadius - 2),
                child: Center(
                  child: _buildContent(context, isOutlined: true),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: onPressed != null ? effectiveGradient : null,
        color: onPressed == null ? context.colors.textDisabled.withOpacity(0.12) : null,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: onPressed != null ? EmberAurumShadows.fireGlow : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {bool isOutlined = false}) {
    if (isLoading) {
      return LoadingDots(
        size: 24,
        color: isOutlined
            ? context.colors.brandPrimary
            : context.colors.textOnBrand,
      );
    }

    final textColor = isOutlined
        ? context.colors.brandPrimary
        : context.colors.textOnBrand;

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: AppTypography.editorialSection.copyWith(
        color: textColor,
        fontSize: 14,
      ),
    );
  }
}

/// FAB avec gradient
class GradientFAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Gradient? gradient;
  final String? label;

  const GradientFAB({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.gradient,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = gradient ?? context.colors.brandGradient;

    final Widget fab = Container(
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        borderRadius: BorderRadius.circular(label != null ? 28 : 16),
        boxShadow: [
          BoxShadow(
            color: context.colors.brandPrimary.withValues(alpha: 0.4),
            blurRadius: 12.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(label != null ? 28 : 16),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: label != null ? 20 : 16,
              vertical: 16,
            ),
            child: label != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon,
                          color: context.colors.textOnBrand,
                          size: 24),
                      const SizedBox(width: 8),
                      Text(
                        label!,
                        style: TextStyle(
                          color: context.colors.textOnBrand,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Icon(icon,
                    color: context.colors.textOnBrand, size: 24),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: _InteractiveScale(
          onPressed: onPressed,
          child: fab,
        ),
      );
    }

    return _InteractiveScale(
      onPressed: onPressed,
      child: fab,
    );
  }
}

/// Widget utilitaire pour l'effet de pression (Scale)
class _InteractiveScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const _InteractiveScale({required this.child, this.onPressed});

  @override
  State<_InteractiveScale> createState() => _InteractiveScaleState();
}

class _InteractiveScaleState extends State<_InteractiveScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => widget.onPressed != null ? _controller.forward() : null,
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
