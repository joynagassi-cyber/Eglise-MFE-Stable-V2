import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:lumina/core/logging/app_logger.dart';
import '../../domain/entities/member.dart';
import '../../domain/entities/enums/enums.dart';

part 'member_model.g.dart';

@collection
class MemberModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id; // UUID principal

  @Index()
  String? churchId;

  @Index()
  String? userId; // UUID principal de l'utilisateur Auth

  @Index(caseSensitive: false)
  String? firstName;

  @Index(caseSensitive: false, composite: [CompositeIndex('status')])
  String? lastName;

  @Enumerated(EnumType.name)
  late Gender gender;

  @Enumerated(EnumType.name)
  late MemberStatus status;

  String? photoUrl;

  DateTime? birthDate;
  String? phone;
  String? email;
  String? city;

  @Enumerated(EnumType.name)
  late ChurchRoleType
      primaryRole; // Stocké directement pour les requêtes rapides

  bool? isLeader;
  bool? isBaptized;
  bool? hasCompletedMembershipClass;
  bool? hasCompletedMaturityClass;

  // Stockage des objets complexes en JSON pour simplifier
  // Isar supporte les objets embedded, mais pour ~180 champs, le JSON est plus flexible pour la synchro
  String? jsonData;

  DateTime? updatedAt;
  DateTime? lastSyncedAt;

  int version = 1;
  String deviceId = 'unknown';
  String createdBy = 'unknown';
  String updatedBy = 'unknown';

  bool isDeleted = false;
  DateTime? deletedAt;
  String? deletedBy;

  bool isSynced = true; // Si false, doit être envoyé au backend
  
  /// Convertir Data (Isar) -> Domain
  Member toDomain() {
    if (jsonData != null) {
      try {
        return Member.fromJson(jsonDecode(jsonData!));
      } catch (e, st) {
        AppLogger.e('Erreur parsing jsonData pour Member', 'MemberModel', e, st);
        // Fallback si JSON corrompu ou incomplet
      }
    }

    return Member(
      id: id,
      userId: userId,
      churchId: churchId ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      gender: gender,
      status: status,
      photoUrl: photoUrl,
      birthDate: birthDate,
      email: email,
      city: city,
      primaryRoleType: primaryRole.name,
      isLeader: isLeader ?? false,
      isBaptized: isBaptized ?? false,
      hasCompletedMembershipClass: hasCompletedMembershipClass ?? false,
      hasCompletedMaturityClass: hasCompletedMaturityClass ?? false,
    );
  }

  /// Convertir Domain -> Data (Isar)
  static MemberModel fromDomain(Member member) {
    return MemberModel()
          ..id = member.id
          ..userId = member.userId
          ..churchId = member.churchId
          ..firstName = member.firstName
          ..lastName = member.lastName
          ..gender = member.gender
          ..status = member.status
          ..photoUrl = member.photoUrl
          ..birthDate = member.birthDate
          ..phone = member.primaryPhone
          ..email = member.email ?? ''
          ..city = member.city
          ..primaryRole = member.primaryRole
          ..isLeader = member.isLeader
          ..isBaptized = member.isBaptized
          ..hasCompletedMembershipClass = member.hasCompletedMembershipClass
          ..hasCompletedMaturityClass = member.hasCompletedMaturityClass
          ..updatedAt = member.updatedAt ?? DateTime.now()
          ..jsonData = jsonEncode(member.toJson());
  }
}
