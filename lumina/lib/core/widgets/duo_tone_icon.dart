import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';

/// A premium Duo-tone icon widget that overlays two layers of iconography.
///
/// This widget achieves the "Modern Duo-tone" look by layering a translucent
/// background version of the icon with a solid foreground version.
class DuoToneIcon extends StatelessWidget {
  final IconData icon;
  final IconData? backgroundIcon;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final double backgroundOpacity;
  final Offset backgroundOffset;
  final bool isFlamboyant;

  const DuoToneIcon({
    super.key,
    required this.icon,
    this.backgroundIcon,
    this.size = 24,
    this.color,
    this.backgroundColor,
    this.backgroundOpacity = 0.25,
    this.backgroundOffset = const Offset(2, 2),
    this.isFlamboyant = false,
  });

  @override
  Widget build(BuildContext context) {
    final mainColor = color ?? context.colors.brandSecondary;
    final secondaryColor = backgroundColor ?? color ?? context.colors.brandPrimary;

    Widget iconWidget = Icon(
      icon,
      size: size,
      color: mainColor,
    );

    if (isFlamboyant) {
      iconWidget = ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            mainColor,
            mainColor.withValues(alpha: 0.8),
            Colors.orangeAccent,
            Colors.yellowAccent,
          ],
          stops: const [0.0, 0.4, 0.8, 1.0],
        ).createShader(bounds),
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Background Layer (Translucent & slightly offset)
        Positioned(
          left: backgroundOffset.dx,
          top: backgroundOffset.dy,
          child: Icon(
            backgroundIcon ?? icon,
            size: size,
            color: secondaryColor.withValues(alpha: backgroundOpacity),
          ),
        ),

        // Glow effect if flamboyant
        if (isFlamboyant)
          Container(
            width: size * 0.6,
            height: size * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: mainColor.withValues(alpha: 0.4),
                  blurRadius: size * 0.8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

        // Foreground Layer
        iconWidget,
      ],
    );
  }
}
