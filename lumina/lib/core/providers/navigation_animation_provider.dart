// lib/core/providers/navigation_animation_provider.dart
// Provider pour gérer les animations de navigation entre sections

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// État de l'animation de navigation
class NavigationAnimationState {
  final int previousSectionIndex;
  final int currentSectionIndex;
  final bool isAnimating;

  NavigationAnimationState({
    required this.previousSectionIndex,
    required this.currentSectionIndex,
    required this.isAnimating,
  });

  NavigationAnimationState copyWith({
    int? previousSectionIndex,
    int? currentSectionIndex,
    bool? isAnimating,
  }) {
    return NavigationAnimationState(
      previousSectionIndex: previousSectionIndex ?? this.previousSectionIndex,
      currentSectionIndex: currentSectionIndex ?? this.currentSectionIndex,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }

  /// Vérifie si la navigation va vers la droite
  bool get isMovingRight => currentSectionIndex > previousSectionIndex;

  /// Vérifie si la navigation va vers la gauche
  bool get isMovingLeft => currentSectionIndex < previousSectionIndex;

  /// Vérifie si la section a changé
  bool get hasSectionChanged => currentSectionIndex != previousSectionIndex;
}

/// Notifier pour les animations de navigation
class NavigationAnimationNotifier
    extends StateNotifier<NavigationAnimationState> {
  NavigationAnimationNotifier()
      : super(
          NavigationAnimationState(
            previousSectionIndex: 0,
            currentSectionIndex: 0,
            isAnimating: false,
          ),
        );

  /// Naviguer vers une nouvelle section avec animation
  void navigateToSection(int newIndex) {
    if (newIndex == state.currentSectionIndex) return;

    // Commencer l'animation
    state = state.copyWith(
      previousSectionIndex: state.currentSectionIndex,
      currentSectionIndex: newIndex,
      isAnimating: true,
    );

    // Simuler la fin de l'animation après un délai
    Future.delayed(const Duration(milliseconds: 300), () {
      state = state.copyWith(
        isAnimating: false,
      );
    });
  }

  /// Réinitialiser l'état d'animation
  void reset() {
    state = NavigationAnimationState(
      previousSectionIndex: state.currentSectionIndex,
      currentSectionIndex: state.currentSectionIndex,
      isAnimating: false,
    );
  }

  /// Obtenir la direction de l'animation pour le slide
  bool getAnimationDirection(int newIndex) {
    return newIndex > state.currentSectionIndex;
  }
}

final navigationAnimationProvider = StateNotifierProvider<
    NavigationAnimationNotifier, NavigationAnimationState>(
  (ref) => NavigationAnimationNotifier(),
);

/// Widget wrapper pour ajouter des animations aux transitions de section
class AnimatedNavigationWrapper extends ConsumerWidget {
  final Widget child;

  const AnimatedNavigationWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationState = ref.watch(navigationAnimationProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        // Animation slide basée sur la direction de navigation
        final offsetAnimation = Tween<Offset>(
          begin: animationState.isMovingRight
              ? const Offset(-1.0, 0.0)
              : const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      child: KeyedSubtree(
        key: ValueKey<int>(animationState.currentSectionIndex),
        child: child,
      ),
    );
  }
}
