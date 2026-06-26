// lib/core/animations/custom_page_transitions.dart
// Transitions de page premium avec le logo Lumina

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'dart:math' as math;
import 'package:go_router/go_router.dart';

/// Direction de la transition
enum TransitionDirection {
  push,
  pop,
}

/// Widget de transition personnalisée avec le logo Lumina
class FirePageTransition<T> extends PageRouteBuilder<T> {
  final Widget child;
  final TransitionDirection direction;
  FirePageTransition({
    super.settings,
    required this.child,
    this.direction = TransitionDirection.push,
    super.transitionDuration = const Duration(milliseconds: 350),
    super.reverseTransitionDuration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Stack(
      children: [
        // Écran de destination en arrière-plan
        SlideTransition(
          position: Tween<Offset>(
            begin: direction == TransitionDirection.push
                ? const Offset(1.0, 0.0)
                : const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.4, 1.0, curve: Curves.easeInOutCubic),
            ),
          ),
          child: child,
        ),
        // Animation du logo au centre (0.0 à 0.4)
        _FireLogoAnimation(
          animation: animation,
          direction: direction,
        ),
      ],
    );
  }
}

/// Animation du logo Lumina avec effet de feu
class _FireLogoAnimation extends StatelessWidget {
  final Animation<double> animation;
  final TransitionDirection direction;

  const _FireLogoAnimation({
    required this.animation,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final logoProgress = math.min(
            animation.value * 2.5, 1.0); // Accélérer l'animation du logo
        final fireOpacity = math.max(
            0.0, 1.0 - (animation.value * 2.5)); // Disparaître rapidement
        final scale = 0.5 + (logoProgress * 0.5); // De 0.5 à 1.0
        final fireScale =
            1.0 + (logoProgress * 2.0); // Effet de feu qui grandit

        // Le logo disparaît à 40% de l'animation
        if (animation.value > 0.4 && direction == TransitionDirection.push) {
          return const SizedBox.shrink();
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            // Effet de feu derrière le logo
            if (fireOpacity > 0.0)
              Transform.scale(
                scale: fireScale,
                child: Opacity(
                  opacity: fireOpacity,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          context.colors.brandSecondary.withValues(alpha: 0.8 * fireOpacity),
                          context.colors.brandSecondary.withValues(alpha: 0.4 * fireOpacity),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            // Logo Lumina
            Transform.scale(
              scale: scale,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: context.colors.brandGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.brandPrimary.withValues(alpha: 0.3),
                      blurRadius: 12.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icon/launcher_icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Particules de feu
            if (fireOpacity > 0.0) _buildFireParticles(context, fireOpacity, fireScale),
          ],
        );
      },
    );
  }

  Widget _buildFireParticles(BuildContext context, double opacity, double scale) {
    return Stack(
      children: List.generate(6, (index) {
        final angle = (index * 60) * math.pi / 180; // 6 particules en cercle
        final particleScale =
            scale * (0.8 + math.sin(animation.value * math.pi * 4) * 0.2);

        return Transform.translate(
          offset: Offset(
            math.cos(angle) * 60 * particleScale,
            math.sin(angle) * 60 * particleScale,
          ),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.brandSecondary.withValues(alpha: opacity),
            ),
          ),
        );
      }),
    );
  }
}

/// Page de transition personnalisée avec feu
class FireTransitionPage<T> extends Page<T> {
  final Widget child;
  final TransitionDirection direction;

  const FireTransitionPage({
    super.key,
    super.name,
    super.arguments,
    required this.child,
    this.direction = TransitionDirection.push,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return FirePageTransition(
      settings: this,
      child: child,
      direction: direction,
    );
  }
}

/// Extension pour facilement ajouter des transitions de feu
extension FireNavigationExtension on BuildContext {
  /// Naviguer vers une page avec transition de feu
  void goWithFire(String location) {
    Navigator.push(
      this,
      FirePageTransition(
        child: Builder(
          builder: (context) => Container(), // Remplacé par la route réelle
        ),
      ),
    );
  }
}

/// Wrapper pour GoRouter avec transitions de feu
class FireGoRouter {
  static Page<void> buildPageWithFireTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return FireTransitionPage(
      key: state.pageKey,
      child: child,
      direction: TransitionDirection.push,
    );
  }
}

/// Widget utilitaire pour les transitions de feu
class FireTransitionScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;

  const FireTransitionScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'fire-logo',
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        gradient: context.colors.brandGradient,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/icon/launcher_icon.png',
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(title!),
                ],
              )
            : null,
        actions: actions,
      ),
      body: body,
    );
  }
}
