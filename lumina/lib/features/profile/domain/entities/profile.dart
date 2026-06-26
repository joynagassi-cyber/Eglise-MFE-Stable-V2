import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const Profile._();

  const factory Profile({
    required String id,
    String? firstName,
    String? lastName,
    String? fullName,
    String? avatarUrl,
    String? email,
    @Default('visitor') String roleLevel,
    @Default(true) bool needsOnboarding,
    String? groupId,
    String? churchId,
    DateTime? onboardingCompletedAt,
    DateTime? lastSignInAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  /// Nom complet calculé: firstName + lastName, ou fullName, ou fallback.
  String? get computedFullName {
    if ((firstName?.isNotEmpty ?? false) && (lastName?.isNotEmpty ?? false)) {
      return '${firstName!} ${lastName!}'.trim();
    }
    if (fullName?.isNotEmpty ?? false) return fullName;
    return firstName?.isNotEmpty == true ? firstName : lastName;
  }

  /// Nom affiché dans l'UI : nom complet > email > fallback.
  String get displayName => computedFullName ?? email ?? 'Utilisateur';

  /// FIX #6 — Initiales sans crash sur chaîne vide.
  /// Checks isNotEmpty (not just non-null) before indexing [0].
  String get initials {
    // Cas 1 : firstName ET lastName non-vides
    if ((firstName?.isNotEmpty ?? false) && (lastName?.isNotEmpty ?? false)) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    }

    // Cas 2 : fullName calculé
    final computed = computedFullName?.trim() ?? '';
    if (computed.isNotEmpty) {
      return computed[0].toUpperCase();
    }

    // Cas 3 : préfixe email
    final emailPrefix = email?.split('@').first ?? '';
    if (emailPrefix.isNotEmpty) {
      return emailPrefix[0].toUpperCase();
    }

    // Fallback ultime
    return '?';
  }
}