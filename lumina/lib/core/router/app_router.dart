// lib/core/router/app_router.dart

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'app_routes.dart';
import 'router_policy.dart';
import 'routes_provider.dart';
import 'router_refresh_listenable.dart';
import 'route_status_provider.dart';
import 'analytics_navigator_observer.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/not_found_screen.dart';
import '../providers/auth_provider.dart';
import 'package:lumina/features/onboarding/presentation/providers/onboarding_progress_provider.dart';
import 'navigator_keys.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  final refreshListenable = RouterRefreshListenable(ref);
  final featureRoutes = ref.watch(allFeatureRoutesProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshListenable,
    debugLogDiagnostics: kDebugMode,
    observers: [AnalyticsNavigatorObserver()],

    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const LuminaSplashScreen(),
      ),

      // All feature routes (décentralisées par feature)
      ...featureRoutes,
    ],

    redirect: (context, state) {
      final status = ref.read(routeStatusProvider);
      final onboardingProgress = ref.read(onboardingProgressNotifierProvider);
      final location = state.uri.path;

      final result = RouterPolicy.redirect(
        context: context,
        state: state,
        status: status,
        initialRoute: ref.read(currentInitialRouteProvider),
        progress: onboardingProgress,
      );

      // Debug logging for redirect chain
      debugPrint('[ROUTER_REDIRECT] location=$location status=$status → ${result ?? "stay"}');

      return result;
    },

    errorBuilder: (context, state) => NotFoundScreen(
      uri: state.uri.toString(),
    ),
  );
}
