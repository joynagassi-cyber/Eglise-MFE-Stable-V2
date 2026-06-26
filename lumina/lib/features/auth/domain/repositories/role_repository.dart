import '../../../../core/auth/domain/entities/church_role.dart';
import '../../../../core/auth/domain/entities/user_role.dart';
import '../../../../core/auth/domain/entities/enums/permission.dart';

/// Interface du repository pour la gestion des rôles et permissions
///
/// Responsabilités :
/// - CRUD des rôles personnalisés
/// - Récupération des rôles prédéfinis
/// - Gestion des permissions par rôle
/// - Assignation de rôles aux utilisateurs
abstract class RoleRepository {
  // ============================================
  // RÔLES - CRUD
  // ============================================

  /// Récupère tous les rôles d'une église
  ///
  /// [churchId] - Identifiant de l'église
  /// [includeInactive] - Inclure les rôles inactifs
  Future<List<ChurchRole>> getAllRoles({
    required String churchId,
    bool includeInactive = false,
  });

  /// Récupère un rôle par son ID
  Future<ChurchRole?> getRoleById(String roleId);

  /// Récupère les rôles système prédéfinis
  Future<List<ChurchRole>> getSystemRoles({required String churchId});

  /// Récupère les rôles personnalisés
  Future<List<ChurchRole>> getCustomRoles({
    required String churchId,
    bool includeInactive = false,
  });

  /// Crée un nouveau rôle personnalisé
  ///
  /// [role] - Le rôle à créer
  /// Retourne le rôle créé avec son ID généré
  Future<ChurchRole> createRole(ChurchRole role);

  /// Met à jour un rôle existant
  ///
  /// [role] - Le rôle à mettre à jour
  /// Les rôles système ne peuvent pas être modifiés
  Future<ChurchRole> updateRole(ChurchRole role);

  /// Supprime un rôle
  ///
  /// [roleId] - Identifiant du rôle à supprimer
  /// Les rôles système ne peuvent pas être supprimés
  /// Les rôles assignés à des utilisateurs ne peuvent pas être supprimés
  Future<void> deleteRole(String roleId);

  // ============================================
  // PERMISSIONS
  // ============================================

  /// Récupère toutes les permissions disponibles
  List<Permission> getAllPermissions();

  /// Récupère les permissions groupées par module
  Map<String, List<Permission>> getPermissionsByModule();

  /// Vérifie si un rôle possède une permission
  Future<bool> roleHasPermission({
    required String roleId,
    required Permission permission,
  });

  /// Ajoute des permissions à un rôle
  Future<ChurchRole> addPermissionsToRole({
    required String roleId,
    required Set<Permission> permissions,
  });

  /// Retire des permissions d'un rôle
  Future<ChurchRole> removePermissionsFromRole({
    required String roleId,
    required Set<Permission> permissions,
  });

  // ============================================
  // ASSIGNATION UTILISATEURS
  // ============================================

  /// Récupère le rôle d'un utilisateur dans une église
  Future<ChurchRole?> getUserRole({
    required String userId,
    required String churchId,
  });

  /// Assigne un rôle à un utilisateur
  Future<void> assignRoleToUser({
    required String userId,
    required String churchId,
    required String roleId,
    String? groupId,
  });

  /// Change le rôle d'un utilisateur
  Future<void> changeUserRole({
    required String userId,
    required String churchId,
    required String newRoleId,
  });

  /// Assigne le rôle par défaut (membre) à un utilisateur
  Future<ChurchRole?> assignDefaultRole({
    required String userId,
    String? churchId,
  });

  /// Récupère tous les utilisateurs ayant un rôle spécifique
  Future<List<String>> getUsersByRole({
    required String churchId,
    required String roleId,
  });

  // ============================================
  // MULTI-RÔLE V3.1
  // ============================================

  /// Récupère tous les rôles disponibles pour l'utilisateur actuel
  Future<List<UserRole>> getAvailableRolesForUser(String userId);

  /// Change le rôle actif dans la session utilisateur
  Future<void> switchActiveRole({
    required String userId,
    required String roleId,
    String? groupId,
  });

  // ============================================
  // SYNCHRONISATION
  // ============================================

  /// Synchronise les rôles locaux avec Supabase
  Future<void> syncRoles({required String churchId});

  /// Initialise les rôles système pour une nouvelle église
  ///
  /// Crée automatiquement les 6 rôles prédéfinis :
  /// - Admin, Pasteur, Secrétaire, Trésorier, Berger, Membre
  Future<void> seedSystemRoles({required String churchId});

  // ============================================
  // STREAMING
  // ============================================

  /// Écoute les changements de rôles
  Stream<List<ChurchRole>> watchRoles({required String churchId});

  /// Écoute les changements d'un rôle spécifique
  Stream<ChurchRole?> watchRole(String roleId);
}