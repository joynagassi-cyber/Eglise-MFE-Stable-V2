import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/auth/domain/entities/auth_state.dart' as app_auth;
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/router/guards/onboarding_guard.dart';
import 'package:lumina/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:lumina/features/onboarding/domain/entities/onboarding_step.dart';
import 'package:lumina/features/profile/domain/entities/profile.dart';

enum RouteStatus { loading, unauthenticated, authenticated, onboarding }

abstract class RedirectPolicy {
  String? redirect(BuildContext context, GoRouterState state, RouteStatus status, String? initialRoute, OnboardingProgress? progress);
  String? redirectWithLocation(String location, RouteStatus status, String? initialRoute, OnboardingProgress? progress);
  RedirectPolicy? next;

  String? handle(BuildContext context, GoRouterState state, RouteStatus status, String? initialRoute, OnboardingProgress? progress) {
    final result = redirect(context, state, status, initialRoute, progress);
    if (result != null) return result;
    return next?.handle(context, state, status, initialRoute, progress);
  }

  String? handleWithLocation(String location, RouteStatus status, String? initialRoute, OnboardingProgress? progress) {
    final result = redirectWithLocation(location, status, initialRoute, progress);
    if (result != null) return result;
    return next?.handleWithLocation(location, status, initialRoute, progress);
  }
}

class LoadingRedirectPolicy extends RedirectPolicy {
  @override
  String? redirect(BuildContext context, GoRouterState state, RouteStatus status, String? initialRoute, OnboardingProgress? progress) {
    if (status == RouteStatus.loading) {
      return state.uri.path == AppRoutes.splash ? null : AppRoutes.splash;
    }
    return null;
  }

  @override
  String? redirectWithLocation(String location, RouteStatus status, String? initialRoute, OnboardingProgress? progress) {
    if (status == RouteStatus.loading) {
      return location == AppRoutes.splash ? null : AppRoutes.splash;
    }
    return null;
  }
}

class UnauthenticatedRedirectPolicy extends RedirectPolicy {
  /// Routes accessibles sans authentification.
  /// NOTE: Le splash (`/`) n'est PAS ici — il est géré par LoadingRedirectPolicy
  /// pendant le chargement. Une fois l'auth résolue (unauthenticated),
  /// l'utilisateur doit être redirigé VERS authHome, pas rester sur le splash.
  static const List<String> publicRoutes = [
    AppRoutes.authHome,
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.forgotPassword,
    '/login-callback',
  ];

  @override
  String? redirect(BuildContext context, GoRouterState state, RouteStatus status, String? initialRoute, OnboardingProgress? progress) {
    if (status == RouteStatus.unauthenticated) {
      final location = state.uri.path;
      // Si on est encore sur le splash, rediriger vers authHome
      if (location == AppRoutes.splash) {
        return AppRoutes.authHome;
      }
      if (publicRoutes.any((route) => isPublicRoute(location, route))) {
        return null;
      }
      return AppRoutes.authHome;
    }
    return null;
  }

  @override
  String? redirectWithLocation(String location, RouteStatus status, String? initialRoute, OnboardingProgress? progress) {
    if (status == RouteStatus.unauthenticated) {
      // Si on est encore sur le splash, rediriger vers authHome
      if (location == AppRoutes.splash) {
        return AppRoutes.authHome;
      }
      if (publicRoutes.any((route) => isPublicRoute(location, route))) {
        return null;
      }
      return AppRoutes.authHome;
    }
    return null;
  }

  static bool isPublicRoute(String location, String route) {
    if (location == route) return true;
    if (route == '/' || route.isEmpty) return false;
    if (location.startsWith(route)) return true;
    return false;
  }
}

class OnboardingRedirectPolicy extends RedirectPolicy {
  @override
  String? redirect(BuildContext context, GoRouterState state, RouteStatus status, String? initialRoute, OnboardingProgress? progress) {
    if (status != RouteStatus.onboarding) return null;

    final currentProgress = progress ?? const OnboardingProgress(
        currentStep: OnboardingStep.roleSelection,
        history: <OnboardingStep>[],
      );

    return OnboardingGuard.redirect(
      progress: currentProgress,
      location: state.uri.path,
    );
  }

