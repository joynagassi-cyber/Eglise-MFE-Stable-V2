import 'package:isar/isar.dart';
import '../../domain/entities/children_program.dart';

part 'children_program_model.g.dart';

@collection
class ChildrenProgramModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String churchId;

  late String name;
  late String description;
  late String ageGroup;
  late int minAge;
  late int maxAge;
  late int enrolledCount;
  late String schedule;
  late String status;
  late String groupId;

  ChildrenProgram toDomain() {
    return ChildrenProgram(
      id: id,
      name: name,
      description: description,
      ageGroup: ageGroup,
      minAge: minAge,
      maxAge: maxAge,
      enrolledCount: enrolledCount,
      schedule: schedule,
      status: status,
      groupId: groupId,
      churchId: churchId,
    );
  }

  static ChildrenProgramModel fromDomain(ChildrenProgram entity) {
    return ChildrenProgramModel()
      ..id = entity.id
      ..name = entity.name
      ..description = entity.description
      ..ageGroup = entity.ageGroup
      ..minAge = entity.minAge
      ..maxAge = entity.maxAge
      ..enrolledCount = entity.enrolledCount
      ..schedule = entity.schedule
      ..status = entity.status
      ..groupId = entity.groupId
      ..churchId = entity.churchId;
  }
}