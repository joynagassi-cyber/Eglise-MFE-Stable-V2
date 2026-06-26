import 'package:equatable/equatable.dart';

class UserRole extends Equatable {
  final String roleId;
  final String roleCode;
  final String roleLabel;
  final String? groupId;
  final String? groupCode;
  final String? groupLabel;
  final bool isSuper;
  final int priorityLevel;

  const UserRole({
    required this.roleId,
    required this.roleCode,
    required this.roleLabel,
    this.groupId,
    this.groupCode,
    this.groupLabel,
    this.isSuper = false,
    this.priorityLevel = 100,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      roleId: json['role_id'] as String,
      roleCode: json['roles']?['code'] as String? ?? '',
      roleLabel: json['roles']?['label'] as String? ?? '',
      groupId: json['group_id'] as String?,
      groupCode: json['groups']?['code'] as String?,
      groupLabel: json['groups']?['label'] as String?,
      isSuper: json['roles']?['is_super'] as bool? ?? false,
      priorityLevel: json['roles']?['priority_level'] as int? ?? 100,
    );
  }

  @override
  List<Object?> get props => [
        roleId,
        roleCode,
        groupId,
        isSuper,
        priorityLevel,
      ];
}
