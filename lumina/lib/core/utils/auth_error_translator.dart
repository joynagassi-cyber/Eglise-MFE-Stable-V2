import 'package:supabase_flutter/supabase_flutter.dart';

/// Utilitaire pour traduire les erreurs Supabase Auth en messages conviviaux.
/// Pattern inspiré du boilerplate prodevcom pour une gestion centralisée.
class AuthErrorTranslator {
  AuthErrorTranslator._();

  static String translate(dynamic error) {
    if (error is AuthException) {
      final message = error.message;

      // Erreurs courantes
      if (message.contains('Invalid login credentials')) {
        return 'Email ou mot de passe incorrect.';
      }
      if (message.contains('Email not confirmed')) {
        return 'Votre compte n\'est pas encore confirmé. Vérifiez vos emails.';
      }
      if (message.contains('User already registered')) {
        return 'Cet email est déjà utilisé par un autre compte.';
      }
      if (message.contains('Password is too short')) {
        return 'Le mot de passe doit contenir au moins 6 caractères.';
      }
      if (message.contains('rate limit')) {
        return 'Trop de tentatives. Veuillez réessayer dans quelques minutes.';
      }
      if (message.contains('Invalid refresh token')) {
        return 'Votre session a expiré. Veuillez vous reconnecter.';
      }
      if (message.contains('Flow not allowed')) {
        return 'Cette méthode de connexion n\'est pas autorisée ou configurée.';
      }
      if (message.contains('Signup is disabled')) {
        return 'Les inscriptions sont actuellement désactivées.';
      }
      if (message.contains('Email link is invalid')) {
        return 'Le lien magique est invalide ou a expiré.';
      }

      return message; // Fallback sur le message original si non traduit
    }

    if (error is PostgrestException) {
      return 'Erreur de base de données (${error.code}) : ${error.message}';
    }

    return 'Une erreur inattendue est survenue. Veuillez réessayer.';
  }
}
