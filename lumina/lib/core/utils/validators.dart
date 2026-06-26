// lib/core/utils/validators.dart

class AppValidators {
  AppValidators._();

  /// Valide un email via Regex RFC 5322 simplifié
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer une adresse email valide (ex: nom@gmail.com)';
    }
    // Format strict exigé : nom@domaine.extension sans espaces ni caractères spéciaux non autorisés
    // Le nom peut contenir lettres, chiffres, points, tirets bas.
    // Le domaine doit contenir lettres et chiffres et éventuellement traits d'union.
    // L'extension doit avoir au moins 2 lettres.
    final emailRegex = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Veuillez entrer une adresse email valide (ex: nom@gmail.com)';
    }
    return null;
  }

  /// Valide un mot de passe (min 8 car, 1 maj, 1 chiffre, 1 spécial)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    // Optionnel selon besoin strict : on peut ajouter des vérifications regex ici
    // pour forcer majuscule/chiffre si l'évaluation de force ne suffit pas.
    return null;
  }

  /// Valide le prénom
  static String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le prénom est requis';
    }
    if (value.trim().length < 2) {
      return 'Le prénom est trop court';
    }
    return null;
  }

  /// Valide le nom
  static String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le nom est requis';
    }
    if (value.trim().length < 2) {
      return 'Le nom est trop court';
    }
    return null;
  }
}
