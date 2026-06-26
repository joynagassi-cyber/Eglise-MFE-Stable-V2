import 'package:isar/isar.dart';
import '../../domain/entities/permanent_prayer_subject.dart';

part 'permanent_prayer_subject_model.g.dart';

@collection
class PermanentPrayerSubjectModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String churchId;

  @Index()
  late String groupId;

  late String category;
  late String subject;
  String? description;
  late bool isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  PermanentPrayerSubject toDomain() {
    return PermanentPrayerSubject(
      id: id,
      churchId: churchId,
      groupId: groupId,
      category: category,
      subject: subject,
      description: description,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static PermanentPrayerSubjectModel fromDomain(PermanentPrayerSubject entity) {
    return PermanentPrayerSubjectModel()
      ..id = entity.id
      ..churchId = entity.churchId
      ..groupId = entity.groupId
      ..category = entity.category
      ..subject = entity.subject
      ..description = entity.description
      ..isActive = entity.isActive
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt;
  }
}