// lib/core/animations/app_animations.dart
// Animations centralisées et helpers pour le design system

import 'package:flutter/material.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../theme/lumina_colors_extension.dart';

/// Constantes et helpers d'animation pour l'app
class AppAnimations {
  AppAnimations._();

  // ==========================================
  // DURATIONS
  // ==========================================

  /// 150ms - Micro-interactions (hover, ripple)
  static const Duration micro = Duration(milliseconds: 150);

  /// 200ms - Fast animations (button press, focus)
  static const Duration fast = AppSpacing.animationFast;

  /// 300ms - Standard animations (transitions, entrances)
  static const Duration normal = AppSpacing.animationMedium;

  /// 500ms - Slow animations (page transitions, complex animations)
  static const Duration slow = AppSpacing.animationSlow;

  /// 700ms - Very slow (emphasis animations)
  static const Duration verySlow = Duration(milliseconds: 700);

  // ==========================================
  // CURVES
  // ==========================================

  /// Courbe standard (Material Design)
  static const Curve standard = Curves.easeInOutCubic;

  /// Courbe accélération (entrées)
  static const Curve emphasized = Curves.easeOutCubic;

  /// Courbe décélération (sorties)
  static const Curve decelerate = Curves.easeOut;

  /// Courbe accélération
  static const Curve accelerate = Curves.easeIn;

  /// Courbe élastique (effet bounce)
  static const Curve elastic = Curves.elasticOut;

  /// Courbe spring (rebond naturel)
  static const Curve spring = Curves.easeInOutBack;

  // ==========================================
  // STAGGER DELAYS
  // ==========================================

  /// Délai entre items de liste (50ms)
  static const Duration staggerListDelay = Duration(milliseconds: 50);

  /// Délai entre items de grille (30ms - plus rapide)
  static const Duration staggerGridDelay = Duration(milliseconds: 30);

  /// Délai entre sections (100ms)
  static const Duration staggerSectionDelay = Duration(milliseconds: 100);

  /// Calcule le délai staggered pour un index donné
  static Duration getStaggerDelay(int index,
      {Duration baseDelay = staggerListDelay}) {
    return baseDelay * index;
  }

  /// Calcule le délai staggered avec un maximum
  static Duration getStaggerDelayWithMax(
    int index, {
    Duration baseDelay = staggerListDelay,
    int maxItems = 10,
  }) {
    final cappedIndex = index > maxItems ? maxItems : index;
    return baseDelay * cappedIndex;
  }

  // ==========================================
  // PAGE TRANSITIONS
  // ==========================================

  /// Transition Fade + Slide (standard)
  static PageTransitionsBuilder get fadeSlideTransition =>
      const FadeUpwardsPageTransitionsBuilder();

  /// Transition personnalisée Fade + Slide from Bottom
  static Route fadeSlideFromBottom(Widget page, {RouteSettings? settings}) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.1);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        final offsetAnimation = animation.drive(tween);
        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: normal,
    );
  }

  /// Transition Scale (modales)
  static Route scaleTransition(Widget page, {RouteSettings? settings}) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        final scaleAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );
        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(scaleAnimation),
            child: child,
          ),
        );
      },
      transitionDuration: fast,
    );
  }

  // ==========================================
  // IMPLICIT ANIMATION HELPERS
  // ==========================================

  /// AnimatedContainer avec les valeurs par défaut de l'app
  static Duration get containerDuration => normal;
  static Curve get containerCurve => standard;

  /// AnimatedOpacity avec les valeurs par défaut de l'app
  static Duration get opacityDuration => fast;
  static Curve get opacityCurve => standard;

  /// AnimatedScale avec les valeurs par défaut de l'app
  static Duration get scaleDuration => fast;
  static Curve get scaleCurve => elastic;

  /// AnimatedRotation avec les valeurs par défaut de l'app
  static Duration get rotationDuration => normal;
  static Curve get rotationCurve => standard;

  /// AnimatedPositioned avec les valeurs par défaut de l'app
  static Duration get positionedDuration => normal;
  static Curve get positionedCurve => emphasized;

  // ==========================================
  // SHIMMER LOADING
  // ==========================================

  /// Durée du shimmer loading
  static const Duration shimmerDuration = Duration(milliseconds: 1500);

  /// Gradient shimmer (theme-aware)
  static LinearGradient shimmerGradient(BuildContext context) {
    final colors = Theme.of(context).extension<LuminaColorsExtension>()!;
    return LinearGradient(
      begin: const Alignment(-1.0, 0.0),
      end: const Alignment(1.0, 0.0),
      colors: [
        colors.shimmerBase,
        colors.shimmerHighlight,
        colors.shimmerBase,
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  // ==========================================
  // HAPTIC FEEDBACK DELAYS
  // ==========================================

  /// Délai avant haptic feedback
  static const Duration hapticDelay = Duration.zero;

  // ==========================================
  // HERO ANIMATION
  // ==========================================

  /// Durée des Hero animations
  static const Duration heroDuration = Duration(milliseconds: 300);

  // ==========================================
  // RIPPLE EFFECT
  // ==========================================

  /// Durée de l'effet ripple
  static const Duration rippleDuration = Duration(milliseconds: 200);

  /// Rayon du splash
  static const double splashRadius = 24.0;

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

/// Extension sur Widget pour faciliter l'ajout d'animations
extension AnimatedWidgetExtension on Widget {
  /// Enveloppe le widget dans une AnimatedEntrance avec fade + slide from bottom
  Widget withEntrance({
    Duration delay = Duration.zero,
    Duration duration = AppAnimations.normal,
  }) {
    return _AnimatedEntranceWrapper(
      delay: delay,
      duration: duration,
      child: this,
    );
  }

  /// Enveloppe le widget dans une AnimatedScale au hover
  Widget withHoverScale({
    double scale = 1.05,
  }) {
    return _HoverScaleWrapper(
      scale: scale,
      child: this,
    );
  }
}

/// Widget interne pour l'entrance animation
class _AnimatedEntranceWrapper extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const _AnimatedEntranceWrapper({
    required this.child,
    required this.delay,
    required this.duration,
  });

  @override
  State<_AnimatedEntranceWrapper> createState() =>
      _AnimatedEntranceWrapperState();
}

class _AnimatedEntranceWrapperState extends State<_AnimatedEntranceWrapper>
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
      curve: AppAnimations.standard,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.emphasized,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Widget interne pour l'hover scale
class _HoverScaleWrapper extends StatefulWidget {
  final Widget child;
  final double scale;

  const _HoverScaleWrapper({
    required this.child,
    required this.scale,
  });

  @override
  State<_HoverScaleWrapper> createState() => _HoverScaleWrapperState();
}

class _HoverScaleWrapperState extends State<_HoverScaleWrapper> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? widget.scale : 1.0,
        duration: AppAnimations.fast,
        curve: AppAnimations.elastic,
        child: widget.child,
      ),
    );
  }
}
