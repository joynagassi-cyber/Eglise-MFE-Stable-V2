// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/femmes_providers.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'request_card.dart';
import 'mutual_aid_chart.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class MutualAidTab extends ConsumerWidget {
  final String groupId;
  final Color accentColor;

  const MutualAidTab({
    super.key,
    required this.groupId,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(mutualAidRequestsProvider(groupId));
    final dashKpiAsync = ref.watch(femmesDashboardProvider(groupId));

    return requestsAsync.when(
      data: (requests) => Column(
        children: [
          _buildMiniStats(context, dashKpiAsync),
          if (requests.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Card(
                elevation: 0,
                color: context.colors.bgCard.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: accentColor.withValues(alpha: 0.1)),
                ),
                child: MutualAidChart(requests: requests),
              ),
            ),
          SizedBox(height: AppSpacing.md),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: requests.length > 5 ? 5 : requests.length,
              itemBuilder: (context, index) {
                final req = requests[index];
                return RequestCard(request: req);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ElevatedButton.icon(
              onPressed: () async {
                await HapticHelper.medium();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Soumettre demande : Bientôt disponible')),
                  );
                }
              },
              icon: Icon(Icons.add_rounded, color: context.colors.textInverse),
              label: Text('Soumettre demande'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: context.colors.textInverse,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
      loading: () => Center(
        child: LoadingDots(),
      ),
      error: (e, _) => AppErrorWidget(message: e.toString()),
    );
  }

  Widget _buildMiniStats(BuildContext context, AsyncValue<Map<String, dynamic>> kpiAsync) {
    return kpiAsync.when(
      data: (kpi) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _MiniStat(
              label: 'Actives',
              value: '${kpi['active_requests']}',
              color: context.colors.infoText,
            ),
            _MiniStat(
              label: 'Réponses',
              value: '${kpi['responses_this_month']}',
              color: context.colors.successText,
            ),
            _MiniStat(
              label: 'Clôturées',
              value: '${kpi['closed_requests']}',
              color: context.colors.textSecondary,
            ),
          ],
        ),
      ),
      loading: () => const ShimmerBox(height: 50),
      error: (_, __) => SizedBox(),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.h3.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: AppTypography.tiny.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}