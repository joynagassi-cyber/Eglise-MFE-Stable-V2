import 'package:isar/isar.dart';
import '../../domain/entities/prayer_vigil.dart';

part 'prayer_vigil_model.g.dart';

@collection
class PrayerVigilModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String churchId;

  @Index()
  late String groupId;

  String? eventId;
  late String title;
  String? description;
  late DateTime startTime;
  late DateTime endTime;
  late int participantsCount;
  late String status;
  DateTime? createdAt;
  DateTime? updatedAt;

  PrayerVigil toDomain() {
    return PrayerVigil(
      id: id,
      churchId: churchId,
      groupId: groupId,
      eventId: eventId,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      participantsCount: participantsCount,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static PrayerVigilModel fromDomain(PrayerVigil entity) {
    return PrayerVigilModel()
      ..id = entity.id
      ..churchId = entity.churchId
      ..groupId = entity.groupId
      ..eventId = entity.eventId
      ..title = entity.title
      ..description = entity.description
      ..startTime = entity.startTime
      ..endTime = entity.endTime
      ..participantsCount = entity.participantsCount
      ..status = entity.status
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt;
  }
}