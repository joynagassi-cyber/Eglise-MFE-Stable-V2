// lib/features/auth/data/repositories/role_code_repository.dart
//
// DÉTERMINISTE — Zéro tolérance aux faux-négatifs.
//
// La table role_secret_codes a :
//   - code_hash    : bcrypt $2a$06$... (méthode sécurisée)
//   - raw_code     : texte en clair "PASTEUR-0081-2026" (nullable)
//   - normalized_code : sans tirets "PASTEUR00812026" (nullable)
//
// La vérification DOIT passer par la RPC redeem_secret_code (SECURITY DEFINER)
// car RLS bloque l'accès direct à la table.
// L'assignation DOIT passer par la RPC assign_user_role (SECURITY DEFINER)
// car RLS bloque les écritures dans user_roles/user_sessions/profiles.

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/logging/app_logger.dart';

class RoleCodeRepository {
  final SupabaseClient _supabase;

  RoleCodeRepository(this._supabase);

  /// Normalise le code : trim + UPPER (les codes en base sont en MAJUSCULES)
  String _normalize(String code) => code.trim().toUpperCase();

  // ──────────────────────────────────────────────────────────────────────────
  // VÉRIFICATION NON-DESTRUCTIVE : verifySecretCode
  //
  // Vérifie le code SANS le marquer comme utilisé.
  // Utile pour afficher une confirmation avant de consommer le code.
  // ──────────────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> verifySecretCode(String code) async {
    final normalized = _normalize(code);
    if (normalized.isEmpty) return null;

