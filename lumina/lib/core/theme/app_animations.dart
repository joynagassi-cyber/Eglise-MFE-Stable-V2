// lib/core/theme/app_animations.dart
// Constantes d'animations standardisées

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';

/// Animations et transitions standardisées
class AppAnimations {
  AppAnimations._();

  // ==========================================
  // DURATIONS
  // ==========================================

  /// 150ms - Animations très rapides (hover, ripple)
  static const Duration fastest = Duration(milliseconds: 150);

  /// 200ms - Animations rapides (focus, simple transitions) - MICRO
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration micro = fast; // Alias pour cohérence avec design spec

  /// 300ms - Animations standard (défaut pour la plupart des transitions) - STANDARD
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration standard =
      normal; // Alias pour cohérence avec design spec

  /// 500ms - Animations moyennes (modales, drawers)
  static const Duration medium = Duration(milliseconds: 500);

  /// 600ms - Animations avec emphase (graphiques, illustrations)
  static const Duration emphasis = Duration(milliseconds: 600);

  /// 800ms - Animations lentes (page transitions complexes)
  static const Duration slow = Duration(milliseconds: 800);

  /// 1200ms - Animations longues (intro, graphiques complexes)
  static const Duration long = Duration(milliseconds: 1200);

  // ==========================================
  // DURATIONS ASYMÉTRIQUES (CAS 04)
  // ==========================================

  /// Durées d'entrée (Légèrement plus longues pour la fluidité)
  static const Duration entryDetails = Duration(milliseconds: 320);
  static const Duration entryForm = Duration(milliseconds: 380);
  static const Duration entryStats = Duration(milliseconds: 300);
  static const Duration entryModal = Duration(milliseconds: 220);

  /// Durées de sortie (Légèrement plus rapides pour la réactivité)
  static const Duration exitStandard = Duration(milliseconds: 280);

  // ==========================================
  // STAGGER DELAYS (pour animations séquentielles)
  // ==========================================

  /// 50ms - Délai court entre éléments
  static const Duration staggerShort = Duration(milliseconds: 50);

  /// 100ms - Délai standard entre éléments
  static const Duration staggerMedium = Duration(milliseconds: 100);

  /// 150ms - Délai long entre éléments
  static const Duration staggerLong = Duration(milliseconds: 150);

  // ==========================================
  // CURVES STANDARDISÉES
  // ==========================================

  /// Courbe par défaut - easeInOutCubic (douce et naturelle)
  static const Curve defaultCurve = Curves.easeInOutCubic;

  /// Pour les entrées (fade in, slide in)
  static const Curve curveIn = Curves.easeOutCubic;

  /// Pour les sorties (fade out, slide out)
  static const Curve curveOut = Curves.easeIn;

  /// Pour les rebonds (boutons, interactions ludiques)
  static const Curve curveBounce = Curves.elasticOut;

  /// Pour les animations fluides (scrolling, dragging)
  static const Curve curveSmooth = Curves.easeInOutQuad;

  // ==========================================
  // PAGE TRANSITIONS ASYMÉTRIQUES
  // ==========================================

