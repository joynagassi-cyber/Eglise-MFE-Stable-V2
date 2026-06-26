import 'package:equatable/equatable.dart';
import 'enums/role_level.dart';

String? _firstNonEmptyString(Iterable<Object?> values) {
  for (final value in values) {
    if (value == null) continue;
    final text = value.toString().trim();
    if (text.isNotEmpty) return text;
  }
  return null;
}

class UserContext extends Equatable {
  final UserInfo user;
  final RoleInfo role;
  final GroupInfo? group;
  final Map<String, Map<String, String>> permissions;
  final DateTime generatedAt;
  final bool needsOnboarding;
  final String? churchId;

  const UserContext({
    required this.user,
    required this.role,
    this.group,
    required this.permissions,
    required this.generatedAt,
    this.needsOnboarding = false,
    this.churchId,
  });

  /// Alias for the current group code/id
  String? get activeGroupId => group?.code;

  /// Alias for the current church id
  String? get activeChurchId => churchId;

  bool get isSuperAdmin => role.isSuper;

  bool hasPermission(String resource, String action) {
    final resourcePerms = permissions[resource];
    if (resourcePerms == null) return false;

    final scope = resourcePerms[action];
    return scope != null && scope != 'none';
  }

  String? getPermissionScope(String resource, String action) {
    return permissions[resource]?[action];
  }

  factory UserContext.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    final roleJson = json['role'] as Map<String, dynamic>;
    final groupJson = json['group'] as Map<String, dynamic>?;
    final permsJson = json['permissions'] as Map<String, dynamic>? ?? {};
    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final churchId = _firstNonEmptyString([
      metaJson['church_id'],
      metaJson['active_church_id'],
      json['church_id'],
      json['active_church_id'],
      userJson['church_id'],
      userJson['active_church_id'],
    ]);

    return UserContext(
      user: UserInfo(
        id: userJson['id'] as String,
        email: userJson['email'] as String,
        memberId: userJson['member_id'] as String?,
        name: userJson['name'] as String? ?? '',
        avatar: userJson['avatar'] as String?,
      ),
      role: RoleInfo(
        code: roleJson['code'] as String,
        label: roleJson['label'] as String,
        isSuper: roleJson['is_super'] as bool? ?? false,
        level: RoleLevel.values.firstWhere(
          (l) => l.name == (roleJson['level'] as String? ?? 'consultation'),
          orElse: () => RoleLevel.consultation,
        ),
        initialRoute: roleJson['initial_route'] as String?,
        permissions: permsJson.map(
          (k, v) => MapEntry(k, Map<String, String>.from(v as Map)),
        ),
      ),
      group: groupJson != null
          ? GroupInfo(
              code: groupJson['code'] as String,
              label: groupJson['label'] as String,
            )
          : null,
      permissions: permsJson.map(
        (k, v) => MapEntry(k, Map<String, String>.from(v as Map)),
      ),
      generatedAt:
          DateTime.tryParse(metaJson['generated_at'] as String? ?? '') ??
              DateTime.now(),
      needsOnboarding: metaJson['needs_onboarding'] as bool? ?? false,
      churchId: churchId,
    );
  }

  @override
  List<Object?> get props => [
        user.id,
        role.code,
        group?.code,
        permissions,
        churchId,
      ];
}

class UserInfo extends Equatable {
  final String id;
  final String email;
  final String? memberId;
  final String name;
  final String? avatar;

  const UserInfo({
    required this.id,
    required this.email,
    this.memberId,
    this.name = '',
    this.avatar,
  });

  /// Alias for id (used in some contexts as userId)
  String get userId => id;

  @override
  List<Object?> get props => [id, email, memberId, name, avatar];
}

class RoleInfo extends Equatable {
  final String code;
  final String label;
  final bool isSuper;
  final RoleLevel level;
  final String? initialRoute;
  final Map<String, Map<String, String>> permissions;

  const RoleInfo({
    required this.code,
    required this.label,
    required this.isSuper,
    required this.level,
    this.initialRoute,
    this.permissions = const {},
  });

  /// Alias for code (used in some contexts as id)
  String get id => code;
  String get name => label;
  String get roleId => code;

  bool get isAdminTotal => code == 'admin_total';
  bool get isStaff => code == 'staff' || code == 'admin_staff';
  bool get isLeader => code == 'chef_groupe' || code == 'leader';
  bool get isCoLeader => code == 'co_chef_groupe' || code == 'co_leader';

  @override
  List<Object?> get props => [code, label, isSuper, level, initialRoute, permissions];
}

class GroupInfo extends Equatable {
  final String code;
  final String label;

  const GroupInfo({required this.code, required this.label});

  /// Alias for code (used in some contexts as id)
  String get id => code;

  @override
  List<Object?> get props => [code, label];
}
