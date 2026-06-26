// lib/core/providers/navigation_badges_provider.dart
// Provider pour les badges de navigation

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Types de badges de navigation
enum NavigationBadgeType {
  membres,
  sacrements,
  events,
  annonces,
  messages,
  finance,
}

/// État des badges de navigation
class NavigationBadgesNotifier
    extends StateNotifier<Map<NavigationBadgeType, int>> {
  NavigationBadgesNotifier() : super({});

  /// Incrémente le compteur d'un badge
  void increment(NavigationBadgeType type, [int amount = 1]) {
    state = {
      ...state,
      type: (state[type] ?? 0) + amount,
    };
  }

  /// Réinitialise le compteur d'un badge
  void reset(NavigationBadgeType type) {
    state = {
      ...state,
      type: 0,
    };
  }

  /// Réinitialise tous les badges
  void resetAll() {
    state = {};
  }

  /// Récupère le compteur d'un badge
  int getCount(NavigationBadgeType type) {
    return state[type] ?? 0;
  }

  /// Vérifie si un badge a des notifications
  bool hasNotifications(NavigationBadgeType type) {
    return (state[type] ?? 0) > 0;
  }

  /// Mappe le type de badge vers la route correspondante
  String getRouteForType(NavigationBadgeType type) {
    switch (type) {
      case NavigationBadgeType.membres:
        return '/communaute';
      case NavigationBadgeType.sacrements:
        return '/vie-spirituelle/sacrements';
      case NavigationBadgeType.events:
        return '/vie-spirituelle/events';
      case NavigationBadgeType.annonces:
        return '/communication/annonces';
      case NavigationBadgeType.messages:
        return '/communication/messaging';
      case NavigationBadgeType.finance:
        return '/ministere/finance';
    }
  }

  /// Mappe la route vers le type de badge correspondant
  NavigationBadgeType? getTypeForRoute(String route) {
    if (route.startsWith('/communaute')) {
      return NavigationBadgeType.membres;
    } else if (route.startsWith('/vie-spirituelle/sacrements')) {
      return NavigationBadgeType.sacrements;
    } else if (route.startsWith('/vie-spirituelle/events')) {
      return NavigationBadgeType.events;
    } else if (route.startsWith('/communication/annonces')) {
      return NavigationBadgeType.annonces;
    } else if (route.startsWith('/communication/messaging')) {
      return NavigationBadgeType.messages;
    } else if (route.startsWith('/ministere/finance')) {
      return NavigationBadgeType.finance;
    }
    return null;
  }
}

final navigationBadgesProvider = StateNotifierProvider<NavigationBadgesNotifier,
    Map<NavigationBadgeType, int>>(
  (ref) => NavigationBadgesNotifier(),
);
