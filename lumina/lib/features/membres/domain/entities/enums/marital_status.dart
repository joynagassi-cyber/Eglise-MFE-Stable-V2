// lib/features/membres/domain/entities/enums/marital_status.dart
// Situation matrimoniale

enum MaritalStatus {
  single, // Célibataire
  engaged, // Fiancé(e)
  married, // Marié(e)
  separated, // Séparé(e)
  divorced, // Divorcé(e)
  widowed, // Veuf/Veuve
  remarried, // Remarié(e)
  cohabiting; // En concubinage

  String get label {
    switch (this) {
      case MaritalStatus.single:
        return 'Célibataire';
      case MaritalStatus.engaged:
        return 'Fiancé(e)';
      case MaritalStatus.married:
        return 'Marié(e)';
      case MaritalStatus.separated:
        return 'Séparé(e)';
      case MaritalStatus.divorced:
        return 'Divorcé(e)';
      case MaritalStatus.widowed:
        return 'Veuf/Veuve';
      case MaritalStatus.remarried:
        return 'Remarié(e)';
      case MaritalStatus.cohabiting:
        return 'En concubinage';
    }
  }

  String get icon {
    return ''; // Emojis banned (Zero Emoji Policy 2026)
  }

  static MaritalStatus fromString(String? value) {
    if (value == null) return MaritalStatus.single;
    switch (value.toLowerCase()) {
      case 'single':
      case 'célibataire':
      case 'celibataire':
        return MaritalStatus.single;
      case 'engaged':
      case 'fiancé':
      case 'fiance':
        return MaritalStatus.engaged;
      case 'married':
      case 'marié':
      case 'marie':
        return MaritalStatus.married;
      case 'separated':
      case 'séparé':
      case 'separe':
        return MaritalStatus.separated;
      case 'divorced':
      case 'divorcé':
      case 'divorce':
        return MaritalStatus.divorced;
      case 'widowed':
      case 'veuf':
      case 'veuve':
        return MaritalStatus.widowed;
      case 'remarried':
      case 'remarié':
      case 'remarie':
        return MaritalStatus.remarried;
      case 'cohabiting':
      case 'concubinage':
        return MaritalStatus.cohabiting;
      default:
        return MaritalStatus.single;
    }
  }
}

/// Type de mariage
enum WeddingType {
  churchOnly, // Religieux uniquement
  civilOnly, // Civil uniquement
  churchAndCivil, // Religieux et civil
  traditional, // Traditionnel/Coutumier
  traditionalAndChurch, // Traditionnel et religieux
  all; // Tous (civil, traditionnel, religieux)

  String get label {
    switch (this) {
      case WeddingType.churchOnly:
        return 'Religieux uniquement';
      case WeddingType.civilOnly:
        return 'Civil uniquement';
      case WeddingType.churchAndCivil:
        return 'Civil et religieux';
      case WeddingType.traditional:
        return 'Traditionnel';
      case WeddingType.traditionalAndChurch:
        return 'Traditionnel et religieux';
      case WeddingType.all:
        return 'Civil, traditionnel et religieux';
    }
  }
}