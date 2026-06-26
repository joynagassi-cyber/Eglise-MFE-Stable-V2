import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lumina/features/auth/domain/models/auth_user.dart';
import 'enums/permission.dart';
import 'enums/role_level.dart';
import 'church_role.dart';

part 'user_session.freezed.dart';
part 'user_session.g.dart';

/// Représente une session utilisateur authentifiée
///
/// Contient toutes les informations nécessaires pour :
/// - Identifier l'utilisateur
/// - Gérer ses permissions via son rôle
/// - Gérer le contexte multi-église
/// - Auto-refresh du token JWT avant expiration
@freezed
class UserSession with _$UserSession {
  const UserSession._();

  /// Obtient un objet AppAuthUser pour compatibilité legacy
  AppAuthUser get user => AppAuthUser(
        id: userId,
        email: email,
        firstName: name.split(' ').first,
        lastName:
            name.contains(' ') ? name.split(' ').sublist(1).join(' ') : '',
      );

  const factory UserSession({
    /// Identifiant unique de l'utilisateur
    required String userId,

    /// Email de l'utilisateur
    required String email,

    /// Nom complet de l'utilisateur
    required String name,

    /// Photo de profil (URL ou base64)
    String? avatar,

    /// Identifiant de l'église active (contexte multi-église)
    required String activeChurchId,

    /// Liste des églises auxquelles l'utilisateur a accès
    required List<String> accessibleChurchIds,

    /// Rôle de l'utilisateur dans l'église active
    required ChurchRole role,

    /// Token JWT d'authentification
    required String accessToken,

    /// Token pour rafraîchir le JWT
    required String refreshToken,

    /// Date d'expiration du token d'accès
    required DateTime tokenExpiresAt,

    /// Date de dernière connexion
    required DateTime lastLoginAt,

    /// Indique si la session est active
    @Default(true) bool isActive,

    /// Indique si l'utilisateur doit compléter son onboarding (choix rôle/église)
    @Default(false) bool needsOnboarding,

    /// Métadonnées supplémentaires (device info, etc.)
    Map<String, dynamic>? metadata,
  }) = _UserSession;

  factory UserSession.fromJson(Map<String, dynamic> json) =>
      _$UserSessionFromJson(json);

  // ============================================
  // MÉTHODES UTILITAIRES
  // ============================================

  /// Vérifie si le token est expiré
  bool get isTokenExpired {
    return DateTime.now().isAfter(tokenExpiresAt);
  }

  /// Vérifie si le token expire bientôt (dans les 5 prochaines minutes)
  bool get isTokenExpiringSoon {
    final threshold = DateTime.now().add(const Duration(minutes: 5));
    return tokenExpiresAt.isBefore(threshold);
  }

  /// Obtient le temps restant avant expiration (en secondes)
  int get secondsUntilExpiration {
    final diff = tokenExpiresAt.difference(DateTime.now());
    return diff.inSeconds > 0 ? diff.inSeconds : 0;
  }

  /// Vérifie si la session est valide (active + token non expiré)
  bool get isValid {
    return isActive && !isTokenExpired;
  }

  /// Vérifie si l'utilisateur a accès à une église spécifique
  bool hasAccessToChurch(String churchId) {
    if (isSuperAdmin) return true;
    return accessibleChurchIds.contains(churchId);
  }

  /// Vérifie si l'utilisateur peut changer d'église
  bool get canSwitchChurch {
    return accessibleChurchIds.length > 1;
  }

  /// Obtient le nombre d'églises accessibles
  int get accessibleChurchCount {
    return accessibleChurchIds.length;
  }

  /// Crée une nouvelle session avec un token rafraîchi
  UserSession refreshWithNewToken({
    required String newAccessToken,
    required String newRefreshToken,
    required DateTime newExpiresAt,
  }) {
    return copyWith(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
      tokenExpiresAt: newExpiresAt,
    );
  }

  /// Change l'église active
  UserSession switchChurch({
    required String newChurchId,
    required ChurchRole newRole,
  }) {
    if (!hasAccessToChurch(newChurchId)) {
      throw Exception('Accès refusé à cette église');
    }

    return copyWith(activeChurchId: newChurchId, role: newRole);
  }

  // Marque la session comme inactive
  UserSession deactivate() {
    return copyWith(isActive: false);
  }

  // ============================================
  // GESTION DES PERMISSIONS
  // ============================================

  /// Délègue au rôle pour vérifier une permission
  bool hasPermission(Permission permission) {
    return role.hasPermission(permission);
  }

  /// Délègue au rôle pour vérifier plusieurs permissions (toutes requises)
  bool hasAllPermissions(Set<Permission> permissions) {
    return role.hasAllPermissions(permissions);
  }

  /// Délègue au rôle pour vérifier plusieurs permissions (au moins une)
  bool hasAnyPermission(Set<Permission> permissions) {
    return role.hasAnyPermission(permissions);
  }

  /// Obtient le niveau hiérarchique du rôle
  int get hierarchyLevel {
    return role.level.hierarchyLevel;
  }

  /// Vérifie si l'utilisateur est administrateur (église)
  bool get isAdmin {
    return role.level == RoleLevel.adminTotal ||
        role.level == RoleLevel.superadmin;
  }

  /// Vérifie si l'utilisateur est super-administrateur (système)
  bool get isSuperAdmin {
    return role.level == RoleLevel.superadmin;
  }
}
