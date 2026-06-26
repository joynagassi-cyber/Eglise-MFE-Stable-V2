// lib/core/router/analytics_navigator_observer.dart
//
// Observe les changements de routes pour le logging et les analytics.
// Permet de suivre le parcours utilisateur et détecter les tunnels de conversion.

import 'package:flutter/material.dart';
import '../logging/app_logger.dart';

class AnalyticsNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _logNavigation('PUSH', route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _logNavigation('POP', route);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    _logNavigation('REMOVE', route);
  }

  void _logNavigation(String event, Route route) {
    final routeName = route.settings.name ?? 'unnamed_route';
    AppLogger.i(
      'Navigation Event: $event -> $routeName',
      'ROUTER_OBSERVER',
    );
    
    // Ici, on pourrait ajouter l'intégration avec Firebase Analytics ou Sentry
    // FirebaseAnalytics.instance.logEvent(name: 'screen_view', parameters: {
    //   'screen_name': routeName,
    // });
  }
}