import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/permission.dart';
import 'enums/role_level.dart';

part 'church_role.freezed.dart';
part 'church_role.g.dart';

/// Représente un rôle avec ses permissions dans l'église
///
/// Peut être un rôle prédéfini (Admin, Pasteur, Trésorier, etc.)
/// ou un rôle personnalisé avec des permissions spécifiques.
@freezed
class ChurchRole with _$ChurchRole {
  const ChurchRole._();

  const factory ChurchRole({
    /// Identifiant unique du rôle
    required String id,

    /// Église à laquelle appartient ce rôle
    required String churchId,

    /// Niveau du rôle (prédéfini ou custom)
    required RoleLevel level,

    /// Nom du rôle (peut être personnalisé)
    required String name,

    /// Description du rôle
    String? description,

    /// Ensemble des permissions accordées à ce rôle
    required Set<Permission> permissions,

    /// Indique si ce rôle est actif
    @Default(true) bool isActive,

    /// Indique si ce rôle est un rôle système (non modifiable)
    @Default(false) bool isSystemRole,

    /// Date de création
    required DateTime createdAt,

    /// Route initiale de redirection (ex: /dashboard/group/chorale)
    required String initialRoute,

    /// Date de dernière modification
    DateTime? updatedAt,
  }) = _ChurchRole;

  factory ChurchRole.fromJson(Map<String, dynamic> json) =>
      _$ChurchRoleFromJson(json);

  // ============================================
  // FACTORY METHODS - RÔLES PRÉDÉFINIS
  // ============================================

  // ============================================
  // FACTORY MÉTHODE UNIQUE - VERROUILLAGE INVIOLABLE
  // ============================================

