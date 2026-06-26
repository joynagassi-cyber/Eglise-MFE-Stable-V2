// lib/core/widgets/animated_entrance.dart
// Widget centralisé pour les animations d'entrée

import 'package:flutter/material.dart';
import 'package:lumina/core/theme/app_spacing.dart';
/// Animation d'entrée standardisée avec fade + slide
class AnimatedEntrance extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Offset? slideFrom;
  final bool fade;

  const AnimatedEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppSpacing.animationMedium,
    this.curve = Curves.easeInOutCubic,
    this.slideFrom,
    this.fade = true,
  });

  /// Constructeur pour animation depuis le bas
  const AnimatedEntrance.fromBottom({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppSpacing.animationMedium,
    this.curve = Curves.easeInOutCubic,
  })  : slideFrom = const Offset(0, 0.3),
        fade = true;

  /// Constructeur pour animation depuis la gauche
  const AnimatedEntrance.fromLeft({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppSpacing.animationMedium,
    this.curve = Curves.easeInOutCubic,
  })  : slideFrom = const Offset(-0.3, 0),
        fade = true;

  /// Constructeur pour animation depuis la droite
  const AnimatedEntrance.fromRight({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppSpacing.animationMedium,
    this.curve = Curves.easeInOutCubic,
  })  : slideFrom = const Offset(0.3, 0),
        fade = true;

  /// Constructeur pour animation depuis le haut
  const AnimatedEntrance.fromTop({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppSpacing.animationMedium,
    this.curve = Curves.easeInOutCubic,
  })  : slideFrom = const Offset(0, -0.3),
        fade = true;

  /// Constructeur pour fade uniquement
  const AnimatedEntrance.fade({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppSpacing.animationMedium,
    this.curve = Curves.easeInOutCubic,
  })  : slideFrom = null,
        fade = true;

  @override
  State<AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<AnimatedEntrance>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.slideFrom ?? Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Démarrer l'animation après le délai
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = widget.child;

    // Appliquer le slide si spécifié
    if (widget.slideFrom != null) {
      result = SlideTransition(
        position: _slideAnimation,
        child: result,
      );
    }

    // Appliquer le fade si activé
    if (widget.fade) {
      result = FadeTransition(
        opacity: _fadeAnimation,
        child: result,
      );
    }

    return result;
  }
}

/// Liste animée avec entrées séquentielles
class AnimatedList extends StatelessWidget {
  final List<Widget> children;
  final Duration delayBetween;
  final Duration itemDuration;
  final Axis scrollDirection;
  final EdgeInsetsGeometry? padding;

  const AnimatedList({
    super.key,
    required this.children,
    this.delayBetween = const Duration(milliseconds: 100),
    this.itemDuration = AppSpacing.animationMedium,
    this.scrollDirection = Axis.vertical,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      padding: padding,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return AnimatedEntrance.fromBottom(
          delay: delayBetween * index,
          duration: itemDuration,
          child: children[index],
        );
      },
    );
  }
}

/// Grid animé avec entrées séquentielles
class AnimatedGridView extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final Duration delayBetween;
  final Duration itemDuration;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry? padding;

  const AnimatedGridView({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.delayBetween = const Duration(milliseconds: 80),
    this.itemDuration = AppSpacing.animationMedium,
    this.mainAxisSpacing = AppSpacing.md,
    this.crossAxisSpacing = AppSpacing.md,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return AnimatedEntrance.fromBottom(
          delay: delayBetween * index,
          duration: itemDuration,
          child: children[index],
        );
      },
    );
  }
}