    try {
      AppLogger.d('verifySecretCode: "$normalized"', 'ROLE_CODE_REPO');

      final response = await _supabase.rpc(
        'verify_secret_code',
        params: {'p_code': normalized},
      ).timeout(const Duration(seconds: 8));

      if (response == null) {
        AppLogger.w('verify_secret_code retourne null — code "$normalized" invalide', 'ROLE_CODE_REPO');
        return null;
      }

      if (response is List && response.isNotEmpty) {
        final raw = response[0];
        final result = raw is Map ? Map<String, dynamic>.from(raw) : null;
        if (result == null) {
          AppLogger.w('verify_secret_code réponse inattendue (pas un Map): $raw', 'ROLE_CODE_REPO');
          return null;
        }
        AppLogger.i('Code vérifié (RPC) → rôle: ${result['role_code']}', 'ROLE_CODE_REPO');
        return result;
      }

      if (response is Map && response.isNotEmpty) {
        final result = Map<String, dynamic>.from(response);
        AppLogger.i('Code vérifié (RPC map) → rôle: ${result['role_code']}', 'ROLE_CODE_REPO');
        return result;
      }

      return null;
    } catch (e, st) {
      AppLogger.e('verifySecretCode erreur', 'ROLE_CODE_REPO', e, st);
      return null;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // MÉTHODE PRINCIPALE : redeemSecretCode
  //
  // Flux déterministe via RPC (SECURITY DEFINER, bypass RLS) :
  //   1. redeem_secret_code(p_code) — vérifie bcrypt → raw_code → normalized_code
  //   2. Retourne { role_code, raw_code, is_used } ou null
  // ──────────────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> redeemSecretCode(String code) async {
    final normalized = _normalize(code);
    if (normalized.isEmpty) return null;

    try {
      AppLogger.d('redeemSecretCode: "$normalized"', 'ROLE_CODE_REPO');

      // ── RPC redeem_secret_code (SECURITY DEFINER) ──
      // 3 niveaux de vérification côté serveur : bcrypt → raw_code → normalized_code
      final response = await _supabase.rpc(
        'redeem_secret_code',
        params: {'p_code': normalized},
      ).timeout(const Duration(seconds: 8));

      if (response == null) {
        AppLogger.w('redeem_secret_code retourne null — code "$normalized" invalide', 'ROLE_CODE_REPO');
        return null;
      }

      // La RPC retourne une List (table function)
      if (response is List && response.isNotEmpty) {
        // FIX: supabase_flutter peut retourner Map<String, Object?> au lieu de
        // Map<String, dynamic> pour les résultats TABLE FUNCTION à 1 ligne.
        // Utiliser Map.from() pour éviter le TypeError sur le cast direct.
        final raw = response[0];
        final result = raw is Map ? Map<String, dynamic>.from(raw) : null;
        if (result == null) {
          AppLogger.w('redeem_secret_code réponse inattendue (pas un Map): $raw', 'ROLE_CODE_REPO');
          return null;
        }
        AppLogger.i('Code valide (RPC) → rôle: ${result['role_code']}', 'ROLE_CODE_REPO');
        return result;
      }

      // Parfois Supabase retourne directement un Map
      if (response is Map && response.isNotEmpty) {
        final result = Map<String, dynamic>.from(response);
        AppLogger.i('Code valide (RPC map) → rôle: ${result['role_code']}', 'ROLE_CODE_REPO');
        return result;
      }

      AppLogger.w('Code "$normalized" — RPC réponse inattendue: $response', 'ROLE_CODE_REPO');
      return null;
    } catch (e, st) {
      AppLogger.e('redeemSecretCode erreur', 'ROLE_CODE_REPO', e, st);
      return null;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // ASSIGNATION DU RÔLE : RPC assign_user_role
  //
  // CECI est le chaînon manquant — sans ça, completeOnboarding() appelle
  // getUserContext() qui ne trouvera PAS de rôle (car user_roles est vide)
  // et retournera needs_onboarding=true → BLOCAGE !
  //
  // La RPC (SECURITY DEFINER) fait :
  //   1. Trouve role_id dans roles
  //   2. Insère dans user_roles (upsert)
  //   3. Met à jour user_sessions avec le rôle actif
  //   4. Met à jour profiles.needs_onboarding = false
  // ──────────────────────────────────────────────────────────────────────────

  Future<bool> assignRoleToUser({
    required String userId,
    required String roleCode,
    String? churchId,
  }) async {
    try {
      AppLogger.i('assignRoleToUser: userId=$userId, roleCode=$roleCode', 'ROLE_CODE_REPO');

      // Appeler la RPC assign_user_role (SECURITY DEFINER)
      final response = await _supabase.rpc(
        'assign_user_role',
        params: {
          'p_user_id': userId,
          'p_role_code': roleCode,
          'p_church_id': churchId,
        },
      ).timeout(const Duration(seconds: 8));

      // La RPC retourne TABLE(success BOOLEAN, message TEXT)
      bool success = false;
      if (response is List && response.isNotEmpty) {
        final raw = response[0];
        final result = raw is Map ? Map<String, dynamic>.from(raw) : null;
        if (result == null) {
          AppLogger.w('assign_user_role réponse inattendue (pas un Map): $raw', 'ROLE_CODE_REPO');
          return false;
        }
        success = result['success'] == true;
        final message = result['message'] as String? ?? '';
        if (success) {
          AppLogger.i('assign_user_role OK: $message', 'ROLE_CODE_REPO');
        } else {
          AppLogger.w('assign_user_role échoué: $message', 'ROLE_CODE_REPO');
        }
      } else if (response is Map<String, dynamic>) {
        success = response['success'] == true;
        final message = response['message'] as String? ?? '';
        AppLogger.i('assign_user_role response: success=$success, msg=$message', 'ROLE_CODE_REPO');
      } else {
        AppLogger.w('assign_user_role réponse inattendue: $response', 'ROLE_CODE_REPO');
      }

      return success;
    } catch (e, st) {
      AppLogger.e('assignRoleToUser erreur', 'ROLE_CODE_REPO', e, st);
      return false;
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Méthodes utilitaires
  // ──────────────────────────────────────────────────────────────────────────

  Future<List<String>> fetchAllPatterns() async {
    // RLS bloque l'accès direct — retourner vide
    // Les patterns ne sont plus nécessaires car la RPC gère la vérification
    AppLogger.w('fetchAllPatterns: bloqué par RLS, utiliser redeemSecretCode', 'ROLE_CODE_REPO');
    return [];
  }

  Future<Map<String, dynamic>?> verifyAndGetRoleComplete(String code) async {
    return await redeemSecretCode(code);
  }

  Future<String?> verifyAndGetRoleCode(String code) async {
    final result = await redeemSecretCode(code);
    return result?['role_code'] as String?;
  }

  Future<void> markCodeAsUsed(String roleCode, String userId) async {
    AppLogger.i('markCodeAsUsed: déjà géré par redeem_secret_code RPC', 'ROLE_CODE_REPO');
  }

  Future<Map<String, dynamic>?> getRoleByCode(String roleCode) async {
    try {
      final result = await _supabase
          .from('roles')
          .select()
          .eq('code', roleCode)
          .single();
      return result;
    } catch (e, st) {
      AppLogger.e('getRoleByCode erreur', 'ROLE_CODE_REPO', e, st);
      return null;
    }
  }
}
