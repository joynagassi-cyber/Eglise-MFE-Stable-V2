// ============================================================
// FICHIER : lib/core/utils/role_query_filter.dart
// DESCRIPTION : Utilitaire central de filtrage Supabase par rôle.
//               Applique automatiquement les contraintes de visibilité
//               (church_id, group_id, member_id) sur les requêtes.
// ============================================================

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/domain/role_data_scope.dart';

/// Applique les filtres de visibilité sur une requête Supabase
/// en fonction du [RoleDataScope] de l'utilisateur.
///
/// Usage:
/// ```dart
/// final scope = ref.watch(roleDataScopeProvider);
/// final query = supabase.from('members').select();
/// final filtered = RoleQueryFilter.apply(query, scope);
/// final data = await filtered.order('created_at');
/// ```
class RoleQueryFilter {
  const RoleQueryFilter._();

  /// Applique les filtres de visibilité sur un [PostgrestFilterBuilder].
  ///
  /// - [query] : la requête Supabase en cours de construction.
  /// - [scope] : le périmètre de données de l'utilisateur.
  /// - [churchColumn] : nom de la colonne church_id (par défaut 'church_id').
  /// - [groupColumn] : nom de la colonne group_id (si applicable).
  /// - [userColumn] : nom de la colonne user/member_id pour le filtrage personnel.
  /// - [skipChurchFilter] : true pour les tables sans colonne church_id.
  static PostgrestFilterBuilder<List<Map<String, dynamic>>> apply(
    PostgrestFilterBuilder<List<Map<String, dynamic>>> query,
    RoleDataScope scope, {
    String churchColumn = 'church_id',
    String? groupColumn,
    String? userColumn,
    bool skipChurchFilter = false,
  }) {
    switch (scope.visibilityLevel) {
      case DataVisibilityLevel.global:
        // Superadmin/Président : filtre optionnel par église sélectionnée
        if (scope.churchId != null && !skipChurchFilter) {
          return query.eq(churchColumn, scope.churchId!);
        }
        return query;

      case DataVisibilityLevel.church:
        // Admin d'église : filtre obligatoire par church_id
        if (scope.churchId != null && !skipChurchFilter) {
          return query.eq(churchColumn, scope.churchId!);
        }
        return query;

      case DataVisibilityLevel.group:
        // Chef de groupe : filtre par église + groupe
        var filtered = query;
        if (scope.churchId != null && !skipChurchFilter) {
          filtered = filtered.eq(churchColumn, scope.churchId!);
        }
        if (scope.groupId != null && groupColumn != null) {
          filtered = filtered.eq(groupColumn, scope.groupId!);
        }
        return filtered;

      case DataVisibilityLevel.personal:
        // Membre : filtre par église + ses propres données
        var filtered = query;
        if (scope.churchId != null && !skipChurchFilter) {
          filtered = filtered.eq(churchColumn, scope.churchId!);
        }
        if (userColumn != null) {
          filtered = filtered.eq(userColumn, scope.userId);
        }
        return filtered;
    }
  }

  /// Version pour les requêtes de comptage (count queries).
  static PostgrestFilterBuilder<List<Map<String, dynamic>>> applyForCount(
    PostgrestFilterBuilder<List<Map<String, dynamic>>> query,
    RoleDataScope scope, {
    String churchColumn = 'church_id',
  }) {
    if (scope.churchId != null) {
      return query.eq(churchColumn, scope.churchId!);
    }
    return query;
  }

  /// Construit les filtres Supabase Realtime pour un canal donné.
  ///
  /// Retourne `null` si aucun filtre n'est nécessaire (global).
  static String? buildRealtimeFilter(
    RoleDataScope scope, {
    String churchColumn = 'church_id',
    String? groupColumn,
    String? userColumn,
  }) {
    final filters = <String>[];

    // Ajouter le filtre église
    if (scope.churchId != null) {
      filters.add('$churchColumn=eq.${scope.churchId}');
    }

    // Ajouter le filtre groupe (chef de groupe)
    if (scope.isGroupScoped && scope.groupId != null && groupColumn != null) {
      filters.add('$groupColumn=eq.${scope.groupId}');
    }

    // Ajouter le filtre utilisateur (membre)
    if (scope.isPersonalOnly && userColumn != null) {
      filters.add('$userColumn=eq.${scope.userId}');
    }

    return filters.isEmpty ? null : filters.join(':');
  }
}
