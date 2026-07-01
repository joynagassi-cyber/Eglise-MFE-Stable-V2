// lib/core/errors/failures.dart
// Système de Failures Scellées (Sealed) — UNIFIED
//
// Hiérarchie exhaustive des erreurs pour l'application Lumina.
// Chaque Failure est typée et documentée pour garantir un traitement
// exhaustif via pattern matching (switch).
//
// RÈGLE : Tout catch dans le domaine DOIT retourner une sous-classe
// de Failure. Jamais d'exceptions nues.

import 'package:flutter/foundation.dart';

/// Classe de base scellée pour toutes les erreurs métier.
///
/// Le mot-clé `sealed` garantit l'exhaustivité du pattern matching :
/// le compilateur sait que toutes les sous-classes sont dans ce fichier
/// et prévient si un `switch` oublie un cas.
@immutable
sealed class Failure {
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
final class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message,
      {super.code, super.stackTrace, this.statusCode});
}

/// Erreur de connectivité réseau (pas de connexion, timeout DNS, etc.)
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code, super.stackTrace});
}

/// Erreur de timeout sur une opération réseau ou locale
final class TimeoutFailure extends Failure {
  final Duration? duration;

  const TimeoutFailure(super.message,
      {super.code, super.stackTrace, this.duration});
}

// ============================================================
// AUTHENTIFICATION & PERMISSIONS
// ============================================================

/// Erreur d'authentification (login, token expiré, session invalide)
final class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code, super.stackTrace});
}

/// Erreur de permission (accès refusé à une ressource protégée)
final class PermissionFailure extends Failure {
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
final class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code, super.stackTrace});
}

/// Erreur de synchronisation (file d'attente, conflit de données)
final class SyncFailure extends Failure {
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
final class ConflictFailure extends Failure {
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
// SÉCURITÉ MULTI-TENANT
// ============================================================

/// Erreur de sécurité (Multi-tenant, accès inter-églises)
final class SecurityFailure extends Failure {
  const SecurityFailure(super.message, {super.code, super.stackTrace});
}

// ============================================================
// VALIDATION & LOGIQUE MÉTIER
// ============================================================

/// Erreur de validation des données d'entrée
final class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure(super.message,
      {super.code, super.stackTrace, this.fieldErrors});
}

/// Erreur de logique métier (règle métier violée, état incohérent)
final class BusinessRuleFailure extends Failure {
  final String? ruleId;

  const BusinessRuleFailure(super.message,
      {super.code, super.stackTrace, this.ruleId});
}

// ============================================================
// CONTEXTE MULTI-ÉGLISE
// ============================================================

/// Erreur de contexte d'église (aucune église active, switch incomplet)
final class ChurchContextFailure extends Failure {
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
final class StorageFailure extends Failure {
  final String? filePath;

  const StorageFailure(super.message,
      {super.code, super.stackTrace, this.filePath});
}

// ============================================================
// ERREUR INCONNUE (Catch-All)
// ============================================================

/// Erreur inattendue / non catégorisée
/// À utiliser UNIQUEMENT comme dernier recours dans un catch global.
final class UnexpectedFailure extends Failure {
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
