import 'package:freezed_annotation/freezed_annotation.dart';

part 'rbac_models.freezed.dart';
part 'rbac_models.g.dart';

@freezed
class Permission with _$Permission {
  const factory Permission({
    required String id,
    required String code,
    required String label,
    String? description,
    required String module,
    required String category, // read, write, etc.
    @Default(false) bool isSensitive,
  }) = _Permission;

  factory Permission.fromJson(Map<String, dynamic> json) =>
      _$PermissionFromJson(json);
}

@freezed
class Role with _$Role {
  const factory Role({
    required String id,
    required String code,
    required String label,
    @Default(false) bool isSuper,
    @Default(0) int priorityLevel,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}

@freezed
class RoleWithPermissions with _$RoleWithPermissions {
  const factory RoleWithPermissions({
    required Role role,
    required List<String> permissionCodes,
  }) = _RoleWithPermissions;
}