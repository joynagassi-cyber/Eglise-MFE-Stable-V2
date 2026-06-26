/// Heatmap widget for transactional activity intensity (Hour vs Day)
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/bilan_providers.dart';

class BilanHeatmap extends ConsumerWidget {
  const BilanHeatmap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heatmapAsync = ref.watch(bilanHeatmapProvider);
    final theme = Theme.of(context);

    return heatmapAsync.when(
      loading: () => const Center(child: LoadingState()),
      error: (e, _) => const Center(child: Text('Impossible de charger la carte thermique')),
      data: (points) {
        if (points.isEmpty) return const SizedBox.shrink();

        // 7 days x 24 hours
        // Day 0 = Sunday (from DOW)
        final days = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];

        // Find max count for scaling color
        final maxCount = points.fold<int>(
          0,
          (prev, p) => p.txCount > prev ? p.txCount : prev,
        );

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Intensité de l\'activité',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      // Header (Hours)
                      Row(
                        children: [
                          const SizedBox(width: 40),
                          ...List.generate(
                            24,
                            (h) => SizedBox(
                              width: 20,
                              child: Text(
                                '${h}h'.padLeft(3),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Rows (Days)
                      ...List.generate(7, (d) {
                        return Row(
                          children: [
                            SizedBox(
                              width: 40,
                              child: Text(
                                days[d],
                                style: theme.textTheme.labelSmall,
                              ),
                            ),
                            ...List.generate(24, (h) {
                              final point = points.firstWhere(
                                (p) => p.dayOfWeek == d && p.hourOfDay == h,
                                orElse: () => const BilanHeatmapPoint(
                                  dayOfWeek: 0,
                                  hourOfDay: 0,
                                  txCount: 0,
                                ),
                              );

                              final opacity = maxCount > 0
                                  ? (point.txCount / maxCount).clamp(0.0, 1.0)
                                  : 0.0;

                              return Tooltip(
                                message:
                                    '${days[d]} à ${h}h: ${point.txCount} tx',
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  margin: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: opacity,
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                      color: theme.colorScheme.outlineVariant
                                          .withValues(alpha: 0.2),
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}