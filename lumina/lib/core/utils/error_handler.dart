class ErrorHandler {
  static String getUserFriendlyMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('network') || errorStr.contains('socket')) {
      return 'Problème de connexion. Vérifiez votre internet.';
    }

    if (errorStr.contains('auth') || errorStr.contains('credentials')) {
      return 'Identifiants incorrects. Veuillez réessayer.';
    }

    if (errorStr.contains('permission') || errorStr.contains('denied')) {
      return 'Vous n\'avez pas les droits nécessaires pour cette action.';
    }

    if (errorStr.contains('timeout')) {
      return 'La requête a pris trop de temps. Réessayez.';
    }

    if (errorStr.contains('not found') || errorStr.contains('404')) {
      return 'Ressource introuvable.';
    }

    if (errorStr.contains('email') && errorStr.contains('already')) {
      return 'Cet email est déjà utilisé.';
    }

    return 'Une erreur est survenue. Veuillez réessayer.';
  }
}
