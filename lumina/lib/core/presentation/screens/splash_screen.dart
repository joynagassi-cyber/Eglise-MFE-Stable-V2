// lib/core/presentation/screens/splash_screen.dart
//
// Branded Splash Screen — Lumina
// Auto-navigating: listens to auth state and redirects when resolved.
// Falls back to auth-home after 5 seconds if redirect hasn't fired.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/router/router_policy.dart';
import 'package:lumina/core/router/route_status_provider.dart';
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
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scale;
  Timer? _timeoutTimer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();

    // Safety timeout: if auth doesn't resolve in 5 seconds, navigate anyway
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      if (!_hasNavigated && mounted) {
        AppLogger.w(
          'Splash timeout — forcing navigation to authHome',
          'SPLASH',
        );
        _navigateTo(AppRoutes.authHome);
      }
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _navigateTo(String route) {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    _timeoutTimer?.cancel();
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to route status and navigate when auth is resolved
    ref.listen(routeStatusProvider, (previous, next) {
      if (_hasNavigated) return;

      AppLogger.d(
        'RouteStatus changed: $previous → $next',
        'SPLASH',
      );

      switch (next) {
        case RouteStatus.unauthenticated:
          // Small delay to let the splash animation play
          Future.delayed(const Duration(milliseconds: 800), () {
            if (!_hasNavigated && mounted) {
              _navigateTo(AppRoutes.authHome);
            }
          });
          break;

        case RouteStatus.authenticated:
          final initialRoute = ref.read(currentInitialRouteProvider);
          Future.delayed(const Duration(milliseconds: 800), () {
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
          Future.delayed(const Duration(milliseconds: 800), () {
            if (!_hasNavigated && mounted) {
              _navigateTo(route);
            }
          });
          break;

        case RouteStatus.loading:
          // Still loading — keep showing splash
          break;
      }
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: context.colors.brandGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // Logo avec animation
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeIn.value,
                    child: Transform.scale(
                      scale: _scale.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.brandPrimary.withOpacity(0.3),
                        blurRadius: 12.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/icon/launcher_icon.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // App Name
              FadeTransition(
                opacity: _fadeIn,
                child: Text(
                  'LUMINA',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 6,
                    color: isDark ? context.colors.textOnBrand : context.colors.brandSecondary,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Subtitle
              FadeTransition(
                opacity: _fadeIn,
                child: Text(
                  'Système de Gestion d\'Église',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    color: context.colors.textSecondary,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Loading indicator
              FadeTransition(
                opacity: _fadeIn,
                child: const SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: LoadingState(
                    useShimmer: true,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Church name
              FadeTransition(
                opacity: _fadeIn,
                child: Text(
                  'MFE-JC',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                    color: context.colors.textTertiary.withOpacity(0.5),
                  ),
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
