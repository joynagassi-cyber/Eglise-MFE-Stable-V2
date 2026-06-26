// lib/features/auth/data/datasources/supabase_auth_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthDataSource {
  final SupabaseClient _client;

  SupabaseAuthDataSource(this._client);

  /// Inscription sans confirmation d'email (auto-confirm)
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'first_name': firstName,
        'last_name': lastName,
      },
    );

    // Note: L'insertion dans la table 'profiles' se fera via un trigger Supabase
    // ou manuellement dans le repository si nécessaire.

    return response;
  }

  /// Connexion avec email et mot de passe
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Déconnexion
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Récupérer la session courante
  Session? get currentSession => _client.auth.currentSession;

  /// Récupérer l'utilisateur actuel
  User? getCurrentUser() => _client.auth.currentUser;

  /// Stream des changements d'état d'authentification
  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;
}