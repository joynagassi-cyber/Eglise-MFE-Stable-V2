import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/mentorship_pair.dart';

part 'mentorship_pair_model.g.dart';

@collection
class MentorshipPairModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String groupId;

  @Index()
  late String churchId;

  @Index()
  late String mentorId;

  @Index()
  late String menteeId;

  @enumerated
  late MentorshipStatus status;

  DateTime? nextSessionAt;
  DateTime? lastSessionAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  bool isDeleted = false;
  DateTime? lastSyncedAt;
  String? jsonData;

  static MentorshipPairModel fromDomain(MentorshipPair pair) {
    return MentorshipPairModel()
      ..id = pair.id
      ..churchId = pair.churchId
      ..groupId = pair.groupId
      ..mentorId = pair.mentorId
      ..menteeId = pair.menteeId
      ..status = pair.status
      ..nextSessionAt = pair.nextSessionAt
      ..lastSessionAt = pair.lastSessionAt
      ..createdAt = pair.createdAt
      ..updatedAt = pair.updatedAt
      ..lastSyncedAt = DateTime.now()
      ..jsonData = jsonEncode(pair.toJson());
  }

  MentorshipPair toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return MentorshipPair.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return MentorshipPair(
      id: id,
      churchId: churchId,
      groupId: groupId,
      mentorId: mentorId,
      menteeId: menteeId,
      status: status,
      nextSessionAt: nextSessionAt,
      lastSessionAt: lastSessionAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}