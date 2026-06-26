import 'package:flutter/foundation.dart';

/// Service de limitation de débit (Rate Limiting)
/// Permet de contrôler la fréquence des actions utilisateurs ou des appels API.
class RateLimiter {
  static final Map<String, DateTime> _lastActions = {};

  /// Vérifie si une action peut être exécutée selon un délai minimum
  /// [key] : Identifiant unique de l'action
  /// [interval] : Délai minimum entre deux exécutions
  static bool canExecute(String key, Duration interval) {
    final now = DateTime.now();
    final lastExecution = _lastActions[key];

    if (lastExecution == null || now.difference(lastExecution) >= interval) {
      _lastActions[key] = now;
      return true;
    }

    return false;
  }

  /// Exécute une action seulement si le délai est respecté (Throttling)
  static void throttle(String key, Duration interval, VoidCallback action) {
    if (canExecute(key, interval)) {
      action();
    }
  }

  /// Nettoie les anciennes entrées
  static void clear() {
    _lastActions.clear();
  }
}
