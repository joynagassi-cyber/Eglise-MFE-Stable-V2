import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../providers/legacy_compatibility_providers.dart';
import '../auth/domain/entities/enums/role_level.dart';

enum DashboardType {
  superadmin,
  group,
  member,
}

class DashboardSwitcher extends ConsumerWidget {
  final DashboardType currentType;
  final Function(DashboardType)? onSwitch;

  const DashboardSwitcher({
    super.key,
    required this.currentType,
    this.onSwitch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userContextAsync = ref.watch(userContextNotifierProvider);

    return userContextAsync.when(
      data: (userContext) {
        if (userContext == null) return const SizedBox.shrink();

        final availableTypes = _getAvailableTypes(userContext);
        if (availableTypes.length <= 1) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: context.colors.bgCard,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: availableTypes.map((type) {
              final isSelected = type == currentType;
              return Expanded(
                child: _buildSwitchButton(
                  context,
                  type: type,
                  isSelected: isSelected,
                  onTap: () => onSwitch?.call(type),
                ),
              );
            }).toList(),
          ),
        );
      },
      loading: () => Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        height: 40,
        decoration: BoxDecoration(
          color: context.colors.bgCard.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  List<DashboardType> _getAvailableTypes(userContext) {
    final types = <DashboardType>[];

    if (userContext.isSuperAdmin) {
      types.add(DashboardType.superadmin);
    }

    if (userContext.role.level == RoleLevel.groupLeader ||
        userContext.role.level == RoleLevel.staff ||
        userContext.role.level == RoleLevel.adminTotal ||
        userContext.group != null) {
      types.add(DashboardType.group);
    }

    types.add(DashboardType.member);

    return types;
  }

  Widget _buildSwitchButton(
    BuildContext context, {
    required DashboardType type,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final config = _getTypeConfig(type);

    return GestureDetector(
      onTap: isSelected ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.brandPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              config.icon,
              size: 18,
              color: isSelected ? Colors.white : context.colors.textSecondaryLight,
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                config.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color:
                      isSelected ? Colors.white : context.colors.textSecondaryLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _TypeConfig _getTypeConfig(DashboardType type) {
    switch (type) {
      case DashboardType.superadmin:
        return _TypeConfig(
          icon: Icons.admin_panel_settings,
          label: 'Admin',
        );
      case DashboardType.group:
        return _TypeConfig(
          icon: Icons.groups,
          label: 'Mon Groupe',
        );
      case DashboardType.member:
        return _TypeConfig(
          icon: Icons.person,
          label: 'MFE-JC',
        );
    }
  }
}

class _TypeConfig {
  final IconData icon;
  final String label;

  _TypeConfig({required this.icon, required this.label});
}