  /// Transition fade simple (Modales)
  static PageRouteBuilder<T> fadeTransition<T>({
    required Widget page,
    Duration duration = entryModal,
    Duration reverseDuration = exitStandard,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// Transition slide depuis le bas (Formulaires)
  static PageRouteBuilder<T> slideFromBottom<T>({
    required Widget page,
    Duration duration = entryForm,
    Duration reverseDuration = exitStandard,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curveIn),
        );
        final offsetAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// Transition slide depuis la droite (Détails)
  static PageRouteBuilder<T> slideFromRight<T>({
    required Widget page,
    Duration duration = entryDetails,
    Duration reverseDuration = exitStandard,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curveIn),
        );
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  /// Transition scale (Zoom - Stats)
  static PageRouteBuilder<T> scaleTransition<T>({
    required Widget page,
    Duration duration = entryStats,
    Duration reverseDuration = exitStandard,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: curveIn,
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  // ==========================================
  // WIDGET ANIMATIONS & IDENTITY (CAS 08)
  // ==========================================

  /// Animation de shimmer pour loading states
  static AnimationController createShimmerController({
    required TickerProvider vsync,
    Duration duration =
        const Duration(milliseconds: 1800), // Plus long (CAS 08)
  }) {
    return AnimationController(
      vsync: vsync,
      duration: duration,
    )..repeat();
  }

  /// Gradient Shimmer "Fire Identity" (theme-aware)
  static LinearGradient fireShimmerGradient(BuildContext context) {
    return LinearGradient(
      colors: [
        Colors.transparent,
        context.colors.brandPrimary.withValues(alpha: 0.15),
        context.colors.brandSecondary.withValues(alpha: 0.08),
        Colors.transparent,
      ],
      stops: const [0.0, 0.4, 0.6, 1.0],
      begin: const Alignment(-1.0, -0.3),
      end: const Alignment(1.0, 0.3),
      tileMode: TileMode.clamp,
    );
  }

  /// Tween pour shimmer gradient
  static Animation<double> shimmerAnimation(AnimationController controller) {
    return Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  /// Animation de pulse (pour attirer l'attention)
  static AnimationController createPulseController({
    required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    return AnimationController(
      vsync: vsync,
      duration: duration,
    )..repeat(reverse: true);
  }

  /// Animation de rotation continue
  static AnimationController createSpinController({
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 2),
  }) {
    return AnimationController(
      vsync: vsync,
      duration: duration,
    )..repeat();
  }

  // ==========================================
  // PREMIUM ONBOARDING & TUTORIAL (flutter_animate)
  // ==========================================

  /// Spring Physics - Duration for card entrance animations
  static const Duration springDuration = Duration(milliseconds: 500);

  /// Spring Physics - Curve for natural bounce effect
  static const Curve springCurve = Curves.easeOutBack;

  /// Spring Physics - Scale factor for button tap feedback
  static const double tapScaleFactor = 0.95;

  /// Shimmer - Duration for continuous shimmer loop
  static const Duration shimmerDuration = Duration(seconds: 2);

  /// Shimmer - Curve for smooth shimmer movement
  static const Curve shimmerCurve = Curves.linear;

  /// Progress Bars - Duration for fill animation
  static const Duration progressFillDuration = Duration(milliseconds: 300);

  /// Progress Bars - Curve for smooth fill transition
  static const Curve progressFillCurve = Curves.easeInOut;

  // ==========================================
  // GOROUTER PAGE HELPERS (CAS 04)
  // ==========================================

  /// Page transition fade (Modales)
  static CustomTransitionPage<T> fadePage<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = entryModal,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: exitStandard,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Page transition slide from bottom (Forms)
  static CustomTransitionPage<T> slideBottomPage<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = entryForm,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: exitStandard,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curveIn),
        );
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
    );
  }

  /// Page transition slide from right (Details)
  static CustomTransitionPage<T> slideRightPage<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = entryDetails,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: exitStandard,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curveIn),
        );
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// Page transition scale (Stats)
  static CustomTransitionPage<T> scalePage<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = entryStats,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: exitStandard,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: curveIn),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  // ==========================================
  // HELPERS
  // ==========================================

  /// Calcule le délai de stagger basé sur l'index
  static Duration getStaggerDelay(int index, {Duration? baseDelay}) {
    final delay = baseDelay ?? staggerMedium;
    return Duration(milliseconds: delay.inMilliseconds * index);
  }

  // ==========================================
  // IDENTITY SHIMMERS (CAS 08)
  // ==========================================

  static const shimmerGradientDark = LinearGradient(
    colors: [
      Color(0xFF2A2A4A),
      Color(0xFF3F3F6B),
      Color(0xFF2A2A4A),
    ],
    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  static const shimmerGradientLight = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );
}
