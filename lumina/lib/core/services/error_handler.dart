// lib/core/services/error_handler.dart
// AMÉLIORATION: Traduction unifiée des erreurs et utilitaire de notification.

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppErrorHandler {
  /// Traduit un objet d'erreur complexe (Supabase, Auth, etc.) en message compréhensible.
  static String translate(dynamic error) {
    if (error is AuthException) {
      if (error.message.contains('Invalid login credentials')) {
        return 'Identifiants invalides. Veuillez vérifier votre email et mot de passe.';
      }
      if (error.message.contains('Email not confirmed')) {
        return 'Votre compte n\'est pas encore activé. Vérifiez vos emails.';
      }
      return 'Erreur d\'authentification: ${error.message}';
    }

    if (error is PostgrestException) {
      if (error.code == '23505') return 'Cet enregistrement existe déjà.';
      return 'Erreur de base de données (${error.code})';
    }

    if (error.toString().contains('SocketException') ||
        error.toString().contains('connectivity')) {
      return 'Pas de connexion internet. L\'action sera tentée ultérieurement.';
    }

    return 'Une erreur imprévue est survenue: ${error.toString()}';
  }

  /// Affiche une Snackbar stylisée avec le message d'erreur traduit.
  static void showSnackBar(BuildContext context, dynamic error,
      {bool isError = true}) {
    final message = translate(error);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red.shade800 : Colors.green.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
