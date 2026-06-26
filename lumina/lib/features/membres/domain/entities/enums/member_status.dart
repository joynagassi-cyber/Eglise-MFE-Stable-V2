// lib/features/membres/domain/entities/enums/member_status.dart
// Statut du membre dans l'église

enum MemberStatus {
  active, // Actif
  inactive, // Inactif
  visitor, // Visiteur
  prospective, // En cours d'adhésion
  deceased, // Décédé
  transferred, // Transféré
  suspended, // Suspendu (discipline)
  restored; // Restauré après discipline

  String get label {
    switch (this) {
      case MemberStatus.active:
        return 'Actif';
      case MemberStatus.inactive:
        return 'Inactif';
      case MemberStatus.visitor:
        return 'Visiteur';
      case MemberStatus.prospective:
        return 'En cours d\'adhésion';
      case MemberStatus.deceased:
        return 'Décédé';
      case MemberStatus.transferred:
        return 'Transféré';
      case MemberStatus.suspended:
        return 'Suspendu';
      case MemberStatus.restored:
        return 'Restauré';
    }
  }

  String get icon {
    switch (this) {
      case MemberStatus.active:
        return '🟢';
      case MemberStatus.inactive:
        return '🟡';
      case MemberStatus.visitor:
        return '';
      case MemberStatus.prospective:
        return '⏳';
      case MemberStatus.deceased:
        return '🕊️';
      case MemberStatus.transferred:
        return '🔄';
      case MemberStatus.suspended:
        return '🔴';
      case MemberStatus.restored:
        return '';
    }
  }

  int get colorValue {
    switch (this) {
      case MemberStatus.active:
        return 0xFF10B981; // Green
      case MemberStatus.inactive:
        return 0xFFF59E0B; // Amber
      case MemberStatus.visitor:
        return 0xFF3B82F6; // Blue
      case MemberStatus.prospective:
        return 0xFF8B5CF6; // Purple
      case MemberStatus.deceased:
        return 0xFF6B7280; // Gray
      case MemberStatus.transferred:
        return 0xFF0EA5E9; // Sky
      case MemberStatus.suspended:
        return 0xFFEF4444; // Red
      case MemberStatus.restored:
        return 0xFF14B8A6; // Teal
    }
  }

  static MemberStatus fromString(String? value) {
    if (value == null) return MemberStatus.active;
    switch (value.toLowerCase()) {
      case 'active':
      case 'actif':
        return MemberStatus.active;
      case 'inactive':
      case 'inactif':
        return MemberStatus.inactive;
      case 'visitor':
      case 'visiteur':
        return MemberStatus.visitor;
      case 'prospective':
        return MemberStatus.prospective;
      case 'deceased':
      case 'décédé':
        return MemberStatus.deceased;
      case 'transferred':
      case 'transféré':
        return MemberStatus.transferred;
      case 'suspended':
      case 'suspendu':
        return MemberStatus.suspended;
      case 'restored':
      case 'restauré':
        return MemberStatus.restored;
      default:
        return MemberStatus.active;
    }
  }
}