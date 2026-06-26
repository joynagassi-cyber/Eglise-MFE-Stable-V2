import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/child_safety_card.dart';

part 'child_safety_card_model.g.dart';

@collection
class ChildSafetyCardModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String churchId;

  late String memberId;
  String? medicalInfoJson;
  String? emergencyContact;
  late List<String> allergies;
  String? bloodType;
  DateTime? lastCheckIn;
  bool isActive = true;
  late DateTime createdAt;
  late DateTime updatedAt;

  ChildSafetyCard toDomain() {
    return ChildSafetyCard(
      id: id,
      churchId: churchId,
      memberId: memberId,
      medicalInfo: medicalInfoJson != null ? jsonDecode(medicalInfoJson!) : {},
      emergencyContact: emergencyContact,
      allergies: allergies,
      bloodType: bloodType,
      lastCheckIn: lastCheckIn,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static ChildSafetyCardModel fromDomain(ChildSafetyCard entity) {
    return ChildSafetyCardModel()
      ..id = entity.id
      ..churchId = entity.churchId
      ..memberId = entity.memberId
      ..medicalInfoJson = jsonEncode(entity.medicalInfo)
      ..emergencyContact = entity.emergencyContact
      ..allergies = entity.allergies
      ..bloodType = entity.bloodType
      ..lastCheckIn = entity.lastCheckIn
      ..isActive = entity.isActive
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt;
  }
}