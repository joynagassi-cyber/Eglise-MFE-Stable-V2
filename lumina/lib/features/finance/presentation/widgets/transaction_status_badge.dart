// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
// lib/features/finance/presentation/widgets/transaction_status_badge.dart
import 'package:flutter/material.dart';
import '../../domain/entities/enums/transaction_status.dart';
import '../utils/finance_enums_ui_extensions.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';
import 'package:lumina/core/theme/app_spacing.dart';
/// Badge affichant le statut de workflow d'une transaction
class TransactionStatusBadge extends StatelessWidget {
  final TransactionStatus status;
  final bool showLabel;
  final double? iconSize;

  const TransactionStatusBadge({
    super.key,
    required this.status,
    this.showLabel = true,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: showLabel ? AppSpacing.md : AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: status.getColor(context).withValues(alpha: 0.12),
        borderRadius:
            BorderRadius.circular(AppSpacing.radiusFull), // Large pill shape
        border:
            Border.all(color: status.getColor(context).withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: iconSize ?? 16, color: status.getColor(context)),
          if (showLabel) ...[
            const SizedBox(width: 8),
            Text(
              status.label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w900,
                color: status.getColor(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget de sélection de statut pour les actions de workflow
class StatusSelector extends StatelessWidget {
  final TransactionStatus? currentStatus;
  final List<TransactionStatus> availableStatuses;
  final ValueChanged<TransactionStatus> onStatusSelected;

  const StatusSelector({
    super.key,
    required this.currentStatus,
    required this.availableStatuses,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableStatuses.map((status) {
        final isSelected = status == currentStatus;
        return InkWell(
          onTap: () => onStatusSelected(status),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? status.getColor(context).withOpacity(0.2)
                  : context.colors.bgCardLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: isSelected ? status.getColor(context) : context.colors.borderSubtle,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  status.icon,
                  size: 16,
                  color:
                      isSelected ? status.getColor(context) : context.colors.textTertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  status.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? status.getColor(context)
                        : context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}