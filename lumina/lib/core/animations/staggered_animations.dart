// lib/core/animations/staggered_animations.dart
// Mixin pour les animations séquentielles de listes (Fire Identity)

import 'package:flutter/material.dart';
import '../theme/app_animations.dart';

/// Mixin permettant d'appliquer une animation séquentielle (staggered) aux items d'une liste.
mixin StaggeredListMixin {
  /// Génère une animation pour un item à un index donné.
  ///
  /// [index] l'index de l'item dans la liste.
  /// [delay] le délai de base (défaut 0.05s selon CAS 11).
  Widget staggeredItem({
    required int index,
    required Widget child,
    Duration delay = const Duration(milliseconds: 50),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: AppAnimations.entryStats, // Duration standard pour stats/listes
      curve: AppAnimations.curveIn,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1.0 - value)),
            child: child,
          ),
        );
      },
      // On utilise un Future.delayed simple ou on calcule le délai dans l'animation ?
      // Pour un mixin simple sans AnimationController externe, TweenAnimationBuilder avec un délai interne est complexe.
      // Une meilleure approche est d'utiliser un AnimationController si on est dans un StatefulWidget.
      child: child,
    );
  }
}

/// Widget utilitaire pour simplifier l'usage du staggered animation sans mixin complexe.
class StaggeredListItem extends StatelessWidget {
  final int index;
  final Widget child;
  final Duration delay;
  final Duration duration;

  const StaggeredListItem({
    super.key,
    required this.index,
    required this.child,
    this.delay = const Duration(milliseconds: 50),
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future:
          Future.delayed(Duration(milliseconds: delay.inMilliseconds * index)),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Opacity(opacity: 0);
        }
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: duration,
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1.0 - value)),
                child: child,
              ),
            );
          },
          child: child,
        );
      },
    );
  }
}
