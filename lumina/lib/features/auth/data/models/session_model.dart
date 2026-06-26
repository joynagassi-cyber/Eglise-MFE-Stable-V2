import 'dart:convert';
import 'package:isar/isar.dart';
import '../../../../core/auth/domain/entities/user_session.dart';
import '../../../../core/auth/domain/entities/church_role.dart';

part 'session_model.g.dart';

/// Modèle Isar pour la persistence des sessions utilisateur
///
/// Stocke la session active de manière sécurisée localement.
/// Note : Les tokens sensibles sont stockés dans flutter_secure_storage,
/// ce modèle contient uniquement les métadonnées.
@collection
class SessionModel {
  SessionModel();

  /// ID auto-incrémenté pour Isar
  Id isarId = Isar.autoIncrement;

  /// Identifiant unique de l'utilisateur
  @Index(unique: true)
  late String userId;

  /// Email de l'utilisateur
  late String email;

  /// Nom complet
  late String name;

  /// Photo de profil (URL ou base64)
  String? avatar;

  /// Église active
  @Index()
  late String activeChurchId;

  /// Liste des églises accessibles (stockées en JSON string)
  late String accessibleChurchIdsJson;

  /// Données du rôle (stockées en JSON string)
  late String roleJson;

  /// Date d'expiration du token
  late DateTime tokenExpiresAt;

  /// Date de dernière connexion
  late DateTime lastLoginAt;

  /// Session active
  late bool isActive;

  /// Besoin d'onboarding
  late bool needsOnboarding;

  /// Métadonnées (stockées en JSON string)
  String? metadataJson;

  /// Date de création de la session
  late DateTime createdAt;

  /// Timestamp de dernière synchronisation avec Supabase
  DateTime? lastSyncedAt;

  /// Vérifie si le cache est obsolète (>5min)
  bool get isStale {
    if (lastSyncedAt == null) return true;
    return DateTime.now().difference(lastSyncedAt!) >
        const Duration(minutes: 5);
  }

  // ============================================
  // CONVERSION DOMAIN <-> MODEL
  // ============================================

  /// Crée un modèle Isar à partir d'une session domain
  ///
  /// Note : Les tokens ne sont PAS stockés dans Isar,
  /// ils sont gérés par flutter_secure_storage
  factory SessionModel.fromDomain(UserSession session) {
    return SessionModel()
      ..userId = session.userId
      ..email = session.email
      ..name = session.name
      ..avatar = session.avatar
      ..activeChurchId = session.activeChurchId
      ..accessibleChurchIdsJson = session.accessibleChurchIds.join(',')
      ..roleJson = jsonEncode(session.role.toJson())
      ..tokenExpiresAt = session.tokenExpiresAt
      ..lastLoginAt = session.lastLoginAt
      ..isActive = session.isActive
      ..needsOnboarding = session.needsOnboarding
      ..metadataJson =
          session.metadata != null ? jsonEncode(session.metadata) : null
      ..createdAt = DateTime.now()
      ..lastSyncedAt = DateTime.now(); // Marquer comme syncé
  }

  /// Convertit le modèle Isar en session domain
  ///
  /// [accessToken] et [refreshToken] doivent être fournis
  /// car ils ne sont pas stockés dans Isar (sécurité)
  UserSession toDomain({
    required String accessToken,
    required String refreshToken,
  }) {
    // Parser accessibleChurchIds
    final churchIds = accessibleChurchIdsJson
        .split(',')
        .where((id) => id.isNotEmpty)
        .toList();

    // Parser role
    final role = ChurchRole.fromJson(jsonDecode(roleJson));

    // Parser metadata
    final metadata = metadataJson != null
        ? jsonDecode(metadataJson!) as Map<String, dynamic>
        : null;

    return UserSession(
      userId: userId,
      email: email,
      name: name,
      avatar: avatar,
      activeChurchId: activeChurchId,
      accessibleChurchIds: churchIds,
      role: role,
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenExpiresAt: tokenExpiresAt,
      lastLoginAt: lastLoginAt,
      isActive: isActive,
      needsOnboarding: needsOnboarding,
      metadata: metadata,
    );
  }

  // ============================================
  // MÉTADONNÉES — Watermarks de synchronisation
  // ============================================

  /// Lit une valeur depuis le champ metadataJson.
  ///
  /// Utilisé pour stocker les watermarks de synchronisation (lastSyncedAt par table).
  String? getMetadata(String key) {
    if (metadataJson == null || metadataJson!.isEmpty) return null;
    try {
      final map = jsonDecode(metadataJson!) as Map<String, dynamic>;
      return map[key]?.toString();
    } catch (_) {
      return null;
    }
  }

  /// Écrit une valeur dans le champ metadataJson.
  ///
  /// Note : l'objet doit être sauvegardé dans Isar après cet appel.
  void setMetadata(String key, String value) {
    Map<String, dynamic> map = {};
    if (metadataJson != null && metadataJson!.isNotEmpty) {
      try {
        map = jsonDecode(metadataJson!) as Map<String, dynamic>;
      } catch (_) {
        map = {};
      }
    }
    map[key] = value;
    metadataJson = jsonEncode(map);
  }
}