import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/providers/auth_provider.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../../core/auth/domain/entities/auth_state.dart' as app_auth;
import '../../data/models/bilan_period.dart';
import '../providers/bilan_providers.dart';
import 'bilan_seal_dialog.dart';
import 'audit_trail_list.dart';

class BilanSealTab extends ConsumerWidget {
  const BilanSealTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = ref.watch(bilanSelectedYearProvider);
    final periodsAsync = ref.watch(bilanPeriodsProvider(year));
    final totalsAsync = ref.watch(bilanMonthlyTotalsProvider(year));
    final authState = ref.watch(authProvider).valueOrNull;
    final authUser = authState is app_auth.AuthAuthenticated ? authState.context.user : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Clôture Mensuelle - $year',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              DropdownButton<int>(
                value: year,
                items: [year - 2, year - 1, year, year + 1]
                    .map((y) => DropdownMenuItem(value: y, child: Text(y.toString())))
                    .toList(),
                onChanged: (y) {
                  if (y != null) {
                    ref.read(bilanSelectedYearProvider.notifier).state = y;
                  }
                },
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          periodsAsync.when(
            loading: () => Center(child: LoadingState()),
            error: (e, _) => Center(child: Text('Impossible de charger le statut de clôture')),
            data: (periodsList) {
              // Ensure we have a list of BilanPeriod objects, even if Provider returns dynamic
              final List<BilanPeriod> periods = List<BilanPeriod>.from(periodsList);
              
              if (periods.isEmpty) {
                return _buildEmptyState(context, year);
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing: AppSpacing.sm,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  final periodOption = periods.where((p) => p.month == month);
                  
                  if (periodOption.isEmpty) {
                    return _buildUninitializedMonthCard(context, month, year);
                  }
                  
                  final period = periodOption.first;
                  return _buildMonthCard(context, ref, period, totalsAsync, authUser?.id);
                },
              );
            },
          ),
          
          SizedBox(height: AppSpacing.xl),
          Divider(),
          SizedBox(height: AppSpacing.md),
          Text(
            'Journal d\'Audit',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: AppSpacing.sm),
          const AuditTrailList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, int year) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.calendar_today, size: 48, color: Colors.grey),
          SizedBox(height: AppSpacing.sm),
          Text('Aucune période initialisée pour l\'année $year.'),
          TextButton(
            onPressed: () {
              // Note: Usually we would have a 'init year' RPC or we just initialize 
              // periods automatically upon transaction creation.
            },
            child: Text('Générer les mois manquants'),
          )
        ],
      ),
    );
  }

  Widget _buildUninitializedMonthCard(BuildContext context, int month, int year) {
    const monthNames = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    
    return Card(
      elevation: 0,
      color: Theme.of(context).brightness == Brightness.dark 
          ? Colors.grey.shade900 
          : Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              monthNames[month - 1],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Chip(
              label: Text('Non initialisé', style: TextStyle(fontSize: 10)),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthCard(
    BuildContext context, 
    WidgetRef ref, 
    BilanPeriod period,
    AsyncValue<List<Map<String, dynamic>>> totalsAsync,
    String? currentUserId,
  ) {
    final currencyFormatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA');
    
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (period.status) {
      case BilanPeriodStatus.sealed:
        statusColor = context.colors.successText;
        statusIcon = Icons.lock;
        statusText = 'Clôturé';
        break;
      case BilanPeriodStatus.pendingReview:
        statusColor = context.colors.warningText;
        statusIcon = Icons.rule;
        statusText = 'En révision';
        break;
      case BilanPeriodStatus.archived:
        statusColor = Colors.grey;
        statusIcon = Icons.archive;
        statusText = 'Archivé';
        break;
      case BilanPeriodStatus.open:
        statusColor = context.colors.brandPrimary;
        statusIcon = Icons.lock_open;
        statusText = 'Ouvert';
        break;
    }

    return Card(
      elevation: period.isSealed ? 1 : 4,
      color: period.isSealed ? statusColor.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: statusColor.withOpacity(0.3),
          width: period.isSealed ? 1 : 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: period.isSealed ? null : () {
          // Find month totals
          double tIncome = period.totalIncome;
          double tExpense = period.totalExpense;
          double tNet = period.netBalance;
          
          if (totalsAsync.hasValue) {
            final monthData = totalsAsync.value!.firstWhere(
              (m) => m['month'] == period.month,
              orElse: () => {'income': 0.0, 'expense': 0.0, 'net': 0.0},
            );
            tIncome = monthData['income'] as double;
            tExpense = monthData['expense'] as double;
            tNet = monthData['net'] as double;
          }

          showDialog(
            context: context,
            builder: (ctx) => BilanSealDialog(
              year: period.year,
              month: period.month,
              totalIncome: tIncome,
              totalExpense: tExpense,
              netBalance: tNet,
              onConfirm: () {
                ref.read(bilanSealActionsNotifierProvider.notifier).sealPeriod(
                      period.year,
                      period.month,
                      currentUserId ?? '',
                    );
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    period.monthShortLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Icon(statusIcon, color: statusColor, size: 16),
                ],
              ),
              Spacer(),
              if (period.isSealed) ...[
                Text(
                  currencyFormatter.format(period.netBalance),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: period.netBalance >= 0 ? context.colors.successText : context.colors.errorText,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Hash: ${period.sealHash?.substring(0, 8) ?? '...'}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontFamily: 'monospace',
                    color: Colors.grey,
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
