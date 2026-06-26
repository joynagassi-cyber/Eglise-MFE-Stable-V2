import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../providers/bilan_providers.dart';
import 'group_breakdown_table.dart';
import 'consolidation_table.dart';

class BilanDimensionsTab extends ConsumerWidget {
  const BilanDimensionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analyses Dimensionnelles',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: AppSpacing.md),
          _buildFilterChips(context, ref),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Répartition par Groupes',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: AppSpacing.sm),
          const GroupBreakdownTable(),
          SizedBox(height: AppSpacing.xl),
          Text(
            'Données Consolidées',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: AppSpacing.sm),
          const ConsolidationTable(),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, WidgetRef ref) {
    // Usually we would fetch all group names. Here we mock it for the UI structure
    final selectedGroups = ref.watch(bilanSelectedGroupsProvider) ?? [];
    final availableGroups = ['G1', 'G2', 'G3', 'G4']; // Mock

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Filtrer par groupe:',
          style: TextStyle(fontSize: 14, color: context.colors.textSecondaryLight),
        ),
        SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: Text('Tous les groupes'),
              selected: selectedGroups.isEmpty,
              onSelected: (val) {
                if (val) {
                  ref.read(bilanSelectedGroupsProvider.notifier).state = [];
                }
              },
            ),
            ...availableGroups.map((g) {
              final isSelected = selectedGroups.contains(g);
              return FilterChip(
                label: Text('Groupe $g'),
                selected: isSelected,
                onSelected: (val) {
                  final list = List<String>.from(selectedGroups);
                  if (val) {
                    list.add(g);
                  } else {
                    list.remove(g);
                  }
                  ref.read(bilanSelectedGroupsProvider.notifier).state = list;
                },
              );
            }),
          ],
        ),
      ],
    );
  }
}
