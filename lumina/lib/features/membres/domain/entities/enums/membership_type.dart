// lib/features/membres/domain/entities/enums/membership_type.dart
// Type d'adhésion à l'église

enum MembershipType {
  fullMember, // Membre à part entière
  associateMember, // Membre associé
  prospective, // En attente de baptême/adhésion
  visitor, // Visiteur régulier
  friend, // Ami de l'église
  child; // Enfant de membre

  String get label {
    switch (this) {
      case MembershipType.fullMember:
        return 'Membre à part entière';
      case MembershipType.associateMember:
        return 'Membre associé';
      case MembershipType.prospective:
        return 'En cours d\'adhésion';
      case MembershipType.visitor:
        return 'Visiteur régulier';
      case MembershipType.friend:
        return 'Ami de l\'église';
      case MembershipType.child:
        return 'Enfant de membre';
    }
  }

  String get shortLabel {
    switch (this) {
      case MembershipType.fullMember:
        return 'Membre';
      case MembershipType.associateMember:
        return 'Associé';
      case MembershipType.prospective:
        return 'Prospectif';
      case MembershipType.visitor:
        return 'Visiteur';
      case MembershipType.friend:
        return 'Ami';
      case MembershipType.child:
        return 'Enfant';
    }
  }

  static MembershipType fromString(String? value) {
    if (value == null) return MembershipType.visitor;
    switch (value.toLowerCase()) {
      case 'fullmember':
      case 'full_member':
      case 'membre':
        return MembershipType.fullMember;
      case 'associatemember':
      case 'associate_member':
      case 'associé':
        return MembershipType.associateMember;
      case 'prospective':
        return MembershipType.prospective;
      case 'visitor':
      case 'visiteur':
        return MembershipType.visitor;
      case 'friend':
      case 'ami':
        return MembershipType.friend;
      case 'child':
      case 'enfant':
        return MembershipType.child;
      default:
        return MembershipType.visitor;
    }
  }
}

/// Type de baptême
enum BaptismType {
  immersion, // Par immersion (baptiste)
  sprinkling, // Par aspersion
  pouring, // Par effusion
  unknown; // Inconnu

  String get label {
    switch (this) {
      case BaptismType.immersion:
        return 'Par immersion';
      case BaptismType.sprinkling:
        return 'Par aspersion';
      case BaptismType.pouring:
        return 'Par effusion';
      case BaptismType.unknown:
        return 'Inconnu';
    }
  }
}