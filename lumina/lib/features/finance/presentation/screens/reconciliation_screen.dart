// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
// lib/features/finance/presentation/screens/reconciliation_screen.dart
// Rapprochement Bancaire - Deep Purple Theme

import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/animated_entrance.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/features/finance/presentation/providers/finance_providers.dart';
import 'package:lumina/features/finance/domain/entities/enums/transaction_type.dart';
import 'package:lumina/features/finance/domain/services/reconciliation_service.dart';
import 'package:lumina/core/widgets/app_progress_bar.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class ReconciliationScreen extends ConsumerWidget {
  const ReconciliationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(reconciliationActionsProvider);
    final notifier = ref.read(reconciliationActionsProvider.notifier);
    final textColor = context.colors.textPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rapprochement Bancaire',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        actions: [
          if (state.imported.isNotEmpty)
            Semantics(
              label: 'Importer toutes les transactions',
              button: true,
              enabled: true,
              child: Container(
                margin: const EdgeInsets.only(right: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: context.colors.successText.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.check_rounded,
                    color: context.colors.successText,
                    size: AppSpacing.iconMd,
                  ),
                  onPressed: () async {
                    await HapticHelper.medium();
                    unawaited(notifier.confirmImport(state.imported));
                    await HapticHelper.success();
                  },
                  tooltip: 'Importer tout',
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          AnimatedEntrance.fromBottom(
            delay: const Duration(milliseconds: 100),
            child: _buildImportSection(context, ref, theme),
          ),
          if (state.isLoading)
            const AppProgressBar(),
          if (state.error != null)
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 200),
              child: _buildErrorContainer(context, state.error!, theme),
            ),
          Expanded(
            child: state.imported.isEmpty
                ? AnimatedEntrance.fromBottom(
                    delay: const Duration(milliseconds: 300),
                    child: _buildEmptyState(context, theme),
                  )
                : ListView.separated(
                    padding: AppSpacing.screenPadding,
                    itemCount: state.imported.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) => AnimatedEntrance.fromLeft(
                      delay: Duration(milliseconds: 100 + (index * 50)),
                      child: _ReconciliationItemCard(
                        item: state.imported[index],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportSection(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Semantics(
        label: 'Importer un relevé bancaire CSV',
        button: true,
        enabled: true,
        child: Container(
          decoration: BoxDecoration(
            gradient: context.colors.brandPrimaryGradient,
            borderRadius: AppSpacing.borderRadiusCard,
            boxShadow: AppSpacing.shadowPrimary(context.colors.brandPrimary),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await HapticHelper.light();
                if (context.mounted) {
                  unawaited(_pickCsv(context, ref));
                }
              },
              borderRadius: AppSpacing.borderRadiusCard,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.upload_file_rounded,
                      color: context.colors.textOnBrand,
                      size: AppSpacing.iconXl,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'Importer un relevé CSV',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: context.colors.textOnBrand,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorContainer(BuildContext context, String error, ThemeData theme) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.errorText.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: context.colors.errorText.withValues(alpha: 0.3)),
      ),
      child: Text(
        'Impossible de charger les données de réconciliation',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: context.colors.errorText,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_rounded,
            size: 80,
            color: context.colors.brandPrimary.withValues(alpha: 0.1),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Aucune transaction à rapprocher',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCsv(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'txt'],
      );
      if (result != null) {
        await HapticHelper.medium();
        final file = File(result.files.single.path!);
        final content = await file.readAsString();
        if (context.mounted) {
          unawaited(ref
              .read(reconciliationActionsProvider.notifier)
              .importCsv(content));
          await HapticHelper.success();
        }
      }
    } catch (e) {
      await HapticHelper.error();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Impossible de réconcilier')));
      }
    }
  }
}

class _ReconciliationItemCard extends StatelessWidget {
  final ImportedTransaction item;
  const _ReconciliationItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMatched = item.isMatched;
    final amountColor = item.type == TransactionType.income
        ? context.colors.successText
        : context.colors.errorText;

    return Semantics(
      label: 'Transaction ${item.description}, montant ${item.amount} FCFA',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colors.bgCard,
          borderRadius: AppSpacing.borderRadiusCard,
          border: Border.all(
            color: isMatched
                ? context.colors.successText.withValues(alpha: 0.5)
                : context.colors.borderSubtle,
            width: isMatched ? 2 : 1,
          ),
          boxShadow: AppSpacing.shadowSm,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm + 2),
              decoration: BoxDecoration(
                color: amountColor.withValues(alpha: 0.1),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Icon(
                item.type == TransactionType.income
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: amountColor,
                size: AppSpacing.iconMd,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    DateFormat('dd MMMM yyyy', 'fr_FR').format(item.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${NumberFormat.decimalPattern('fr_FR').format(item.amount)} FCFA',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _textColor(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                _buildBadge(context, isMatched, theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, bool isMatched, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: (isMatched ? context.colors.successText : context.colors.brandPrimary).withValues(
          alpha: 0.15,
        ),
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      child: Text(
        isMatched ? 'CONCORDANCE' : 'NOUVEAU',
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: isMatched ? context.colors.successText : context.colors.brandPrimary,
        ),
      ),
    );
  }

  Color _textColor(BuildContext context) => context.colors.textPrimary;
}