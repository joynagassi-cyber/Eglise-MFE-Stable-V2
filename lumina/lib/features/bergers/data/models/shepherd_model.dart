import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/shepherd.dart';

part 'shepherd_model.g.dart';

@collection
class ShepherdModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String churchId;

  @Index()
  late String memberId;

  String? firstName;
  String? lastName;
  String? photoUrl;

  late String level;
  List<String> specialties = [];
  List<String> supervisedGroupIds = [];

  String? bio;
  DateTime? ordainedAt;

  DateTime? createdAt;
  DateTime? updatedAt;

  DateTime? lastSyncedAt;

  String? jsonData;

  static ShepherdModel fromDomain(Shepherd shepherd) {
    return ShepherdModel()
      ..id = shepherd.id
      ..churchId = shepherd.churchId
      ..memberId = shepherd.memberId
      ..firstName = shepherd.firstName
      ..lastName = shepherd.lastName
      ..photoUrl = shepherd.photoUrl
      ..level = shepherd.level
      ..specialties = shepherd.specialties
      ..supervisedGroupIds = shepherd.supervisedGroupIds
      ..bio = shepherd.bio
      ..ordainedAt = shepherd.ordainedAt
      ..createdAt = shepherd.createdAt
      ..updatedAt = shepherd.updatedAt
      ..jsonData = jsonEncode(shepherd.toJson());
  }

  Shepherd toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return Shepherd.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return Shepherd(
      id: id,
      churchId: churchId,
      memberId: memberId,
      firstName: firstName,
      lastName: lastName,
      photoUrl: photoUrl,
      level: level,
      specialties: specialties,
      supervisedGroupIds: supervisedGroupIds,
      bio: bio,
      ordainedAt: ordainedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}