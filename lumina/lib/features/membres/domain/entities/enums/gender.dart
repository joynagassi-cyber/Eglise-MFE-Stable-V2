// lib/features/membres/domain/entities/enums/gender.dart
// Énumération du genre

enum Gender {
  male,
  female,
  other;

  String get label {
    switch (this) {
      case Gender.male:
        return 'Masculin';
      case Gender.female:
        return 'Féminin';
      case Gender.other:
        return 'Autre';
    }
  }

  String get icon {
    return ''; // Emojis banned (Zero Emoji Policy 2026)
  }

  static Gender? fromString(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'male':
      case 'm':
      case 'masculin':
      case 'homme':
        return Gender.male;
      case 'female':
      case 'f':
      case 'féminin':
      case 'feminin':
      case 'femme':
        return Gender.female;
      case 'other':
      case 'autre':
      case 'o':
        return Gender.other;
      default:
        return null;
    }
  }
}