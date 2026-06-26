// ============================================================
// FICHIER : lib/core/domain/role_data_scope.dart
// DESCRIPTION : Modèle immutable définissant le périmètre de données
//               accessible par un utilisateur selon son rôle.
// ============================================================

import 'package:equatable/equatable.dart';

/// Niveaux de visibilité hiérarchiques.
enum DataVisibilityLevel {
  /// Accès global (superadmin, président)
  global,

  /// Accès limité à une église
  church,

  /// Accès limité à un groupe au sein d'une église
  group,

  /// Accès limité à ses propres données
  personal,
}

/// Rôles qui ont accès aux données administratives (finances, audit, etc.)
const _adminRoles = {
  'superadmin',
  'president',
  'vice_president',
  'secretaire_general',
  'tresorier_general',
  'directeur_regional',
  'coordinateur_national',
  'auditeur_general',
  'administrateur_systeme',
  'gestionnaire_multi_eglise',
  'responsable_securite',
  'responsable_conformite',
  'directeur_financier',
  'directeur_operations',
  'responsable_rh',
  'responsable_communication',
  'responsable_it',
  'responsable_formation',
  'responsable_audit',
  'admin',
};

/// Rôles de chef de groupe
const _groupLeaderRoles = {
  'chef_groupe',
  'berger',
  'animateur_groupe',
};

class RoleDataScope extends Equatable {
  final String userId;
  final String role;
  final String? churchId;
  final String? groupId;
  final DataVisibilityLevel visibilityLevel;

  const RoleDataScope({
    required this.userId,
    required this.role,
    this.churchId,
    this.groupId,
    required this.visibilityLevel,
  });

  /// Construit un [RoleDataScope] à partir du rôle et du contexte utilisateur.
  factory RoleDataScope.fromContext({
    required String userId,
    required String role,
    String? churchId,
    String? groupId,
  }) {
    final level = _resolveVisibilityLevel(role);
    return RoleDataScope(
      userId: userId,
      role: role,
      churchId: churchId,
      groupId: level == DataVisibilityLevel.group ? groupId : null,
      visibilityLevel: level,
    );
  }

  /// Un scope vide (non authentifié).
  static const empty = RoleDataScope(
    userId: '',
    role: '',
    visibilityLevel: DataVisibilityLevel.personal,
  );

  bool get isGlobal => visibilityLevel == DataVisibilityLevel.global;
  bool get isChurchScoped => visibilityLevel == DataVisibilityLevel.church;
  bool get isGroupScoped => visibilityLevel == DataVisibilityLevel.group;
  bool get isPersonalOnly => visibilityLevel == DataVisibilityLevel.personal;

  bool get isAdmin => _adminRoles.contains(role);
  bool get isGroupLeader => _groupLeaderRoles.contains(role);
  bool get isMember => !isAdmin && !isGroupLeader;

  /// Peut voir les transactions et données financières.
  bool get canViewFinance =>
      isAdmin ||
      const {
        'tresorier_general',
        'directeur_financier',
        'superadmin',
        'president'
      }.contains(role);

  /// Peut voir les logs d'audit.
  bool get canViewAudit => const {
        'superadmin',
        'president',
        'auditeur_general',
        'administrateur_systeme',
        'responsable_securite',
        'responsable_audit',
        'responsable_it',
        'vice_president',
      }.contains(role);

  static DataVisibilityLevel _resolveVisibilityLevel(String role) {
    if (role == 'superadmin' || role == 'president') {
      return DataVisibilityLevel.global;
    }
    if (_adminRoles.contains(role)) {
      return DataVisibilityLevel.church;
    }
    if (_groupLeaderRoles.contains(role)) {
      return DataVisibilityLevel.group;
    }
    return DataVisibilityLevel.personal;
  }

  @override
  List<Object?> get props => [userId, role, churchId, groupId, visibilityLevel];

  @override
  String toString() =>
      'RoleDataScope($role, church=$churchId, group=$groupId, level=$visibilityLevel)';
}
