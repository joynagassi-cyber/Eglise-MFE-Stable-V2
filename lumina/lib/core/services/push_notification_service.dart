// ============================================================
// FICHIER : lib/core/services/push_notification_service.dart
// DESCRIPTION : Service de notifications push utilisant FCM.
//               Persiste le token FCM dans Supabase pour permettre
//               les notifications push serveur (Edge Functions).
// ============================================================

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../logging/app_logger.dart';

final pushNotificationServiceProvider =
    Provider<PushNotificationService>((ref) {
  return PushNotificationService();
});

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  SupabaseClient get _supabase => Supabase.instance.client;

  Future<void> initialize() async {
    try {
      // 1. Demander les permissions (nécessaire pour iOS et Android 13+)
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        AppLogger.i('Permissions de notifications accordées', 'PUSH');
      } else {
        AppLogger.w('Permissions de notifications refusées', 'PUSH');
        return;
      }

      // 2. Récupérer et persister le token FCM
      final token = await getToken();
      if (token != null) {
        await _saveTokenToSupabase(token);
      }

      // 3. Écouter les refresh de token (rotation automatique par FCM)
      _fcm.onTokenRefresh.listen((newToken) async {
        AppLogger.i('FCM Token refreshed', 'PUSH');
        await _saveTokenToSupabase(newToken);
      });

      // 4. Configurer les handlers de messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // 5. Vérifier s'il y a un message initial (app ouverte via notification)
      final initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }
    } catch (e) {
      AppLogger.e(
          'Erreur lors de l\'initialisation des notifications', 'PUSH', e);
    }
  }

  Future<String?> getToken() async {
    try {
      return await _fcm.getToken();
    } catch (e) {
      AppLogger.e('Impossible de récupérer le token FCM', 'PUSH', e);
      return null;
    }
  }

  /// Persiste le token FCM dans la table `fcm_tokens` de Supabase.
  ///
  /// Utilise un upsert sur (user_id, token) pour éviter les doublons
  /// et met à jour le timestamp pour traquer les tokens actifs.
  Future<void> _saveTokenToSupabase(String token) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      AppLogger.w('Cannot save FCM token: no authenticated user', 'PUSH');
      return;
    }

    try {
      // Récupérer le church_id du profil utilisateur
      final profileResponse = await _supabase
          .from('profiles')
          .select('church_id')
          .eq('id', user.id)
          .maybeSingle();

      final churchId = profileResponse?['church_id'] as String?;

      await _supabase.from('fcm_tokens').upsert(
        {
          'user_id': user.id,
          'token': token,
          'church_id': churchId,
          'platform': Platform.isIOS ? 'ios' : 'android',
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
        onConflict: 'user_id,token',
      );

      AppLogger.i('FCM token saved to Supabase', 'PUSH');
    } catch (e) {
      AppLogger.w('Failed to save FCM token to Supabase: $e', 'PUSH');
    }
  }

  /// Supprime le token FCM actuel de Supabase (à appeler au logout).
  Future<void> removeCurrentToken() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final token = await getToken();
      if (token != null) {
        await _supabase
            .from('fcm_tokens')
            .delete()
            .eq('user_id', user.id)
            .eq('token', token);
        AppLogger.i('FCM token removed from Supabase', 'PUSH');
      }
    } catch (e) {
      AppLogger.w('Failed to remove FCM token: $e', 'PUSH');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    AppLogger.i(
      'Message reçu en premier plan: ${message.notification?.title}',
      'PUSH',
    );
    // NOTE: Les notifications foreground sont gérées par flutter_local_notifications
    // et le in-app banner system défini dans la couche présentation.
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    AppLogger.i(
      'Application ouverte via notification: ${message.notification?.title}',
      'PUSH',
    );
    // NOTE: La navigation deep-link est gérée par GoRouter.
    // Les données de la notification sont dans message.data
  }

  void dispose() {
    // Cleanup si nécessaire
  }
}
