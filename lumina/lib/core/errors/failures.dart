// lib/core/error/failures.dart
// Système de Failures Scellées (Sealed) - Phase A.2
//
// Hiérarchie déterministe des erreurs pour l'application Lumina.
// Chaque Failure est typée et documentée pour garantir un traitement
// exhaustif dans les use cases et providers.

/// Classe de base abstraite pour toutes les erreurs métier.
///
/// Utilisation avec dartz: `Either<Failure, T>`
/// Chaque sous-classe représente une catégorie d'erreur distincte
/// qui DOIT être traitée explicitement par le code appelant.
abstract class Failure {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const Failure(this.message, {this.code, this.stackTrace});

  @override
  String toString() =>
      '$runtimeType($message${code != null ? ', code: $code' : ''})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => Object.hash(runtimeType, message, code);
}

// ============================================================
// SERVEUR & RÉSEAU
// ============================================================

/// Erreur provenant du serveur Supabase (PostgrestException, RPC, etc.)
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message,
      {super.code, super.stackTrace, this.statusCode});
}

/// Erreur de connectivité réseau (pas de connexion, timeout DNS, etc.)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code, super.stackTrace});
}

/// Erreur de timeout sur une opération réseau ou locale
class TimeoutFailure extends Failure {
  final Duration? duration;

  const TimeoutFailure(super.message,
      {super.code, super.stackTrace, this.duration});
}

// ============================================================
// AUTHENTIFICATION & PERMISSIONS
// ============================================================

/// Erreur d'authentification (login, token expiré, session invalide)
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code, super.stackTrace});
}

/// Erreur de permission (accès refusé à une ressource protégée)
class PermissionFailure extends Failure {
  final String? requiredPermission;
  final String? userRole;

  const PermissionFailure(
    super.message, {
    super.code,
    super.stackTrace,
    this.requiredPermission,
    this.userRole,
  });
}

// ============================================================
// DONNÉES LOCALES & SYNCHRONISATION
// ============================================================

/// Erreur de cache local (Isar read/write failure)
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code, super.stackTrace});
}

/// Erreur de synchronisation (file d'attente, conflit de données)
class SyncFailure extends Failure {
  final String? entityType;
  final String? recordId;

  const SyncFailure(
    super.message, {
    super.code,
    super.stackTrace,
    this.entityType,
    this.recordId,
  });
}

/// Conflit de données entre local et distant (Last-Write-Wins decision)
class ConflictFailure extends Failure {
  final String? localVersion;
  final String? remoteVersion;

  const ConflictFailure(
    super.message, {
    super.code,
    super.stackTrace,
    this.localVersion,
    this.remoteVersion,
  });
}

// ============================================================
// VALIDATION & LOGIQUE MÉTIER
// ============================================================

/// Erreur de validation des données d'entrée
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure(super.message,
      {super.code, super.stackTrace, this.fieldErrors});
}

/// Erreur de logique métier (règle métier violée, état incohérent)
class BusinessRuleFailure extends Failure {
  final String? ruleId;

  const BusinessRuleFailure(super.message,
      {super.code, super.stackTrace, this.ruleId});
}

// ============================================================
// CONTEXTE MULTI-ÉGLISE
// ============================================================

/// Erreur de contexte d'église (aucune église active, switch incomplet)
class ChurchContextFailure extends Failure {
  final String? expectedChurchId;
  final String? actualChurchId;

  const ChurchContextFailure(
    super.message, {
    super.code,
    super.stackTrace,
    this.expectedChurchId,
    this.actualChurchId,
  });
}

// ============================================================
// FICHIERS & STOCKAGE
// ============================================================

/// Erreur de stockage de fichiers (upload, download, accès disque)
class StorageFailure extends Failure {
  final String? filePath;

  const StorageFailure(super.message,
      {super.code, super.stackTrace, this.filePath});
}

// ============================================================
// ERREUR INCONNUE (Catch-All)
// ============================================================

/// Erreur inattendue / non catégorisée
/// À utiliser UNIQUEMENT comme dernier recours dans un catch global.
class UnexpectedFailure extends Failure {
  final Object? originalError;

  const UnexpectedFailure(super.message,
      {super.code, super.stackTrace, this.originalError});

  /// Factory pour convertir une exception générique en Failure typée
  factory UnexpectedFailure.fromException(Object error, [StackTrace? trace]) {
    return UnexpectedFailure(
      error.toString(),
      stackTrace: trace,
      originalError: error,
    );
  }
}