  /// Crée un rôle à partir de son label (nom) en verrouillant ses permissions
  /// selon les 5 catégories de sécurité.
  factory ChurchRole.fromLabel({
    required String churchId,
    required String label,
  }) {
    final normalized = _normalizeRoleLabel(label);
    final displayName = _displayNameForSpecialCode(normalized);
    final roleName = displayName.isEmpty
        ? (label.trim().isEmpty ? 'Membre' : label.trim())
        : displayName;
    final routeKey = _routeKeyFor(normalized);

    //  CATÉGORIE 1 : ACCÈS TOTAL (ADMIN)
    const adminRoles = {
      'adm_001',
      'admin_total',
      'president',
      'vice_president',
      'administrateur_systeme',
      'administrateur_systeme_adjoint',
      'super_admin',
      'webmaster',
    };

    if (adminRoles.contains(normalized)) {
      final adminLevel =
          normalized == 'adm_001' ? RoleLevel.superadmin : RoleLevel.adminTotal;

      return ChurchRole(
        id: 'role_${DateTime.now().millisecondsSinceEpoch}_admin',
        churchId: churchId,
        level: adminLevel,
        name: roleName,
        description: 'Accès total et configuration système',
        permissions: Set<Permission>.from(Permission.values),
        initialRoute: '/dashboard',
        isSystemRole: true,
        createdAt: DateTime.now(),
      );
    }

    // 🛡️ CATÉGORIE 1B : PRÉSIDENTS / CHEFS DE GROUPES DÉMOGRAPHIQUES
    const demographicLeaders = {
      'grp_001',
      'president_hommes',
      'president_hommes_adjoint',
      'presidente_femmes',
      'presidente_femmes_adjointe',
      'president_jeunesse',
      'president_jeunesse_adjoint',
      'chef_chorale',
      'maitre_chorale',
      'chef_intercession',
      'responsable_enfants',
      'moniteur_enfants',
      'responsable_groupe',
    };

    if (demographicLeaders.contains(normalized)) {
      return ChurchRole(
        id: 'role_${DateTime.now().millisecondsSinceEpoch}_group',
        churchId: churchId,
        level: RoleLevel.groupLeader,
        name: roleName,
        description: 'Responsable de groupe démographique',
        permissions: {
          Permission.membersView,
          Permission.membersCreate,
          Permission.membersEdit,
          Permission.groupsView,
          Permission.groupsEdit,
          Permission.groupsAssignMembers,
          Permission.eventsView,
          Permission.eventsCreate,
          Permission.eventsEdit,
          Permission.milestonesView,
          Permission.milestonesCreate,
          Permission.socialView,
          Permission.socialCreate,
          Permission.messagingView,
          Permission.messagingSend,
          Permission.messagingBroadcast,
          Permission.dashboardView,
          Permission.dashboardAdvancedStats,
          Permission.financeView,
        },
        initialRoute: _calculateGroupRoute(routeKey),
        isSystemRole: true,
        createdAt: DateTime.now(),
      );
    }

    //  CATÉGORIE 2 : ACCÈS OPÉRATIONNEL (STAFF / FINANCE / PASTEUR)
    const staffRoles = {
      'pst_001',
      'stf_001',
      'pasteur_responsable',
      'pasteur',
      'pasteur_adjoint',
      'pasteur_principal',
      'secretaire_general',
      'secretaire_general_adjoint',
      'secretaire_adjoint',
      'tresorier',
      'tresorier_adjoint',
      'comptable',
      'comptable_adjoint',
      'commissaire_aux_comptes',
      'commissaire_aux_comptes_adjoint',
      'commissaire_compte',
      'auditeur',
      'auditeur_interne',
      'auditeur_interne_adjoint',
      'responsable_archives',
      'gestionnaire_documents',
      'validateur_transaction',
    };

    if (staffRoles.contains(normalized)) {
      final operationalPermissions = Set<Permission>.from(Permission.values);

      // 🛡️ ON RETIRE UNIQUEMENT LES MODULES CRITIQUES (RÉSERVÉS À L'ADMIN TOTAL)
      operationalPermissions.remove(Permission.adminManageRoles);
      operationalPermissions.remove(Permission.adminManageUsers);
      operationalPermissions.remove(Permission.adminSettings);
      operationalPermissions.remove(Permission.adminSystemSettings);
      operationalPermissions.remove(Permission.adminManageChurches);
      operationalPermissions.remove(Permission.auditView);

      return ChurchRole(
        id: 'role_${DateTime.now().millisecondsSinceEpoch}_staff',
        churchId: churchId,
        level: RoleLevel.staff,
        name: roleName,
        description:
            'Accès polyvalent : Membres, Finance, Événements, Messagerie.',
        permissions: operationalPermissions,
        initialRoute: _calculateStaffRoute(routeKey),
        isSystemRole: true,
        createdAt: DateTime.now(),
      );
    }

    //  CATÉGORIE 3 : ACCÈS OPÉRATIONNEL LIMITÉ (COORDINATEURS)
    const coordinatorRoles = {
      'organisateur_evenement',
      'gestionnaire_budget_event',
      'responsable_mission',
      'coordinateur_formation',
      'benevole',
    };

    if (coordinatorRoles.contains(normalized)) {
      return ChurchRole(
        id: 'role_${DateTime.now().millisecondsSinceEpoch}_coordinator',
        churchId: churchId,
        level: RoleLevel.groupLeader,
        name: roleName,
        description: 'Coordination opérationnelle et gestion d\'activités',
        permissions: {
          Permission.membersView,
          Permission.groupsView,
          Permission.eventsView,
          Permission.eventsCreate,
          Permission.eventsEdit,
          Permission.milestonesView,
          Permission.milestonesCreate,
          Permission.socialView,
          Permission.socialCreate,
          Permission.messagingView,
          Permission.messagingSend,
          Permission.dashboardView,
          Permission.financeView,
        },
        initialRoute: _calculateGroupRoute(routeKey),
        isSystemRole: true,
        createdAt: DateTime.now(),
      );
    }

    // 👥 CATÉGORIE 4 : ACCÈS GROUPE (CONSEILLERS/LEADERS AUTRES)
    const counselorRoles = {
      'conseiller',
      'conseiller_adjoint',
      'conseiller_principal',
    };

    if (counselorRoles.contains(normalized)) {
      return ChurchRole(
        id: 'role_${DateTime.now().millisecondsSinceEpoch}_group',
        churchId: churchId,
        level: RoleLevel.groupLeader,
        name: roleName,
        description: 'Gestion d\'équipe et suivi de groupe',
        permissions: {
          Permission.membersView,
          Permission.groupsView,
          Permission.groupsEdit,
          Permission.eventsView,
          Permission.milestonesView,
          Permission.milestonesCreate,
          Permission.socialView,
          Permission.messagingView,
          Permission.messagingSend,
          Permission.dashboardView,
        },
        initialRoute: _calculateGroupRoute(routeKey),
        isSystemRole: true,
        createdAt: DateTime.now(),
      );
    }

    // 👁️ CATÉGORIE 5 : ACCÈS CONSULTATION (MEMBRE/CONSEILLER)
    // Fallback par défaut pour 'donateur', 'visiteur_temporaire', 'membre', etc.
    return ChurchRole(
      id: 'role_${DateTime.now().millisecondsSinceEpoch}_consult',
      churchId: churchId,
      level: RoleLevel.consultation,
      name: 'Membre',
      description: 'Accès en lecture et participation sociale',
      permissions: {
        Permission.membersView,
        Permission.eventsView,
        Permission.socialView,
        Permission.messagingView,
      },
      initialRoute: '/dashboard', // Fallback vers le dashboard membre
      isSystemRole: true,
      createdAt: DateTime.now(),
    );
  }

  static String _normalizeRoleLabel(String value) {
    var normalized = value.toLowerCase().trim();
    const replacements = {
      'à': 'a',
      'â': 'a',
      'ä': 'a',
      'á': 'a',
      'ã': 'a',
      'å': 'a',
      'ç': 'c',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'î': 'i',
      'ï': 'i',
      'ô': 'o',
      'ö': 'o',
      'ó': 'o',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'œ': 'oe',
      'æ': 'ae',
    };
    for (final entry in replacements.entries) {
      normalized = normalized.replaceAll(entry.key, entry.value);
    }
    return normalized.replaceAll(RegExp(r'[\s\-]+'), '_');
  }

