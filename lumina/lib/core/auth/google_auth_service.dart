import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/logging/app_logger.dart';

class GoogleAuthService {
  final SupabaseClient _supabase;
  final GoogleSignIn _googleSignIn;

  GoogleAuthService(this._supabase)
      : _googleSignIn = GoogleSignIn.instance;

  Future<AuthResponse?> signInWithGoogle() async {
    try {
      // 1. Déclencher le flux natif Google
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // 2. Récupérer les données d'authentification
      final googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      final GoogleSignInClientAuthorization clientAuth = await googleUser.authorizationClient.authorizeScopes(<String>['email', 'profile']);
      final String accessToken = clientAuth.accessToken;

      if (idToken == null) {
        throw Exception('ID Token manquant');
      }

      // 3. Envoyer le token à Supabase
      return await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      AppLogger.e('Erreur lors de la connexion Google', 'GOOGLE_AUTH', e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _supabase.auth.signOut();
  }
}
