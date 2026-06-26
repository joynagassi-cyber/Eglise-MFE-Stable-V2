// lib/core/utils/account_existence_helper.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class AccountExistenceHelper {
  final SupabaseClient _supabase;

  AccountExistenceHelper(this._supabase);

  /// Vérifie si un email existe déjà dans la base
  Future<AccountStatus> checkEmail(String email) async {
    try {
      // Vérifier dans auth.users via RPC
      final result = await _supabase
          .rpc('check_email_exists', params: {'email_to_check': email});

      if (result == true) {
        return AccountStatus.exists;
      }
      return AccountStatus.available;
    } catch (e) {
      // En cas d'erreur, laisser Supabase gérer
      return AccountStatus.unknown;
    }
  }

  /// Message user-friendly selon le statut
  static String getMessage(AccountStatus status) {
    switch (status) {
      case AccountStatus.exists:
        return 'Un compte existe déjà avec cet email.\n'
            'Utilisez "Se connecter" au lieu de "S\'inscrire".';
      case AccountStatus.available:
        return 'Email disponible';
      case AccountStatus.unknown:
        return 'Vérification impossible';
    }
  }
}

enum AccountStatus {
  exists,
  available,
  unknown,
}
