// lib/core/presentation/screens/splash_screen.dart
//
// Splash Screen Cinématique — Ministère le Feu de l'Évangile de Jésus-Christ
// Motion Graphics : logo scale-in, cross-fade, staggered text reveal, fire pulse,
// shimmer loader, exit animation déclenchée par le routeur.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/router/router_policy.dart';
import 'package:lumina/core/router/route_status_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/features/onboarding/presentation/providers/onboarding_progress_provider.dart';
import 'package:lumina/features/onboarding/domain/entities/onboarding_step.dart';
import 'package:lumina/core/logging/app_logger.dart';

class LuminaSplashScreen extends ConsumerStatefulWidget {
  const LuminaSplashScreen({super.key});

  @override
  ConsumerState<LuminaSplashScreen> createState() => _LuminaSplashScreenState();
}

class _LuminaSplashScreenState extends ConsumerState<LuminaSplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _masterController;
  late final AnimationController _pulseController;
  Timer? _timeoutTimer;
  bool _hasNavigated = false;

  // Phases d'animation (ms) — gardées pour lisibilité du code
  static const _churchNameIn = 400;
  static const _loaderIn = 1000;

  @override
  void initState() {
    super.initState();

    // Master : timeline globale (2200ms total)
    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..forward();

    // Pulse continu pour le glow du logo (loop)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    // Safety timeout
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      if (!_hasNavigated && mounted) {
        AppLogger.w('Splash timeout — forcing navigation to authHome', 'SPLASH');
        _navigateTo(AppRoutes.authHome);
      }
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _masterController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _navigateTo(String route) {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    _timeoutTimer?.cancel();
    _masterController.reverse().then((_) {
      if (mounted) context.go(route);
    });
  }

  // Helpers d'animation (staggered reveal)
  Animation<double> _fadeIn(double begin, double end) =>
      CurvedAnimation(parent: _masterController, curve: Interval(begin, end, curve: Curves.easeOut));

  Animation<Offset> _slideUp(double begin, double end) =>
      Tween<Offset>(begin: const Offset(0, 20), end: Offset.zero).animate(
        CurvedAnimation(parent: _masterController, curve: Interval(begin, end, curve: Curves.easeOutCubic)),
      );

  @override
  Widget build(BuildContext context) {
    // Écoute le route status pour naviguer automatiquement
    ref.listen(routeStatusProvider, (previous, next) {
      if (_hasNavigated) return;

      AppLogger.d('RouteStatus changed: $previous → $next', 'SPLASH');

      switch (next) {
        case RouteStatus.unauthenticated:
          Future.delayed(const Duration(milliseconds: 600), () {
            if (!_hasNavigated && mounted) _navigateTo(AppRoutes.authHome);
          });
          break;
        case RouteStatus.authenticated:
          final initialRoute = ref.read(currentInitialRouteProvider);
          Future.delayed(const Duration(milliseconds: 600), () {
            if (!_hasNavigated && mounted) {
              _navigateTo(initialRoute.isNotEmpty ? initialRoute : AppRoutes.dashboard);
            }
          });
          break;
        case RouteStatus.onboarding:
          final progress = ref.read(onboardingProgressNotifierProvider);
          final step = progress.currentStep;
          final route = switch (step) {
            OnboardingStep.roleSelection => AppRoutes.onboarding,
            OnboardingStep.identitySetup => AppRoutes.onboardingAdminCode,
            OnboardingStep.completed => AppRoutes.dashboard,
          };
          Future.delayed(const Duration(milliseconds: 600), () {
            if (!_hasNavigated && mounted) _navigateTo(route);
          });
          break;
        case RouteStatus.loading:
          // Stay on splash
          break;
      }
    });

    return Scaffold(
      body: AnimatedBuilder(
        animation: _masterController,
        builder: (context, child) {
          final opacity = _masterController.value;
          return Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: child,
          );
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.3, -0.2),
              radius: 1.4,
              colors: [
                Color(0xFF1A0500), // centre chaud
                Color(0xFF0D0200), // milieu
                Color(0xFF000000), // bord noir
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 4),

                // ─── LOGO avec glow pulsant ───────────────────────
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final glowAlpha = 0.35 + 0.15 * _pulseController.value;
                    return Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B00).withValues(alpha: glowAlpha),
                            blurRadius: 50,
                            spreadRadius: 12,
                          ),
                          BoxShadow(
                            color: const Color(0xFFFFD700).withValues(alpha: glowAlpha * 0.5),
                            blurRadius: 70,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icon/church_logo.png',
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ).animate(controller: _masterController)
                  .fadeIn(duration: const Duration(milliseconds: 500), curve: Curves.easeOut)
                  .scale(begin: const Offset(0.75, 0.75), duration: const Duration(milliseconds: 700), curve: Curves.elasticOut),

                const SizedBox(height: 32),

                // ─── NOM COMPLET ÉGLISE — staggered reveal ──────
                FadeTransition(
                  opacity: _fadeIn(_churchNameIn / 2200, (_churchNameIn + 400) / 2200),
                  child: SlideTransition(
                    position: _slideUp(_churchNameIn / 2200, (_churchNameIn + 400) / 2200),
                    child: const Text(
                      'Ministère le Feu',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: _fadeIn((_churchNameIn + 120) / 2200, (_churchNameIn + 520) / 2200),
                  child: SlideTransition(
                    position: _slideUp((_churchNameIn + 120) / 2200, (_churchNameIn + 520) / 2200),
                    child: const Text(
                      'de l\'Évangile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFD700),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: _fadeIn((_churchNameIn + 220) / 2200, (_churchNameIn + 620) / 2200),
                  child: SlideTransition(
                    position: _slideUp((_churchNameIn + 220) / 2200, (_churchNameIn + 620) / 2200),
                    child: const Text(
                      'de Jésus-Christ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // ─── MARQUEUR + LOADER ───────────────────────────
                FadeTransition(
                  opacity: _fadeIn(_loaderIn / 2200, (_loaderIn + 300) / 2200),
                  child: Column(
                    children: [
                      Text(
                        'MFE-JC',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 3.0,
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Loader premium : barre horizontale avec gradient brand
                      SizedBox(
                        width: 120,
                        height: 2.5,
                        child: ShimmerBox(
                          width: 120,
                          height: 2.5,
                          borderRadius: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
