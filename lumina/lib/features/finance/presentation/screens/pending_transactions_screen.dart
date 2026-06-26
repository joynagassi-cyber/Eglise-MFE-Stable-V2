// lib/features/finance/presentation/screens/pending_transactions_screen.dart
// Transactions à Valider - Deep Purple Theme

import 'dart:async';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/features/finance/domain/entities/finance_transaction.dart';
import 'package:lumina/features/finance/presentation/providers/finance_providers.dart';

class PendingTransactionsScreen extends ConsumerWidget {
  const PendingTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pendingAsync = ref.watch(pendingTransactionsProvider);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = context.colors.textPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transactions à Valider',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: pendingAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 200),
              child: _buildEmptyState(context, isDark, theme),
            );
          }

          return ListView.separated(
            padding: AppSpacing.screenPadding,
            itemCount: transactions.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) => AnimatedEntrance.fromBottom(
              delay: Duration(milliseconds: 100 + (index * 50)),
              child: _PendingTransactionCard(transaction: transactions[index]),
            ),
          );
        },
        loading: () => const Center(
          child: LoadingState(),
        ),
        error: (e, stack) => AppErrorWidget.server(
          technicalDetails: e.toString(),
          onRetry: () => ref.refresh(pendingTransactionsProvider),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: context.colors.successText.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle_outline_rounded,
              size: AppSpacing.iconHero,
              color: context.colors.successText,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Tout est à jour !',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Aucune transaction en attente de validation.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingTransactionCard extends ConsumerWidget {
  final FinanceTransaction transaction;
  const _PendingTransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final formattedDate = DateFormat('dd/MM/yyyy').format(transaction.date);

    return Semantics(
      label:
          'Transaction ${transaction.description}, montant ${transaction.amount} FCFA',
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: context.colors.bgCard,
          borderRadius: AppSpacing.borderRadiusCard,
          border: Border.all(
            color: context.colors.borderSubtle,
          ),
          boxShadow: AppSpacing.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    transaction.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm + 2,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: (transaction.isIncome
                            ? context.colors.successText
                            : context.colors.errorText)
                        .withValues(alpha: 0.1),
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: Text(
                    '${transaction.amount.toStringAsFixed(0)} FCFA',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: transaction.isIncome
                          ? context.colors.successText
                          : context.colors.errorText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _buildInfo(
                  context,
                  Icons.calendar_today_rounded,
                  formattedDate,
                  isDark,
                  theme,
                ),
                const SizedBox(width: AppSpacing.md),
                _buildInfo(
                  context,
                  Icons.category_rounded,
                  transaction.category ?? 'N/A',
                  isDark,
                  theme,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Divider(
              color: context.colors.borderSubtle,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Semantics(
                  label: 'Rejeter la transaction',
                  button: true,
                  enabled: true,
                  child: TextButton(
                    onPressed: () async {
                      await HapticHelper.light();
                      if (context.mounted) {
                        unawaited(_reject(context, ref));
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: context.colors.errorText,
                    ),
                    child: Text(
                      'REJETER',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Semantics(
                  label: 'Valider la transaction',
                  button: true,
                  enabled: true,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await HapticHelper.light();
                      if (context.mounted) {
                        unawaited(_approve(context, ref));
                      }
                    },
                    icon: const Icon(
                      Icons.check_rounded,
                      size: AppSpacing.iconSm,
                    ),
                    label: Text(
                      'VALIDER',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.successText,
                      foregroundColor: context.colors.textOnBrand,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppSpacing.borderRadiusMd,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context, IconData icon, String text,
      bool isDark, ThemeData theme) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppSpacing.iconXs,
          color: context.colors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Future<void> _approve(BuildContext context, WidgetRef ref) async {
    try {
      await HapticHelper.medium();
      await ref
          .read(transactionApprovalActionsProvider.notifier)
          .approve(transaction.id);
      if (context.mounted) {
        await HapticHelper.success();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Transaction validée'),
              backgroundColor: context.colors.successText,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        await HapticHelper.error();
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Erreur lors de la validation')));
        }
      }
    }
  }

  Future<void> _reject(BuildContext context, WidgetRef ref) async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
        title: Text(
          'Rejeter ?',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Cette transaction sera supprimée définitivement.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await HapticHelper.light();
              if (context.mounted) Navigator.pop(context, false);
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              await HapticHelper.warning();
              if (context.mounted) Navigator.pop(context, true);
            },
            style: TextButton.styleFrom(foregroundColor: context.colors.errorText),
            child: const Text('Rejeter'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(transactionApprovalActionsProvider.notifier)
            .reject(transaction.id, 'Rejetée');
        if (context.mounted) {
          await HapticHelper.success();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Transaction rejetée'),
                backgroundColor: context.colors.infoText,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          await HapticHelper.error();
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Erreur lors du rejet')));
          }
        }
      }
    }
  }
}
