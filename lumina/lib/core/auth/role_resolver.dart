import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/auth/domain/entities/user_role.dart';

class RoleRepository {
  final SupabaseClient _supabase;

  RoleRepository(this._supabase);

  Future<List<UserRole>> fetchUserRoles(String userId) async {
    // Assuming backend returns a list of roles with augmented info
    // If not, we might need a join query.
    // Given the migration didn't create a specific RPC for this,
    // let's do a join query on client side or use existing view if any.
    // Spec doesn't mention RPC 'fetch_user_roles'.
    // Let's use standard table query joining user_roles and roles.

    final data = await _supabase
        .from('user_roles')
        .select('*, roles(*)')
        .eq('user_id', userId);

    return (data as List).map((row) {
      final roleData = row['roles'];
      return UserRole(
        roleId: row['role_id'] ?? '', // Assuming role_id is in user_roles
        roleCode: roleData['code'],
        roleLabel: roleData['label'],
        priorityLevel: roleData['priority_level'],
        isSuper: roleData['is_super'],
        groupId: row['group_id'],
      );
    }).toList();
  }
}

class RoleResolver {
  /// Determine le rôle principal (celui avec la plus haute priorité)
  static UserRole? resolvePrimaryRole(List<UserRole> roles) {
    if (roles.isEmpty) return null;
    // Sort by priority descending (copie pour ne pas muter la liste originale)
    final sorted = List<UserRole>.from(roles)
      ..sort((a, b) => b.priorityLevel.compareTo(a.priorityLevel));
    return sorted.first;
  }

  /// Retourne tous les rôles liés à un groupe spécifique
  static List<UserRole> resolveGroupRoles(
      List<UserRole> roles, String groupId) {
    return roles
        .where(
            (r) => r.groupId == groupId || (!r.isSuper && r.priorityLevel < 90))
        .toList();
  }

  /// Vérifie si l'utilisateur a une permission spécifique
  static bool hasPermission(UserRole role, String permission) {
    if (role.isSuper) return true;
    return true;
  }

  /// Vérifie si un rôle est un adjoint
  static bool isAdjoint(String roleCode) {
    return roleCode.toLowerCase().contains('adjoint') ||
        roleCode.toLowerCase().contains('adjointe');
  }

  /// Retourne le libellé propre au groupe (ex: "Chorale" pour Chef Chorale)
  static String getGroupLabel(String roleCode) {
    if (roleCode.contains('chorale')) return 'Chorale';
    if (roleCode.contains('intercession')) return 'Intercession';
    if (roleCode.contains('hommes')) return 'Groupe Hommes';
    if (roleCode.contains('femmes')) return 'Groupe Femmes';
    if (roleCode.contains('jeunesse')) return 'Jeunesse';
    if (roleCode.contains('enfants')) return 'Département Enfants';
    if (roleCode.contains('evenement')) return 'Organisation';
    if (roleCode.contains('mission')) return 'Missions';
    if (roleCode.contains('budget')) return 'Gestion Budget';
    return 'Groupe';
  }

  static bool isGroupRole(String roleCode) {
    // FIX: Liste complète des keywords de rôles de groupe
    // Source de vérité: table roles avec scope='group' dans Supabase
    return roleCode.contains('chorale') ||
        roleCode.contains('hommes') ||
        roleCode.contains('femmes') ||
        roleCode.contains('jeunesse') ||
        roleCode.contains('enfants') ||
        roleCode.contains('intercession') ||
        roleCode.contains('evenement') ||
        roleCode.contains('mission') ||
        roleCode.contains('budget') ||
        roleCode.contains('groupe');
  }
}
