// lib/features/finance/presentation/screens/budget_dashboard_screen.dart
// Dashboard Budgétaire - Deep Purple Theme

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lumina/core/providers/user_context_provider.dart';

import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/animated_entrance.dart';
import 'package:lumina/core/widgets/app_error_widget.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/features/finance/domain/entities/budget.dart';
import 'package:lumina/features/finance/domain/entities/enums/budget_period.dart';
import 'package:lumina/features/finance/presentation/providers/budget_providers.dart';
import 'package:lumina/features/finance/presentation/widgets/budget_card.dart';
import 'package:lumina/features/finance/presentation/widgets/budget_form_dialog.dart';
import 'package:lumina/core/widgets/skeletons/fire_skeleton_system.dart';
import 'package:lumina/core/widgets/shimmer_loading.dart';

class BudgetDashboardScreen extends ConsumerStatefulWidget {
  const BudgetDashboardScreen({super.key});

  @override
  ConsumerState<BudgetDashboardScreen> createState() =>
      _BudgetDashboardScreenState();
}

class _BudgetDashboardScreenState extends ConsumerState<BudgetDashboardScreen> {
  int _selectedYear = DateTime.now().year;
  BudgetPeriod _selectedPeriod = BudgetPeriod.monthly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final budgetsAsync = ref.watch(
      budgetListProvider(year: _selectedYear, period: _selectedPeriod),
    );
    final overBudgetsAsync = ref.watch(overBudgetsProvider);
    final textColor = context.colors.textPrimary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, textColor, theme),
          SliverToBoxAdapter(
            child: RefreshIndicator(
              onRefresh: () async {
                await HapticHelper.medium();
                ref.invalidate(budgetListProvider);
                ref.invalidate(overBudgetsProvider);
              },
              child: Padding(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedEntrance.fromBottom(
                      delay: const Duration(milliseconds: 100),
                      child: Text(
                        _getPeriodTitle(),
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    AnimatedEntrance.fromBottom(
                      delay: const Duration(milliseconds: 200),
                      child: overBudgetsAsync.when(
                        data: (overBudgets) =>
                            _buildAlertsSection(overBudgets, theme),
                        loading: () => Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.md),
                          child: ShimmerBox(height: 60, borderRadius: 16),
                        ),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    budgetsAsync.when(
                      data: (budgets) {
                        if (budgets.isEmpty) {
                          return AnimatedEntrance.fromBottom(
                            delay: const Duration(milliseconds: 300),
                            child: _buildEmptyState(theme),
                          );
                        }
                        return Column(
                          children: [
                            AnimatedEntrance.fromBottom(
                              delay: const Duration(milliseconds: 300),
                              child: _buildComparisonChart(
                                budgets,
                                theme,
                              ),
                            ),
                            SizedBox(height: AppSpacing.xl),
                            AnimatedEntrance.fromBottom(
                              delay: const Duration(milliseconds: 400),
                              child: _buildBudgetList(
                                budgets,
                                textColor,
                                theme,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const FireSkeletonBudgetDashboard(),
                      error: (e, stack) => AppErrorWidget.server(
                        technicalDetails: e.toString(),
                        onRetry: () {
                          ref.invalidate(budgetListProvider);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedEntrance.fromBottom(
        delay: const Duration(milliseconds: 500),
        child: Semantics(
          label: 'Créer un nouveau budget',
          button: true,
          enabled: true,
          child: Container(
            decoration: BoxDecoration(
              gradient: context.colors.brandPrimaryGradient,
              borderRadius: AppSpacing.borderRadiusLg,
              boxShadow: AppSpacing.shadowPrimary(context.colors.brandPrimary),
            ),
            child: FloatingActionButton.extended(
              onPressed: () async {
                await HapticHelper.light();
                _showBudgetForm();
              },
              label: Text(
                'Nouveau Budget',
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.textOnBrand,
                ),
              ),
              icon: Icon(Icons.add_rounded),
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: context.colors.textOnBrand,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    Color textColor,
    ThemeData theme,
  ) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(
          left: AppSpacing.lg,
          bottom: AppSpacing.md,
        ),
        title: Text(
          'Budgets',
          style: AppTypography.headlineSmall.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        Semantics(
          label: 'Sélectionner l\'année',
          button: true,
          enabled: true,
          child: _buildActionButton(
            Icons.calendar_today_rounded,
            'Sélectionner l\'année',
            () => _selectYear(context),
          ),
        ),
        Semantics(
          label: 'Sélectionner la période',
          button: true,
          enabled: true,
          child: _buildActionButton(
            Icons.date_range_rounded,
            'Sélectionner la période',
            () => _selectPeriod(context),
          ),
        ),
        Semantics(
          label: 'Exporter en PDF',
          button: true,
          enabled: true,
          child: _buildActionButton(Icons.picture_as_pdf_rounded, 'Exporter en PDF', () async {
            final userContext =
                ref.read(userContextNotifierProvider).valueOrNull;
            final churchName = userContext?.group?.label ?? 'Mon Église';
            await ref.read(budgetActionsProvider.notifier).exportBudgetReport(
                  year: _selectedYear,
                  period: _selectedPeriod,
                  churchName: churchName,
                );
          }),
        ),
        Semantics(
          label: 'Actualiser les montants',
          button: true,
          enabled: true,
          child: _buildActionButton(
            Icons.refresh_rounded,
            'Actualiser les montants',
            _updateActuals,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String tooltip, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colors.brandPrimary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: context.colors.brandPrimary, size: AppSpacing.iconMd),
        tooltip: tooltip,
        onPressed: () async {
          await HapticHelper.light();
          onTap();
        },
      ),
    );
  }

  String _getPeriodTitle() {
    switch (_selectedPeriod) {
      case BudgetPeriod.monthly:
        return 'Mensuels $_selectedYear';
      case BudgetPeriod.quarterly:
        return 'Trimestriels $_selectedYear';
      case BudgetPeriod.annual:
        return 'Annuel $_selectedYear';
    }
  }

  Widget _buildAlertsSection(
    List<Budget> overBudgets,
    ThemeData theme,
  ) {
    if (overBudgets.isEmpty) return const SizedBox.shrink();

    return Semantics(
      label: '${overBudgets.length} budgets dépassés',
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: context.colors.errorText.withValues(alpha: 0.1),
          borderRadius: AppSpacing.borderRadiusCard,
          border: Border.all(color: context.colors.errorText.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline_rounded,
                  color: context.colors.errorText,
                  size: AppSpacing.iconLg,
                ),
                SizedBox(width: AppSpacing.md),
                Text(
                  '${overBudgets.length} Dépassements',
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.errorText,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            ...overBudgets.take(3).map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Row(
                      children: [
                        Icon(Icons.chevron_right_rounded,
                          size: AppSpacing.iconSm,
                          color: context.colors.errorText,
                        ),
                        SizedBox(width: AppSpacing.xxs),
                        Expanded(
                          child: Text(
                            'Catégorie ${b.categoryId}',
                            style: AppTypography.bodyMedium,
                          ),
                        ),
                        Text(
                          '+${b.variance.toStringAsFixed(0)} FCFA',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colors.errorText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonChart(
    List<Budget> budgets,
    ThemeData theme,
  ) {
    return Container(
      height: 350,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: AppSpacing.borderRadiusCard,
        boxShadow: AppSpacing.shadowSm,
        border: Border.all(
          color: context.colors.borderSubtle,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prévu vs Réalisé',
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _buildLegend('Prévu', context.colors.infoText, theme),
              SizedBox(width: AppSpacing.md),
              _buildLegend('Réalisé', context.colors.successText, theme),
              SizedBox(width: AppSpacing.md),
              _buildLegend('Dépas.', context.colors.errorText, theme),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(budgets),
                barGroups: budgets.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.plannedAmount,
                        color: context.colors.infoText.withValues(alpha: 0.8),
                        width: 14,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: e.value.actualAmount,
                        color: e.value.isOverBudget
                            ? context.colors.errorText
                            : context.colors.successText,
                        width: 14,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (v, m) => Text(
                        _formatAmount(v),
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, m) {
                        if (v.toInt() >= budgets.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.sm),
                          child: Text(
                            'C${v.toInt() + 1}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: true, drawVerticalLine: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppSpacing.borderRadiusSm,
          ),
        ),
        SizedBox(width: AppSpacing.xxs),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetList(
    List<Budget> budgets,
    Color textColor,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Détails par Rubrique',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        ...budgets.asMap().entries.map(
              (entry) => AnimatedEntrance.fromLeft(
                delay: Duration(milliseconds: 50 * entry.key),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: BudgetCard(budget: entry.value),
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: context.colors.brandPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.account_balance_wallet_outlined,
                size: AppSpacing.iconHero,
                color: context.colors.brandPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Aucun budget défini',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Préparez vos prévisions pour cette période.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getMaxY(List<Budget> budgets) {
    if (budgets.isEmpty) return 100000;
    final maxP =
        budgets.map((b) => b.plannedAmount).reduce((a, b) => a > b ? a : b);
    final maxA =
        budgets.map((b) => b.actualAmount).reduce((a, b) => a > b ? a : b);
    return ((maxP > maxA ? maxP : maxA) * 1.2).ceilToDouble();
  }

  String _formatAmount(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }

  void _selectYear(BuildContext context) async {
    await HapticHelper.light();
    if (!context.mounted) return;
    final theme = Theme.of(context);

    final year = await showDialog<int>(
      context: context,
      builder: (context) {
        final cur = DateTime.now().year;
        return SimpleDialog(
          title: Text(
            'Sélectionner l\'année',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          children: List.generate(5, (i) => cur - 2 + i)
              .map(
                (y) => SimpleDialogOption(
                  onPressed: () async {
                    await HapticHelper.selection();
                    if (context.mounted) Navigator.pop(context, y);
                  },
                  child: Text('$y', style: theme.textTheme.bodyLarge),
                ),
              )
              .toList(),
        );
      },
    );
    if (year != null && mounted) setState(() => _selectedYear = year);
  }

  void _selectPeriod(BuildContext context) async {
    await HapticHelper.light();
    if (!context.mounted) return;
    final theme = Theme.of(context);

    final period = await showDialog<BudgetPeriod>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'Sélectionner la période',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: BudgetPeriod.values
            .map(
              (p) => SimpleDialogOption(
                onPressed: () async {
                  await HapticHelper.selection();
                  if (context.mounted) Navigator.pop(context, p);
                },
                child: Text(p.label, style: theme.textTheme.bodyLarge),
              ),
            )
            .toList(),
      ),
    );
    if (period != null && mounted) setState(() => _selectedPeriod = period);
  }

  Future<void> _updateActuals() async {
    await HapticHelper.medium();
    await ref.read(budgetActionsProvider.notifier).updateAllActuals();
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);

    await HapticHelper.success();

    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text('Montants mis à jour'),
        backgroundColor: context.colors.successText,
      ),
    );
  }

  void _showBudgetForm() {
    showDialog(
      context: context,
      builder: (context) =>
          BudgetFormDialog(year: _selectedYear, period: _selectedPeriod),
    );
  }
}
