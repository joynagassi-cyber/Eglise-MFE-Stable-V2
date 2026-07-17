import 'package:isar/isar.dart';

part 'local_session_model.g.dart';

/// Modele de session locale persiste dans Isar.
/// Contient les informations essentielles pour reconstruire l'etat auth
/// meme si Supabase est injoignable.
@collection
class LocalSessionModel {
  LocalSessionModel();

  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String userId;

  late String email;
  late String? name;
  late String? accessToken;
  late String? refreshToken;
  late String? activeChurchId;
  late String? roleCode;
  late String? roleLabel;
  late int roleHierarchyLevel;
  late bool needsOnboarding;
  late DateTime? lastLoginAt;
  late DateTime updatedAt;

  /// Copie depuis un UserSession (auth_provider)
  factory LocalSessionModel.fromMap(Map<String, dynamic> map) {
    return LocalSessionModel()
      ..userId = map['userId'] ?? ''
      ..email = map['email'] ?? ''
      ..name = map['name']
      ..accessToken = map['accessToken']
      ..refreshToken = map['refreshToken']
      ..activeChurchId = map['activeChurchId']
      ..roleCode = map['roleCode']
      ..roleLabel = map['roleLabel']
      ..roleHierarchyLevel = map['roleHierarchyLevel'] ?? 0
      ..needsOnboarding = map['needsOnboarding'] ?? false
      ..lastLoginAt = map['lastLoginAt'] != null
          ? DateTime.tryParse(map['lastLoginAt'])
          : null
      ..updatedAt = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'activeChurchId': activeChurchId,
      'roleCode': roleCode,
      'roleLabel': roleLabel,
      'roleHierarchyLevel': roleHierarchyLevel,
      'needsOnboarding': needsOnboarding,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
