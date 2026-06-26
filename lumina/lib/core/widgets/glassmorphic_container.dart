// lib/core/widgets/glassmorphic_container.dart
import 'dart:ui';
import 'package:flutter/material.dart';

/// Container réutilisable avec effet glassmorphique (verre dépoli)
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double blurRadius;
  final double backgroundOpacity;
  final Color backgroundColor;
  final double borderWidth;
  final double borderOpacity;
  final Color borderColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final bool showShadow;
  final Color? shadowColor;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;
  final Offset shadowOffset;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.blurRadius = 20.0,
    this.backgroundOpacity = 0.1,
    Color? backgroundColor,
    this.borderWidth = 0.5,
    this.borderOpacity = 0.2,
    Color? borderColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.showShadow = true,
    this.shadowColor,
    this.shadowBlurRadius = 24.0,
    this.shadowSpreadRadius = 0.0,
    this.shadowOffset = const Offset(0, 8),
  })  : backgroundColor = backgroundColor ?? Colors.white,
        borderColor = borderColor ?? Colors.white;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(24.0);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: (shadowColor ?? Colors.black).withOpacity(0.15),
                  blurRadius: shadowBlurRadius,
                  spreadRadius: shadowSpreadRadius,
                  offset: shadowOffset,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(backgroundOpacity),
              borderRadius: effectiveBorderRadius,
              border: Border.all(
                color: borderColor.withOpacity(borderOpacity),
                width: borderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
