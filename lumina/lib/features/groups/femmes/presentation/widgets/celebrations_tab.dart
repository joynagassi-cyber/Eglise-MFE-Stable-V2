import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/femmes_providers.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/utils/haptic_helper.dart';

class CelebrationsTab extends ConsumerWidget {
  final String groupId;
  final Color accentColor;

  const CelebrationsTab({
    super.key,
    required this.groupId,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpiAsync = ref.watch(femmesDashboardProvider(groupId));

    return kpiAsync.when(
      data: (kpi) => ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Anniversaires du mois',
            style:
                AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if ((kpi['upcoming_birthdays'] as List).isEmpty)
            const Text('Aucun anniversaire ce mois-ci')
          else
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: kpi['upcoming_birthdays'].length,
                itemBuilder: (context, index) {
                  final member = kpi['upcoming_birthdays'][index];
                  return _BirthdayMemberCard(member: member);
                },
              ),
            ),
          const SizedBox(height: 24),
          Text(
            'Événements à venir',
            style:
                AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const _UpcomingEventCard(
            title: 'Fête des Mères',
            date: '25 Mai',
            type: 'Célébration',
          ),
          const _UpcomingEventCard(
            title: 'Conférence Féminine',
            date: '12 Juin',
            type: 'Rassemblement',
          ),
        ],
      ),
      loading: () => const Center(
        child: LoadingDots(),
      ),
      error: (e, _) => AppErrorWidget(message: e.toString()),
    );
  }
}

class _BirthdayMemberCard extends StatelessWidget {
  final dynamic member;

  const _BirthdayMemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      child: Column(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: context.colors.brandPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cake_rounded,
                    color: context.colors.textInverse,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            member.name ?? "Membre",
            style: AppTypography.tiny.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () async {
              await HapticHelper.medium();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Voeux : Bientôt disponible')),
                );
              }
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 20),
            ),
            child: Text(
              'Voeux',
              style: TextStyle(fontSize: 10, color: context.colors.brandPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingEventCard extends StatelessWidget {
  final String title;
  final String date;
  final String type;

  const _UpcomingEventCard({
    required this.title,
    required this.date,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.brandPrimary.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.colors.brandPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.star_rounded,
              color: context.colors.brandPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelLarge
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$type • $date',
                  style: AppTypography.tiny.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
