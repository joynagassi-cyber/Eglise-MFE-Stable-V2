import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/glass_card.dart';
import 'package:lumina/features/finance/domain/services/currency_service.dart';
import 'package:lumina/features/finance/presentation/providers/finance_providers.dart';
import 'package:lumina/core/widgets/skeletons/fire_skeleton_system.dart';

class RegistreCulteWidget extends ConsumerWidget {
  const RegistreCulteWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registreAsync = ref.watch(registreCulteProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Registre des Collectes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Outfit',
                  letterSpacing: -0.5,
                ),
              ),
              Icon(Icons.history_edu_rounded,
                  color: context.colors.brandPrimary.withOpacity(0.5)),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        registreAsync.when(
          data: (data) => _buildTable(context, data),
          loading: () => const FireSkeletonBudgetDashboard(),
          error: (err, _) => Center(child: Text('Impossible de charger le registre')),
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context, List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return const GlassCard(
        child: Center(child: Text('Aucune donnée enregistrée')),
      );
    }

    return GlassCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor:
                WidgetStateProperty.all(context.colors.brandPrimary.withOpacity(0.05)),
            columnSpacing: 24,
            horizontalMargin: 16,
            columns: [
              DataColumn(label: Text('DATE', style: _headerStyle(context))),
              DataColumn(label: Text('SERVICE', style: _headerStyle(context))),
              DataColumn(label: Text('OFFRANDES', style: _headerStyle(context))),
              DataColumn(label: Text('DÎMES', style: _headerStyle(context))),
              DataColumn(label: Text('TRAVAUX', style: _headerStyle(context))),
              DataColumn(label: Text('TOTAL', style: _headerStyle(context))),
            ],
            rows: data.map((row) {
              final dateStr = row['date'] as String;
              final date = DateTime.parse(dateStr);
              final total = (row['total_jour'] as num).toDouble();

              return DataRow(cells: [
                DataCell(
                    Text(DateFormat('dd/MM').format(date), style: _cellStyle)),
                DataCell(Text(row['type_service'] ?? '-',
                    style: _cellStyle.copyWith(fontSize: 11))),
                DataCell(Text(_format(row['offrandes']), style: _cellStyle)),
                DataCell(Text(_format(row['dimes']), style: _cellStyle)),
                DataCell(Text(_format(row['terrain']), style: _cellStyle)),
                DataCell(Text(
                  _format(total),
                  style: _cellStyle.copyWith(
                      color: context.colors.brandPrimary, fontWeight: FontWeight.bold),
                )),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  String _format(dynamic value) {
    final numVal = (value as num?)?.toDouble() ?? 0;
    if (numVal == 0) return '-';
    return CurrencyService.format(numVal, 'XAF').replaceAll(' FCFA', '');
  }

  TextStyle _headerStyle(BuildContext context) => TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: context.colors.brandPrimary,
        letterSpacing: 1.0,
      );

  static const _cellStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}
