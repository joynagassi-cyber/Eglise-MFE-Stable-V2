import 'package:flutter/material.dart';
import 'performance_monitor.dart';

class PerformanceNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _recordTransition(route, 'push');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _recordTransition(newRoute, 'replace');
    }
  }

  void _recordTransition(Route<dynamic> route, String type) {
    final name = route.settings.name ?? route.runtimeType.toString();

    // On commence une trace pour le rendu du prochain frame
    PerformanceMonitor().startTrace('nav_$name');

    // On s'assure d'arrêter la trace au prochain frame rendu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PerformanceMonitor().stopTrace('nav_$name', metadata: {
        'route': name,
        'type': type,
      });
    });
  }
}
