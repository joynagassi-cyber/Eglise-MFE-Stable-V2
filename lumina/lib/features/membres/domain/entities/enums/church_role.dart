// lib/features/membres/domain/entities/enums/church_role.dart
// Rôles dans l'église (contexte Baptiste Évangélique)

enum ChurchRoleType {
  superintendent, // Super admin
  federationPresident, // Président fédération
  seniorPastor, // Pasteur principal
  associatePastor, // Pasteur associé
  elderDeacon, // Ancien/Diacre
  treasurer, // Trésorier
  secretary, // Secrétaire
  cellLeader, // Responsable cellule
  ministryLeader, // Responsable ministère
  worshipLeader, // Responsable louange
  choirDirector, // Chef de chorale
  youthLeader, // Responsable jeunesse
  womenLeader, // Responsable femmes
  menLeader, // Responsable hommes
  sundaySchoolTeacher, // Moniteur école du dimanche
  usher, // Huissier/Protocole
  member, // Membre simple
  volunteer; // Bénévole

  String get label {
    switch (this) {
      case ChurchRoleType.superintendent:
        return 'Surintendant';
      case ChurchRoleType.federationPresident:
        return 'Président de Fédération';
      case ChurchRoleType.seniorPastor:
        return 'Pasteur Principal';
      case ChurchRoleType.associatePastor:
        return 'Pasteur Associé';
      case ChurchRoleType.elderDeacon:
        return 'Ancien/Diacre';
      case ChurchRoleType.treasurer:
        return 'Trésorier';
      case ChurchRoleType.secretary:
        return 'Secrétaire';
      case ChurchRoleType.cellLeader:
        return 'Responsable Cellule';
      case ChurchRoleType.ministryLeader:
        return 'Responsable Département';
      case ChurchRoleType.worshipLeader:
        return 'Responsable Louange';
      case ChurchRoleType.choirDirector:
        return 'Chef de Chorale';
      case ChurchRoleType.youthLeader:
        return 'Responsable Jeunesse';
      case ChurchRoleType.womenLeader:
        return 'Responsable Femmes';
      case ChurchRoleType.menLeader:
        return 'Responsable Hommes';
      case ChurchRoleType.sundaySchoolTeacher:
        return 'Moniteur École du Dimanche';
      case ChurchRoleType.usher:
        return 'Huissier/Protocole';
      case ChurchRoleType.member:
        return 'Membre';
      case ChurchRoleType.volunteer:
        return 'Bénévole';
    }
  }

  String get icon {
    return ''; // Emojis banned (Zero Emoji Policy 2026)
  }

  int get level {
    switch (this) {
      case ChurchRoleType.superintendent:
        return 0;
      case ChurchRoleType.federationPresident:
        return 1;
      case ChurchRoleType.seniorPastor:
        return 2;
      case ChurchRoleType.associatePastor:
        return 3;
      case ChurchRoleType.elderDeacon:
        return 4;
      case ChurchRoleType.treasurer:
        return 5;
      case ChurchRoleType.secretary:
        return 6;
      case ChurchRoleType.cellLeader:
        return 7;
      case ChurchRoleType.ministryLeader:
        return 8;
      case ChurchRoleType.worshipLeader:
      case ChurchRoleType.choirDirector:
      case ChurchRoleType.youthLeader:
      case ChurchRoleType.womenLeader:
      case ChurchRoleType.menLeader:
      case ChurchRoleType.sundaySchoolTeacher:
        return 9;
      case ChurchRoleType.usher:
      case ChurchRoleType.volunteer:
        return 10;
      case ChurchRoleType.member:
        return 11;
    }
  }

  int get colorValue {
    switch (this) {
      case ChurchRoleType.superintendent:
        return 0xFFFFD700; // Gold
      case ChurchRoleType.federationPresident:
        return 0xFFC0C0C0; // Silver
      case ChurchRoleType.seniorPastor:
        return 0xFFFFD700; // Gold
      case ChurchRoleType.associatePastor:
        return 0xFFC0C0C0; // Silver
      case ChurchRoleType.elderDeacon:
        return 0xFFA855F7; // Purple
      case ChurchRoleType.treasurer:
        return 0xFF10B981; // Green
      case ChurchRoleType.secretary:
        return 0xFF3B82F6; // Blue
      default:
        return 0xFF6B7280; // Gray
    }
  }

  static ChurchRoleType fromString(String? value) {
    if (value == null) return ChurchRoleType.member;
    final lower = value.toLowerCase().replaceAll(' ', '').replaceAll('_', '');
    for (final role in ChurchRoleType.values) {
      if (role.name.toLowerCase() == lower) return role;
    }
    return ChurchRoleType.member;
  }
}