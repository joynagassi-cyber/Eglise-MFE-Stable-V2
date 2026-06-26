// lib/core/router/transition_factory.dart
//
// Usine de transitions pour GoRouter.
// Permet de définir des styles de transition par type de route pour une UX cohérente.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_animations.dart';

enum PageType {
  main,       // Transition douce ou fade
  detail,     // Slide from right
  form,       // Slide from bottom
  modal,      // Scale or fade
}

class TransitionFactory {
  static CustomTransitionPage buildPage({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    required PageType type,
  }) {
    switch (type) {
      case PageType.main:
        return AppAnimations.scalePage(
          key: state.pageKey,
          child: child,
        );
      case PageType.detail:
        return AppAnimations.slideRightPage(
          key: state.pageKey,
          child: child,
        );
      case PageType.form:
        return AppAnimations.slideBottomPage(
          key: state.pageKey,
          child: child,
        );
      case PageType.modal:
        return AppAnimations.scalePage(
          key: state.pageKey,
          child: child,
        );
    }
  }
}