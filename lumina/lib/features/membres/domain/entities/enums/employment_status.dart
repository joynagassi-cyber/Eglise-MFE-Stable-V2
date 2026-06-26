// lib/features/membres/domain/entities/enums/employment_status.dart
// Situation professionnelle

enum EmploymentStatus {
  employed, // Employé(e)
  selfEmployed, // Indépendant(e)
  businessOwner, // Chef d'entreprise
  unemployed, // Sans emploi
  student, // Étudiant(e)
  retired, // Retraité(e)
  homemaker, // Au foyer
  disability, // Invalidité
  sabbatical, // En congé sabbatique
  other; // Autre

  String get label {
    switch (this) {
      case EmploymentStatus.employed:
        return 'Employé(e)';
      case EmploymentStatus.selfEmployed:
        return 'Indépendant(e)';
      case EmploymentStatus.businessOwner:
        return 'Chef d\'entreprise';
      case EmploymentStatus.unemployed:
        return 'Sans emploi';
      case EmploymentStatus.student:
        return 'Étudiant(e)';
      case EmploymentStatus.retired:
        return 'Retraité(e)';
      case EmploymentStatus.homemaker:
        return 'Au foyer';
      case EmploymentStatus.disability:
        return 'Invalidité';
      case EmploymentStatus.sabbatical:
        return 'Congé sabbatique';
      case EmploymentStatus.other:
        return 'Autre';
    }
  }

  String get icon {
    return ''; // Emojis banned (Zero Emoji Policy 2026)
  }

  static EmploymentStatus fromString(String? value) {
    if (value == null) return EmploymentStatus.other;
    final lower = value.toLowerCase().replaceAll(' ', '').replaceAll('_', '');
    for (final status in EmploymentStatus.values) {
      if (status.name.toLowerCase() == lower) return status;
    }
    return EmploymentStatus.other;
  }
}

/// Niveau d'éducation
enum EducationLevel {
  none, // Aucun
  primary, // Primaire
  middleSchool, // Collège
  highSchool, // Lycée
  vocational, // Formation professionnelle
  someCollege, // Études supérieures incomplètes
  associate, // BTS/DUT (Bac+2)
  bachelor, // Licence (Bac+3)
  master, // Master (Bac+5)
  doctorate, // Doctorat
  postDoctorate; // Post-doctorat

  String get label {
    switch (this) {
      case EducationLevel.none:
        return 'Aucun';
      case EducationLevel.primary:
        return 'Primaire';
      case EducationLevel.middleSchool:
        return 'Collège';
      case EducationLevel.highSchool:
        return 'Lycée/Baccalauréat';
      case EducationLevel.vocational:
        return 'Formation professionnelle';
      case EducationLevel.someCollege:
        return 'Études supérieures';
      case EducationLevel.associate:
        return 'BTS/DUT (Bac+2)';
      case EducationLevel.bachelor:
        return 'Licence (Bac+3)';
      case EducationLevel.master:
        return 'Master (Bac+5)';
      case EducationLevel.doctorate:
        return 'Doctorat';
      case EducationLevel.postDoctorate:
        return 'Post-doctorat';
    }
  }
}