// lib/features/auth/domain/exceptions/google_auth_exceptions.dart

// Exceptions spécifiques au flux d'authentification Google.
// Elles permettent de typer les erreurs et d'éviter les `throw Exception`
// génériques qui polluent les logs.

class GoogleAuthException implements Exception {
  final String message;
  const GoogleAuthException(this.message);

  @override
  String toString() => 'GoogleAuthException: $message';
}

/// L'utilisateur a explicitement annulé le dialogue Google.
class GoogleAuthCancelledException extends GoogleAuthException {
  const GoogleAuthCancelledException()
      : super('Utilisateur a annulé la connexion Google');
}

/// Un token requis (idToken ou accessToken) est manquant ou invalide.
class GoogleAuthTokenException extends GoogleAuthException {
  const GoogleAuthTokenException(String details)
      : super('Token Google invalide : $details');
}
