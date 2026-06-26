import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/auth/domain/entities/enums/role_level.dart';
import 'package:lumina/core/utils/traceability_formatter.dart';

class AuditBadge extends StatelessWidget {
  final String? userName;
  final String? userRole;
  final DateTime? modifiedAt;

  const AuditBadge({
    super.key,
    this.userName,
    this.userRole,
    this.modifiedAt,
  });

  String _getReadableRole(String? roleStr) {
    if (roleStr == null) return '';
    try {
      final level = RoleLevel.values.firstWhere(
        (e) =>
            e.name == roleStr.toLowerCase() || e.toString().contains(roleStr),
        orElse: () => RoleLevel.custom,
      );
      if (level == RoleLevel.custom) return roleStr;
      return level.label;
    } catch (_) {
      return roleStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userName == null && modifiedAt == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final dateStr = modifiedAt != null
        ? DateFormat('dd/MM/yyyy à HH:mm').format(modifiedAt!)
        : 'Inconnue';

    final actorStr = TraceabilityFormatter.formatActor(
      name: userName,
      role: _getReadableRole(userRole),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(100),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withAlpha(50),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.history_toggle_off_rounded,
            size: 16,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Modifié par $actorStr le $dateStr',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
