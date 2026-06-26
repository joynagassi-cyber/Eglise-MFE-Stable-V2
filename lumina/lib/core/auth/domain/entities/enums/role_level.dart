/// Niveaux de rôles hiérarchiques dans l'église
///
/// Chaque niveau possède un ensemble de permissions par défaut.
/// Les rôles personnalisés peuvent être créés avec des permissions spécifiques.
enum RoleLevel {
  ///  CATÉGORIE 1 : ACCÈS TOTAL (ADMIN)
  /// Superadmin, Webmaster, Président, Vice-Président, Admin Système.
  adminTotal,

  /// Ancien niveau admin (pour compatibilité)
  admin,

  ///  CATÉGORIE 2 : ACCÈS FINANCE (TRESORERIE)
  /// Trésorier, Comptable, Commissaire aux comptes, Validateur.
  finance,

  ///  CATÉGORIE 3 : ACCÈS STAFF (ADMINISTRATIF)
  /// Pasteur, Secrétaire Général, Archive, Documents.
  staff,

  /// 👥 CATÉGORIE 4 : ACCÈS GROUPE (LEADER)
  /// Responsable de groupe, Chorale, Enfants, Jeunesse, Hommes, Femmes.
  groupLeader,

  /// Ancien niveau superadmin (pour compatibilité)
  superadmin,

  /// Alias pour consultation (pour compatibilité UI)
  consultation,
  membre,

  /// Rôle personnalisé / Non défini
  custom,
}

/// Extension pour obtenir des métadonnées sur chaque niveau de rôle
extension RoleLevelExtension on RoleLevel {
  /// Nom lisible du rôle
  String get label {
    switch (this) {
      case RoleLevel.adminTotal:
      case RoleLevel.admin:
        return 'Accès Total (Admin)';
      case RoleLevel.finance:
        return 'Finance & Trésorerie';
      case RoleLevel.staff:
        return 'Staff & Administratif';
      case RoleLevel.groupLeader:
        return 'Leader de Groupe';
      case RoleLevel.consultation:
      case RoleLevel.membre:
        return 'Consultation (Membre)';
      case RoleLevel.superadmin:
        return 'Super Administrateur';
      case RoleLevel.custom:
        return 'Rôle Personnalisé';
    }
  }

  /// Description du rôle
  String get description {
    switch (this) {
      case RoleLevel.adminTotal:
      case RoleLevel.admin:
        return 'Accès total multi-église et gestion du système';
      case RoleLevel.finance:
        return 'Gestion financière, trésorerie et comptabilité';
      case RoleLevel.staff:
        return 'Gestion des membres et données administratives';
      case RoleLevel.groupLeader:
        return 'Gestion d\'équipe et suivi de groupe spécifique';
      case RoleLevel.consultation:
      case RoleLevel.membre:
        return 'Accès en lecture seule aux informations de base';
      case RoleLevel.superadmin:
        return 'Accès Système Racine';
      case RoleLevel.custom:
        return 'Permissions spécifiques définies manuellement';
    }
  }

  /// Icône représentant le rôle
  String get icon {
    switch (this) {
      case RoleLevel.adminTotal:
      case RoleLevel.admin:
        return 'shield';
      case RoleLevel.finance:
        return 'account_balance_wallet';
      case RoleLevel.staff:
        return 'business_center';
      case RoleLevel.groupLeader:
        return 'groups';
      case RoleLevel.consultation:
      case RoleLevel.membre:
        return 'person';
      case RoleLevel.superadmin:
        return 'vpn_key';
      case RoleLevel.custom:
        return 'settings_suggest';
    }
  }

  /// Couleur associée au rôle (en hexadécimal)
  String get color {
    switch (this) {
      case RoleLevel.adminTotal:
      case RoleLevel.admin:
        return '#F44336'; // Rouge Admin
      case RoleLevel.finance:
        return '#4CAF50'; // Vert Finance
      case RoleLevel.staff:
        return '#2196F3'; // Bleu Staff
      case RoleLevel.groupLeader:
        return '#FF9800'; // Orange Leader Group
      case RoleLevel.consultation:
      case RoleLevel.membre:
        return '#9E9E9E'; // Gris Consultation
      case RoleLevel.superadmin:
        return '#673AB7'; // Deep Purple
      case RoleLevel.custom:
        return '#607D8B'; // Blue Grey
    }
  }

  /// Niveau hiérarchique (plus le nombre est élevé, plus le rôle a de pouvoir)
  int get hierarchyLevel {
    switch (this) {
      case RoleLevel.superadmin:
        return 1000;
      case RoleLevel.adminTotal:
      case RoleLevel.admin:
        return 100;
      case RoleLevel.finance:
        return 60;
      case RoleLevel.staff:
        return 60;
      case RoleLevel.groupLeader:
        return 40;
      case RoleLevel.consultation:
      case RoleLevel.membre:
        return 10;
      case RoleLevel.custom:
        return 5;
    }
  }

  /// Poids pour le tri (plus petit = plus prioritaire)
  int get priority {
    switch (this) {
      case RoleLevel.superadmin:
        return -1;
      case RoleLevel.adminTotal:
      case RoleLevel.admin:
        return 0;
      case RoleLevel.finance:
        return 2;
      case RoleLevel.staff:
        return 1;
      case RoleLevel.groupLeader:
        return 3;
      case RoleLevel.consultation:
      case RoleLevel.membre:
        return 4;
      case RoleLevel.custom:
        return 5;
    }
  }

  /// Vérifie si ce rôle a un niveau hiérarchique supérieur ou égal à un autre
  bool isSeniorOrEqualTo(RoleLevel other) {
    return hierarchyLevel >= other.hierarchyLevel;
  }

  /// Vérifie si ce rôle a un niveau hiérarchique strictement supérieur
  bool isSeniorTo(RoleLevel other) {
    return hierarchyLevel > other.hierarchyLevel;
  }
}
