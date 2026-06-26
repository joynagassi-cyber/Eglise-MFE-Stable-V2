// lib/core/animations/section_transitions.dart
// Animations pour les transitions entre sections

import 'package:flutter/material.dart';

/// Animations prédéfinies pour les transitions entre sections
class SectionTransitions {
  /// Transition slide horizontale (gauche/droite)
  static PageRouteBuilder horizontalSlide({
    required Widget child,
    RouteSettings? settings,
    bool fromRight = false,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: fromRight ? begin : -begin, end: end)
            .chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// Transition fade (fondu)
  static PageRouteBuilder fade({
    required Widget child,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 250),
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// Transition scale (zoom)
  static PageRouteBuilder scale({
    required Widget child,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// Transition slide verticale (haut/bas)
  static PageRouteBuilder verticalSlide({
    required Widget child,
    RouteSettings? settings,
    bool fromBottom = false,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: fromBottom ? begin : -begin, end: end)
            .chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// Animation pour l'ouverture d'un sous-écran (depuis la droite)
  static PageRouteBuilder modalSlide({
    required Widget child,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 350),
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// Animation combinée (fade + slide)
  static PageRouteBuilder fadeSlide({
    required Widget child,
    RouteSettings? settings,
    bool fromRight = false,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const slideBegin = Offset(1.0, 0.0);
        const slideEnd = Offset.zero;
        const curve = Curves.easeInOut;

        final slideTween =
            Tween(begin: fromRight ? slideBegin : -slideBegin, end: slideEnd)
                .chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }
}

/// Extension pour utiliser les animations facilement
extension SectionTransitionExtension on Navigator {
  /// Naviguer avec animation slide horizontale
  Future<T?> pushWithHorizontalSlide<T extends Object?>(
    BuildContext context,
    Widget page, {
    bool fromRight = false,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.of(context).push<T>(
      SectionTransitions.horizontalSlide(
        child: page,
        fromRight: fromRight,
        duration: duration,
      ) as Route<T>,
    );
  }

  /// Naviguer avec animation fade
  Future<T?> pushWithFade<T extends Object?>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 250),
  }) {
    return Navigator.of(context).push<T>(
      SectionTransitions.fade(
        child: page,
        duration: duration,
      ) as Route<T>,
    );
  }

  /// Naviguer avec animation scale
  Future<T?> pushWithScale<T extends Object?>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.of(context).push<T>(
      SectionTransitions.scale(
        child: page,
        duration: duration,
      ) as Route<T>,
    );
  }

  /// Naviguer avec animation slide verticale
  Future<T?> pushWithVerticalSlide<T extends Object?>(
    BuildContext context,
    Widget page, {
    bool fromBottom = false,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.of(context).push<T>(
      SectionTransitions.verticalSlide(
        child: page,
        fromBottom: fromBottom,
        duration: duration,
      ) as Route<T>,
    );
  }

  /// Naviguer avec animation modal (depuis le bas)
  Future<T?> pushWithModalSlide<T extends Object?>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 350),
  }) {
    return Navigator.of(context).push<T>(
      SectionTransitions.modalSlide(
        child: page,
        duration: duration,
      ) as Route<T>,
    );
  }

  /// Naviguer avec animation combinée fade + slide
  Future<T?> pushWithFadeSlide<T extends Object?>(
    BuildContext context,
    Widget page, {
    bool fromRight = false,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return Navigator.of(context).push<T>(
      SectionTransitions.fadeSlide(
        child: page,
        fromRight: fromRight,
        duration: duration,
      ) as Route<T>,
    );
  }
}
