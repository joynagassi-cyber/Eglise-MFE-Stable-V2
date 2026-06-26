import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../domain/entities/finance_transaction.dart';
import '../../domain/entities/enums/transaction_type.dart';

import '../../domain/entities/enums/transaction_status.dart';
import '../utils/finance_enums_ui_extensions.dart';

import '../../../../core/services/offline_sync_manager.dart';

class TransactionListItem extends ConsumerWidget {
  final FinanceTransaction transaction;
  final VoidCallback onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? context.colors.successText : context.colors.errorText;
    final currencyFormat = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: '',
      decimalDigits: 0,
    );

    // Watch for sync pending status
    final isPending =
        ref.watch(isRecordPendingProvider(transaction.id)).value ?? false;

    return Semantics(
      label:
          '${transaction.description}, ${isIncome ? 'revenu' : 'dépense'} de ${currencyFormat.format(transaction.amount)} FCFA',
      button: true,
      child: InkWell(
        onTap: () async {
          await HapticHelper.light();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: context.colors.bgCard.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isPending
                  ? context.colors.warningText.withValues(alpha: 0.5)
                  : context.colors.brandPrimary.withValues(alpha: 0.1),
              width: isPending ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isIncome
                    ? context.colors.successText.withValues(alpha: 0.05)
                    : context.colors.errorText.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isIncome
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      color: color,
                      size: 20,
                    ),
                  ),
                  if (isPending)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: context.colors.warningText,
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.cardColor, width: 2),
                        ),
                        child: Icon(
                          Icons.sync,
                          size: 8,
                          color: context.colors.textOnBrand,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description,
                      style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: context.colors.textSecondary
                                .withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: Text(
                            transaction.category ?? 'Général',
                            style: AppTypography.labelSmall.copyWith(
                              color: context.colors.brandPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          DateFormat('dd MMM', 'fr_FR')
                              .format(transaction.date),
                          style: AppTypography.labelSmall.copyWith(
                            color: context.colors.textSecondary
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isIncome ? '+' : '-'}${currencyFormat.format(transaction.amount)} F',
                    style: AppTypography.labelLarge.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  _buildMiniStatus(context, transaction.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStatus(BuildContext context, TransactionStatus status) {
    return Text(
      status.label.toUpperCase(),
      style: AppTypography.labelSmall.copyWith(
        fontSize: 9,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.5,
        color: status.getColor(context),
      ),
    );
  }
}
