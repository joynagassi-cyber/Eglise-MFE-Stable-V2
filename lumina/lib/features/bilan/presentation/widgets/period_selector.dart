/// Period selector widget for BILAN dashboard
library;

import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart' hide DateTimeRange;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/bilan_providers.dart';

class BilanPeriodSelector extends ConsumerWidget {
  const BilanPeriodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(bilanPeriodProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: BilanPeriodType.values.map((type) {
          final isSelected = type == selectedPeriod;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_periodLabel(type)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  ref.read(bilanPeriodProvider.notifier).state = type;
                  if (type == BilanPeriodType.custom) {
                    _showDatePicker(context, ref);
                  }
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  String _periodLabel(BilanPeriodType type) {
    switch (type) {
      case BilanPeriodType.today:
        return "Aujourd'hui";
      case BilanPeriodType.week:
        return 'Semaine';
      case BilanPeriodType.month:
        return 'Mois';
      case BilanPeriodType.quarter:
        return 'Trimestre';
      case BilanPeriodType.ytd:
        return 'Année';
      case BilanPeriodType.custom:
        return 'Personnalisé';
    }
  }

  Future<void> _showDatePicker(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      locale: const Locale('fr', 'FR'),
      helpText: 'Sélectionner la période',
      cancelText: 'Annuler',
      confirmText: 'Confirmer',
      saveText: 'Enregistrer',
      initialDateRange: material.DateTimeRange(
        start: DateTime(now.year, now.month, 1),
        end: now,
      ),
    );

    if (picked != null) {
      ref.read(bilanDateRangeProvider.notifier).state = material.DateTimeRange(
        start: picked.start,
        end: picked.end,
      );
    }
  }
}