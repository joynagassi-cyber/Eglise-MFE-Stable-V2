import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../domain/services/bilan_service.dart';
import '../../../groups/presentation/providers/group_providers.dart';

class BilanFiltersBar extends ConsumerWidget {
  const BilanFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(bilanFilterPeriodProvider);
    final selectedGroupId = ref.watch(bilanFilterGroupProvider);
    final groupsAsync = ref.watch(groupsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: GlassCard(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
        child: Row(
          children: [
            Icon(Icons.date_range_rounded,
                size: 18, color: context.colors.brandPrimary),
            SizedBox(width: 8),
            TextButton(
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: period,
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.fromSeed(
                          seedColor: context.colors.brandPrimary,
                          brightness: Theme.of(context).brightness,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  ref.read(bilanFilterPeriodProvider.notifier).state = picked;
                }
              },
              child: Text(
                '${period.start.day}/${period.start.month} — ${period.end.day}/${period.end.month}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : context.colors.textPrimaryLight,
                ),
              ),
            ),
            VerticalDivider(width: 24, indent: 8, endIndent: 8),
            // Group Filter
            Expanded(
              child: groupsAsync.when(
                data: (groups) => DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: selectedGroupId,
                    isExpanded: true,
                    hint: Text('Tous les groupes', style: TextStyle(fontSize: 12)),
                    icon: Icon(Icons.arrow_drop_down, size: 20),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Tous les groupes', style: TextStyle(fontSize: 12)),
                      ),
                      ...groups.map((g) => DropdownMenuItem(
                            value: g.id,
                            child: Text(g.name, 
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                    ],
                    onChanged: (val) {
                      ref.read(bilanFilterGroupProvider.notifier).state = val;
                    },
                  ),
                ),
                loading: () => SizedBox(width: 20, height: 20, child: LoadingDots(size: 16)),
                error: (_, __) => Icon(Icons.error_outline, size: 16),
              ),
            ),
            IconButton(
              icon: Icon(Icons.refresh_rounded, size: 20),
              onPressed: () {
                ref.invalidate(bilanSummaryProvider);
                ref.invalidate(bilanBreakdownProvider);
              },
            ),
          ],
        ),
      ),
    );
  }
}
