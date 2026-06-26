import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/logging/app_logger.dart';

/// Service de rafraîchissement proactif des tokens JWT.
///
/// - Rafraîchit le token 5 minutes avant expiration.
/// - Échec silencieux : ne déconnecte jamais l'utilisateur.
/// - Timer arrêté automatiquement au logout/dispose.
class TokenRefreshService {
  Timer? _timer;
  final SupabaseClient _supabase;

  TokenRefreshService(this._supabase);

  /// Démarre la surveillance du token. Appelé quand on atteint AuthAuthenticated.
  void start(DateTime tokenExpiresAt) {
    stop(); // Annuler tout timer précédent

    final now = DateTime.now();
    final expiresIn = tokenExpiresAt.difference(now);

    // Rafraîchir 5 minutes avant expiration
    final refreshIn = expiresIn - const Duration(minutes: 5);

    if (refreshIn.isNegative) {
      // Token déjà quasi-expiré → refresh immédiat
      AppLogger.d('Token near expiry — refreshing now', 'TOKEN_REFRESH');
      _doRefresh();
    } else {
      AppLogger.d('Token refresh scheduled in ${refreshIn.inSeconds}s',
          'TOKEN_REFRESH');
      _timer = Timer(refreshIn, _doRefresh);
    }
  }

  /// Arrête le timer (logout, dispose).
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _doRefresh() async {
    try {
      AppLogger.d('Proactive token refresh starting...', 'TOKEN_REFRESH');
      final response = await _supabase.auth.refreshSession();
      final newSession = response.session;

      if (newSession != null) {
        // Re-schedule pour le prochain cycle
        final newExpiry = DateTime.fromMillisecondsSinceEpoch(
          (newSession.expiresAt ?? 0) * 1000,
        );
        AppLogger.i('Token refreshed successfully, next expiry: $newExpiry',
            'TOKEN_REFRESH');
        start(newExpiry); // Relance le timer pour le prochain refresh
      } else {
        AppLogger.w(
            'Refresh returned null session — silent failure', 'TOKEN_REFRESH');
      }
    } catch (e) {
      // R6: Échec silencieux — ne pas déconnecter l'utilisateur
      AppLogger.e('Token refresh failed (silent)', 'TOKEN_REFRESH', e);
    }
  }
}
