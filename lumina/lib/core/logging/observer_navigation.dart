// lib/core/logging/observer_navigation.dart
// ============================================================================
// NAVIGATION OBSERVER
// Automatically logs screen views for analytics
// ============================================================================

import 'package:flutter/material.dart';
import 'app_logger.dart';
import 'analytics_events.dart';

/// Navigation observer that logs screen views automatically
class AnalyticsNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logScreenView(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _logScreenView(previousRoute, isPop: true);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _logScreenView(newRoute);
    }
  }

  void _logScreenView(Route<dynamic> route, {bool isPop = false}) {
    final screenName = _extractScreenName(route);
    if (screenName != null && screenName.isNotEmpty) {
      logger.logAction(
        NavEvents.screenView,
        targetType: 'screen',
        targetId: screenName,
        metadata: {
          'route_type': route.runtimeType.toString(),
          'is_pop': isPop,
        },
      );
    }
  }

  String? _extractScreenName(Route<dynamic> route) {
    // Try to get route name from settings
    if (route.settings.name != null && route.settings.name!.isNotEmpty) {
      return route.settings.name;
    }

    // Fallback to route type
    if (route is PageRoute) {
      return route.runtimeType.toString().replaceAll('MaterialPageRoute', '');
    }

    return null;
  }
}

/// Mixin for screens to easily log views
mixin ScreenAnalyticsMixin<T extends StatefulWidget> on State<T> {
  String get screenName;

  @override
  void initState() {
    super.initState();
    _logScreenView();
  }

  void _logScreenView() {
    logger.logScreenView(
      screenName,
      params: {
        'widget': T.toString(),
      },
    );
  }

  /// Log a user action on this screen
  void logScreenAction(String action, {Map<String, dynamic>? metadata}) {
    logger.logAction(
      action,
      targetType: 'screen',
      targetId: screenName,
      metadata: metadata,
    );
  }
}
