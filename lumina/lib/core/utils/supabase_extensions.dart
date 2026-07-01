import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/auth_provider.dart';

/// Extension pour ajouter timeout automatique aux requêtes Supabase
extension SupabaseQueryTimeout on PostgrestFilterBuilder {
  /// Exécute la requête avec timeout
  ///
  /// Par défaut: 30s
  /// Lance TimeoutException si dépassé
  Future<T> withTimeout<T>({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    return Future.value(this as T).timeout(
      timeout,
      onTimeout: () => throw TimeoutException(
        'Requête trop longue (>${timeout.inSeconds}s)',
        timeout,
      ),
    );
  }
}

/// Extension pour PostgrestBuilder
extension PostgrestBuilderTimeout on PostgrestBuilder {
  Future<T> withTimeout<T>({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    return Future.value(this as T).timeout(
      timeout,
      onTimeout: () => throw TimeoutException(
        'Requête trop longue (>${timeout.inSeconds}s)',
        timeout,
      ),
    );
  }
}

// ============================================================================
// SECURE INTERCEPTOR — Injection automatique du filtre church_id
//
// Pattern : Extension sur PostgrestFilterBuilder pour injecter
// automatiquement le filtre `church_id` dans toutes les requêtes.
//
// Usage :
//   final posts = await supabase
//     .from('social_posts')
//     .select()
//     .scoped(ref);
//
//   Pour INSERT (ajoute church_id aux donnees en ecrasant toute valeur):
//     supabase.from('table').insertScoped(ref, values: data)
//
//   Pour les requetes RPC (deja filtrees cote serveur) :
//     Pas besoin de scoped() le RPC recoit p_church_id en parametre.
//
// Comportement :
//   - SuperAdmin (churchId == '*')  pas de filtre (acces global)
//   - Non authentifie               pas de filtre (Supabase RLS gere)
//   - Membre standard               filtre .eq('church_id', churchId)
// ============================================================================

/// Extension pour filtrer automatiquement par church_id sur les requetes SELECT
extension SupabaseScopedFilter<T> on PostgrestFilterBuilder<T> {
  /// Ajoute automatiquement le filtre church_id base sur la session active.
  ///
  /// [churchColumn] : nom de la colonne church_id (par defaut 'church_id').
  /// [allowEmpty] : si true, ne leve pas d exception si churchId est vide.
  ///
  /// Retourne la requete filtree, ou la requete inchangee pour les superadmins.
  PostgrestFilterBuilder<T> scoped(
    Ref ref, {
    String churchColumn = 'church_id',
    bool allowEmpty = false,
  }) {
    final churchId = ref.read(activeChurchIdProvider);

    // SuperAdmin: pas de filtre (acces global)
    if (churchId == '*') return this;

    // Non authentifie: on laisse Supabase RLS gerer
    if (churchId == 'global' || churchId.isEmpty) {
      if (allowEmpty) return this;
      throw Exception(
        'SECURITE: Tentative de requete sans ID d eglise. '
        'Utilisez allowEmpty=true pour les tables sans church_id.',
      );
    }

    return eq(churchColumn, churchId);
  }
}

/// Extension pour preparer une requete SELECT automatiquement filtree
extension SupabaseQueryScoped on PostgrestQueryBuilder {
  /// Execute un SELECT() avec filtre church_id automatique.
  ///
  /// Equivalent a : `supabase.from('table').select(columns).scoped(ref)`
  PostgrestFilterBuilder<List<Map<String, dynamic>>> scopedSelect(
    Ref ref, {
    String columns = '*',
    String churchColumn = 'church_id',
  }) {
    return select(columns).scoped(ref, churchColumn: churchColumn);
  }
}

/// Extension pour injecter church_id dans les INSERT
extension SupabaseInsertScoped on PostgrestQueryBuilder {
  /// Insere des donnees avec injection automatique de church_id.
  ///
  /// FORCE la valeur de church_id depuis la session active.
  /// Toute valeur preexistante dans [values] est ECRASEE pour garantir
  /// l isolation multi-eglise (securite).
  PostgrestBuilder insertScoped(
    Ref ref, {
    required Map<String, dynamic> values,
    String churchColumn = 'church_id',
  }) {
    final churchId = ref.read(activeChurchIdProvider);

    if (churchId != '*' && churchId != 'global' && churchId.isNotEmpty) {
      // Securite: toujours ecraser pour garantir l isolation
      values[churchColumn] = churchId;
    }

    return insert(values);
  }

  /// Insere une liste de donnees avec injection automatique de church_id.
  PostgrestBuilder insertScopedAll(
    Ref ref, {
    required List<Map<String, dynamic>> values,
    String churchColumn = 'church_id',
  }) {
    final churchId = ref.read(activeChurchIdProvider);

    if (churchId != '*' && churchId != 'global' && churchId.isNotEmpty) {
      for (final v in values) {
        // Securite: toujours ecraser pour garantir l isolation
        v[churchColumn] = churchId;
      }
    }

    return insert(values);
  }
}
