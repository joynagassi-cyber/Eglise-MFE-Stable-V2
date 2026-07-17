import 'package:isar/isar.dart';

part 'local_user_context_model.g.dart';

/// Modele de contexte utilisateur local persiste dans Isar.
/// Contient le role, les permissions et le groupe pour fonctionnement offline.
@collection
class LocalUserContextModel {
  LocalUserContextModel();

  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String userId;

  late String roleCode;
  late String roleLabel;
  late int roleHierarchyLevel;
  late bool isSuper;
  late bool needsOnboarding;
  late String? churchId;
  late String? groupId;
  late String? initialRoute;
  late DateTime updatedAt;

  factory LocalUserContextModel.fromMap(Map<String, dynamic> map) {
    return LocalUserContextModel()
      ..userId = map['userId'] ?? ''
      ..roleCode = map['roleCode'] ?? 'membre'
      ..roleLabel = map['roleLabel'] ?? 'Membre'
      ..roleHierarchyLevel = map['roleHierarchyLevel'] ?? 0
      ..isSuper = map['isSuper'] ?? false
      ..needsOnboarding = map['needsOnboarding'] ?? false
      ..churchId = map['churchId']
      ..groupId = map['groupId']
      ..initialRoute = map['initialRoute'] ?? '/dashboard'
      ..updatedAt = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'roleCode': roleCode,
      'roleLabel': roleLabel,
      'roleHierarchyLevel': roleHierarchyLevel,
      'isSuper': isSuper,
      'needsOnboarding': needsOnboarding,
      'churchId': churchId,
      'groupId': groupId,
      'initialRoute': initialRoute,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
