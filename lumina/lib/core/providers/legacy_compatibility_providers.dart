import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/domain/entities/user_context.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';
import '../../core/auth/domain/entities/enums/permission.dart';
import '../../core/auth/domain/entities/enums/role_level.dart';

// PermissionArgs is now imported from permission.dart

/// Provider for SuperAdmin check
final isSuperAdminProvider = Provider<bool>((ref) {
  final profile = ref.watch(profileStateProvider).valueOrNull;
  if (profile == null) {
    return false;
  }

  return profile.roleLevel == RoleLevel.superadmin.name ||
      profile.roleLevel == RoleLevel.adminTotal.name;
});

/// Provider for generic permission checks
final hasPermissionProvider =
    Provider.family<bool, Permission>((ref, permission) {
  final profile = ref.watch(profileStateProvider).valueOrNull;
  if (profile == null) {
    return false;
  }

  final level = RoleLevel.values.firstWhere(
    (l) => l.name == profile.roleLevel,
    orElse: () => RoleLevel.consultation,
  );

  // Basic implementation based on roleLevel
  if (level == RoleLevel.adminTotal || level == RoleLevel.superadmin) {
    return true;
  }

  // Logic mapping Permission to RoleLevel
  return _hasRolePermission(level, permission);
});

final hasAllPermissionsProvider =
    Provider.family<bool, Set<Permission>>((ref, permissions) {
  for (final permission in permissions) {
    if (!ref.watch(hasPermissionProvider(permission))) {
      return false;
    }
  }
  return true;
});

final hasAnyPermissionProvider =
    Provider.family<bool, Set<Permission>>((ref, permissions) {
  for (final permission in permissions) {
    if (ref.watch(hasPermissionProvider(permission))) {
      return true;
    }
  }
  return false;
});

final hasResourcePermissionProvider =
    Provider.family<bool, PermissionArgs>((ref, args) {
  final profile = ref.watch(profileStateProvider).valueOrNull;
  if (profile == null) {
    return false;
  }

  final level = RoleLevel.values.firstWhere(
    (l) => l.name == profile.roleLevel,
    orElse: () => RoleLevel.consultation,
  );

  if (level == RoleLevel.adminTotal || level == RoleLevel.superadmin) {
    return true;
  }

  // Basic resource-based check
  if (args.resource == 'finance_transaction' && level == RoleLevel.finance) {
    return true;
  }
  if (args.resource == 'member' && level == RoleLevel.staff) {
    return true;
  }

  return false;
});

bool _hasRolePermission(RoleLevel level, Permission permission) {
  if (level == RoleLevel.adminTotal || level == RoleLevel.superadmin) {
    return true;
  }

  if (level == RoleLevel.staff || level == RoleLevel.finance) {
    if (permission.resource == 'members' || permission.resource == 'finance') {
      return true;
    }
  }
  if (level == RoleLevel.consultation) {
    return permission.code.contains('view') || permission.code.contains('read');
  }
  return false;
}

/// Legacy UserContext provider to avoid breaking existing UI
final userContextNotifierProvider = Provider<AsyncValue<UserContext?>>((ref) {
  final profileAsync = ref.watch(profileStateProvider);

  return profileAsync.whenData((profileData) {
    final profile = profileData;
    if (profile == null) return null;

    final level = RoleLevel.values.firstWhere(
      (l) => l.name == profile.roleLevel,
      orElse: () => RoleLevel.consultation,
    );

    return UserContext(
      user: UserInfo(
        id: profile.id,
        email: profile.email ?? '',
        name: profile.displayName,
        avatar: profile.avatarUrl,
      ),
      role: RoleInfo(
        code: profile.roleLevel,
        label: level.label,
        isSuper: level == RoleLevel.superadmin || level == RoleLevel.adminTotal,
        level: level,
      ),
      group: profile.groupId == null
          ? null
          : GroupInfo(
              code: profile.groupId!,
              label: profile.groupId!,
            ),
      permissions: const {}, // Mapping complex permissions can be done if needed
      generatedAt: DateTime.now(),
      churchId: profile.churchId,
    );
  });
});