  static String _displayNameForSpecialCode(String normalized) {
    switch (normalized) {
      case 'adm_001':
        return 'Admin Total';
      case 'pst_001':
        return 'Pasteur Responsable';
      case 'stf_001':
        return 'Trésorier';
      case 'grp_001':
        return 'Chef Chorale';
      case 'mbr_001':
        return 'Membre';
      default:
        return '';
    }
  }

  static String _routeKeyFor(String normalized) {
    switch (normalized) {
      case 'adm_001':
        return 'administrateur_systeme';
      case 'pst_001':
        return 'pasteur';
      case 'stf_001':
        return 'tresorier';
      case 'grp_001':
        return 'chef_chorale';
      case 'mbr_001':
        return 'membre';
      default:
        return normalized;
    }
  }

  // ─── Route Calculation Helpers ───────────────────────────────────────────

  static String _calculateStaffRoute(String name) {
    if (name == 'pasteur' || name == 'pasteur_responsable') {
      return '/dashboard';
    }
    if (name.contains('tresorier') ||
        name.contains('comptable') ||
        name.contains('validateur_transaction')) {
      return '/finance';
    }
    if (name.contains('secretaire')) {
      return '/brebis'; // Gestion des membres par défaut pour le secrétariat
    }
    return '/dashboard';
  }

  static String _calculateGroupRoute(String name) {
    switch (name) {
      case 'grp_001':
      case 'chef_chorale':
      case 'maitre_chorale':
        return '/dashboard/group/chorale';
      case 'gestionnaire_budget_event':
        return '/finance';
      case 'president_jeunesse':
      case 'president_jeunesse_adjoint':
        return '/dashboard/group/jeunesse';
      case 'responsable_enfants':
      case 'moniteur_enfants':
        return '/dashboard/group/enfants';
      case 'presidente_femmes':
      case 'presidente_femmes_adjointe':
        return '/dashboard/group/femmes';
      case 'president_hommes':
      case 'president_hommes_adjoint':
        return '/dashboard/group/hommes';
      case 'chef_intercession':
        return '/dashboard/group/intercession';
      default:
        // P1a FIX: Fallback vers '/dashboard' au lieu de '/groups'
        return '/dashboard';
    }
  }

  /// Garder superadmin pour le système global
  factory ChurchRole.superadmin() {
    return ChurchRole(
      id: 'role_superadmin',
      churchId: '*',
      level: RoleLevel.superadmin,
      name: 'Super Administrateur',
      initialRoute: '/dashboard',
      permissions: Set<Permission>.from(Permission.values),
      isSystemRole: true,
      createdAt: DateTime.now(),
    );
  }

  // ─── Compatibilité RBAC v2 -> v3 ─────────────────────────────────────────
  // Ces méthodes délèguent à fromLabel pour assurer le verrouillage v3.

  factory ChurchRole.admin({required String churchId}) =>
      ChurchRole.fromLabel(churchId: churchId, label: 'administrateur_systeme');

  factory ChurchRole.pasteur({required String churchId}) =>
      ChurchRole.fromLabel(churchId: churchId, label: 'pasteur');

  factory ChurchRole.tresorier({required String churchId}) =>
      ChurchRole.fromLabel(churchId: churchId, label: 'tresorier');

  factory ChurchRole.leader({required String churchId}) =>
      ChurchRole.fromLabel(churchId: churchId, label: 'responsable_groupe');

  factory ChurchRole.technicien({required String churchId}) =>
      ChurchRole.fromLabel(churchId: churchId, label: 'benevole');

  factory ChurchRole.secretaire({required String churchId}) =>
      ChurchRole.fromLabel(churchId: churchId, label: 'secretaire_general');

  factory ChurchRole.berger({required String churchId}) =>
      ChurchRole.fromLabel(churchId: churchId, label: 'conseiller');

  factory ChurchRole.observateur({required String churchId}) =>
      ChurchRole.fromLabel(churchId: churchId, label: 'visiteur_temporaire');

  factory ChurchRole.membre({required String churchId}) =>
      ChurchRole.fromLabel(churchId: churchId, label: 'membre');

  // ============================================
  // MÉTHODES UTILITAIRES
  // ============================================

  /// Vérifie si le rôle possède une permission donnée
  bool hasPermission(Permission permission) {
    return permissions.contains(permission);
  }

  /// Vérifie si le rôle possède toutes les permissions fournies
  bool hasAllPermissions(Set<Permission> requiredPermissions) {
    return requiredPermissions.every((p) => permissions.contains(p));
  }

  /// Vérifie si le rôle possède au moins une des permissions fournies
  bool hasAnyPermission(Set<Permission> requiredPermissions) {
    return requiredPermissions.any((p) => permissions.contains(p));
  }

  /// Obtient le nombre de permissions accordées
  int get permissionCount => permissions.length;

  /// Vérifie si c'est un rôle système (non modifiable)
  bool get canBeModified => !isSystemRole;
}
