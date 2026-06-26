import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/logging/app_logger.dart';

part 'supabase_service.g.dart';

/// Service Supabase pour la gestion de l'authentification et du client
///
/// Service Supabase pour la gestion de l'authentification et du client
@Riverpod(keepAlive: true)
class SupabaseService extends _$SupabaseService {
  @override
  FutureOr<SupabaseClient> build() async {
    // Écouter les changements d'état d'authentification
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      AppLogger.d('Auth state changed: $event', 'SUPA_SERVICE');

      switch (event) {
        case AuthChangeEvent.signedIn:
          AppLogger.i(
              'User signed in: ${session?.user.email ?? ''}', 'SUPA_SERVICE');
          break;
        case AuthChangeEvent.signedOut:
          AppLogger.i('User signed out', 'SUPA_SERVICE');
          break;
        case AuthChangeEvent.userUpdated:
          AppLogger.i(
              'User updated: ${session?.user.email ?? ''}', 'SUPA_SERVICE');
          break;
        case AuthChangeEvent.tokenRefreshed:
          AppLogger.d('Token refreshed', 'SUPA_SERVICE');
          break;
        default:
          break;
      }
    });

    return Supabase.instance.client;
  }

  /// Récupère le client Supabase (synchrone après initialisation)
  SupabaseClient get client => Supabase.instance.client;

  /// Récupère l'utilisateur courant
  User? get currentUser => client.auth.currentUser;

  /// Vérifie si l'utilisateur est authentifié
  bool get isAuthenticated => currentUser != null;

  /// Connexion avec email et mot de passe
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      AppLogger.w('Login failed for $email: ${e.message}', 'SUPA_SERVICE');
      rethrow; // Laisser le repository gérer la traduction via AuthException
    } catch (e) {
      AppLogger.e('Unexpected login error for $email', 'SUPA_SERVICE', e);
      throw Exception('Erreur inattendue lors de la connexion');
    }
  }

  /// Inscription avec email et mot de passe
  Future<AuthResponse> register(String email, String password,
      {Map<String, dynamic>? userData}) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: userData,
      );
      return response;
    } on AuthException catch (e) {
      AppLogger.w(
          'Registration failed for $email: ${e.message}', 'SUPA_SERVICE');
      rethrow;
    } catch (e) {
      AppLogger.e(
          'Unexpected registration error for $email', 'SUPA_SERVICE', e);
      throw Exception('Erreur inattendue lors de l\'inscription');
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    await client.auth.signOut();
  }

  /// Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  /// Mise à jour du mot de passe
  Future<void> updatePassword(String newPassword) async {
    await client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  /// Récupération de la session courante
  Session? get currentSession => client.auth.currentSession;

  /// Rafraîchissement de la session
  Future<AuthResponse> refreshSession() async {
    return await client.auth.refreshSession();
  }

  /// Exécute une requête Supabase avec une logique de réessai exponentiel.
  Future<T> safeCall<T>(Future<T> Function() call,
      {int maxAttempts = 3}) async {
    int attempts = 0;
    while (attempts < maxAttempts) {
      try {
        return await call();
      } catch (e) {
        attempts++;
        final isNetworkError = e.toString().contains('SocketException') ||
            e.toString().contains('ClientException');

        if (!isNetworkError || attempts >= maxAttempts) {
          rethrow;
        }

        final delay = Duration(seconds: attempts * 2);
        AppLogger.w(
            'Network error, retrying in ${delay.inSeconds}s (Attempt $attempts/$maxAttempts)',
            'SUPA_SERVICE');
        await Future.delayed(delay);
      }
    }
    throw Exception('Échec après $maxAttempts tentatives');
  }
}
