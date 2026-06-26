// lib/features/auth/domain/repositories/i_google_auth_service.dart

import '../models/auth_result.dart';

/// Interface pour le service d'authentification Google
/// Permet de séparer la logique d'authentification Google native
/// et de garantir la testabilité complète.
abstract class IGoogleAuthService {
  /// Démarre le flux d'authentification Google natif
  /// 
  /// Returns:
  ///   - AuthResult avec tokens valides si succès
  ///   - GoogleAuthCancelledException si utilisateur annule
  ///   - GoogleAuthTokenException si tokens invalides/absents
  ///   - GoogleAuthException si configuration manquante
  Future<AuthResult> signInWithGoogle();

  /// Déconnecte l'utilisateur du compte Google localement
  Future<void> signOut();

  /// Vérifie si l'utilisateur a déjà une session Google active localement
  Future<bool> isSignedIn();

  /// Valide la configuration Google au démarrage
  /// 
  /// Throws:
  ///   - GoogleAuthException si GOOGLE_WEB_CLIENT_ID manquant
  void validateConfiguration();
}