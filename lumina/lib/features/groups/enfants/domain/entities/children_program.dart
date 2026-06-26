// lib/features/groups/enfants/domain/entities/children_program.dart

class ChildrenProgram {
  final String id;
  final String name;
  final String description;
  final String ageGroup;
  final int minAge;
  final int maxAge;
  final int enrolledCount;
  final String schedule;
  final String status;
  final String groupId;
  final String churchId;

  const ChildrenProgram({
    required this.id,
    required this.name,
    required this.description,
    required this.ageGroup,
    required this.minAge,
    required this.maxAge,
    required this.enrolledCount,
    required this.schedule,
    required this.status,
    required this.groupId,
    required this.churchId,
  });

  factory ChildrenProgram.fromJson(Map<String, dynamic> json) {
    return ChildrenProgram(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      ageGroup: json['age_group'] as String,
      minAge: json['min_age'] as int,
      maxAge: json['max_age'] as int,
      enrolledCount: json['enrolled_count'] as int,
      schedule: json['schedule'] as String,
      status: json['status'] as String,
      groupId: json['group_id'] as String,
      churchId: json['church_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'age_group': ageGroup,
      'min_age': minAge,
      'max_age': maxAge,
      'enrolled_count': enrolledCount,
      'schedule': schedule,
      'status': status,
      'group_id': groupId,
      'church_id': churchId,
    };
  }
}