  @override
  String? redirectWithLocation(String location, RouteStatus status, String? initialRoute, OnboardingProgress? progress) {
    if (status != RouteStatus.onboarding) return null;

    final currentProgress = progress ?? const OnboardingProgress(
        currentStep: OnboardingStep.roleSelection,
        history: <OnboardingStep>[],
      );

    return OnboardingGuard.redirect(
      progress: currentProgress,
      location: location,
    );
  }
}

class AuthenticatedRedirectPolicy extends RedirectPolicy {
  @override
  String? redirect(BuildContext context, GoRouterState state, RouteStatus status, String? initialRoute, OnboardingProgress? progress) {
    if (status == RouteStatus.authenticated) {
      final location = state.uri.path;
      return _redirectAuthenticated(location, initialRoute);
    }
    return null;
  }

  @override
  String? redirectWithLocation(String location, RouteStatus status, String? initialRoute, OnboardingProgress? progress) {
    if (status == RouteStatus.authenticated) {
      return _redirectAuthenticated(location, initialRoute);
    }
    return null;
  }

  String? _redirectAuthenticated(String location, String? initialRoute) {
    final isPublic = UnauthenticatedRedirectPolicy.publicRoutes.any((route) => UnauthenticatedRedirectPolicy.isPublicRoute(location, route));
    final isOnboarding = location.startsWith(AppRoutes.onboarding) || location == AppRoutes.welcomeTour;
    
    if (isPublic || location == AppRoutes.splash || isOnboarding) {
      final target = (initialRoute != null && initialRoute.isNotEmpty)
          ? initialRoute
          : AppRoutes.dashboard;
      return location == target ? null : target;
    }
    return null;
  }
}

class RouterPolicy {
  static RouteStatus resolveStatus(
    AsyncValue<app_auth.AuthState> auth,
    AsyncValue<Profile?> profileAsync,
  ) {
    if (auth is AsyncLoading) {
      return RouteStatus.loading;
    }

    final authState = auth.valueOrNull;

    if (authState == null || 
        authState is app_auth.AuthUnauthenticated || 
        authState is app_auth.AuthError) {
      return RouteStatus.unauthenticated;
    }

    if (authState is app_auth.AuthOffline) {
      return authState.cachedSession != null ? RouteStatus.authenticated : RouteStatus.unauthenticated;
    }

    // ⚠️ FIX: Si l'utilisateur est déjà authentifié, ne PAS le redescendre en loading
    // à cause du profil qui charge encore. Le profil est un enrichissement, pas un prérequis
    // pour l'accès au dashboard. Sans ce guard, après completeOnboarding() le user
    // voit un flash du splash screen pendant que profileAsync se résout.
    if (authState is app_auth.AuthAuthenticated) {
      return RouteStatus.authenticated;
    }

    if (authState is app_auth.AuthOnboardingRequired || authState.needsOnboarding) {
      return RouteStatus.onboarding;
    }

    // Si on arrive ici, auth est résolu mais ni onboardé ni authentifié.
    // On attend le profil seulement pour les cas ambigüs (needsOnboarding
    // peut aussi venir du profil, pas seulement de la session).

    final profile = profileAsync.valueOrNull;
    if (profile != null && profile.needsOnboarding) {
      return RouteStatus.onboarding;
    }

    return RouteStatus.authenticated;
  }

  static final _loading = LoadingRedirectPolicy();
  static final _unauth = UnauthenticatedRedirectPolicy();
  static final _onboarding = OnboardingRedirectPolicy();
  static final _auth = AuthenticatedRedirectPolicy();

  static bool _linked = false;

  static void _ensureLinked() {
    if (_linked) return;
    _loading.next = _unauth;
    _unauth.next = _onboarding;
    _onboarding.next = _auth;
    _linked = true;
  }

  static String? redirect({
    required BuildContext context,
    required GoRouterState state,
    required RouteStatus status,
    String? initialRoute,
    OnboardingProgress? progress,
  }) {
    _ensureLinked();
    final result = _loading.handle(context, state, status, initialRoute, progress);
    debugPrint('[ROUTER_POLICY] status=$status location=${state.uri.path} → ${result ?? "stay"}');
    return result;
  }

  static String? redirectWithLocation({
    required RouteStatus status,
    required String location,
    String? initialRoute,
    OnboardingProgress? progress,
  }) {
    _ensureLinked();
    return _loading.handleWithLocation(location, status, initialRoute, progress);
  }
}
