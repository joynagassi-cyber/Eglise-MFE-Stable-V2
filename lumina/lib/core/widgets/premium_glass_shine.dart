import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Un widget qui ajoute un reflet de lumière doux (glossy shine) glissant sur son contenu.
/// Idéal pour les cartes en verre (glassmorphism) pour un aspect premium.
class PremiumGlassShine extends StatelessWidget {
  final Widget? child;
  final double borderRadius;
  final Duration duration;
  final double opacity;
  final double width;

  const PremiumGlassShine({
    super.key,
    this.child,
    this.borderRadius = 16,
    this.duration = const Duration(seconds: 4),
    this.opacity = 0.1,
    this.width = 0.6,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        children: [
          if (child != null) child!,
          Positioned.fill(
            child: const SizedBox.expand()
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  duration: duration,
                  color: Colors.white.withOpacity(opacity),
                  size: width,
                  angle: 0.8, // Angle diagonal pour un aspect naturel
                ),
          ),
        ],
      ),
    );
  }
}
