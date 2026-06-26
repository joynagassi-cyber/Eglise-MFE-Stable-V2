// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../domain/entities/member.dart';
import '../providers/member_attendance_360_provider.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class MemberAttendanceHistoryDialog extends ConsumerWidget {
  final Member member;

  const MemberAttendanceHistoryDialog({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(memberAttendance360Provider(member.id));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            statsAsync.when(
              data: (stats) => Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildOverview(context, stats),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      'Historique Récent',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Flexible(
                      child: _buildHistoryList(context, stats.history),
                    ),
                  ],
                ),
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xxl),
                  child: LoadingState(message: 'Calcul de l\'assiduité...'),
                ),
              ),
              error: (e, _) => AppErrorWidget(message: e.toString()),
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: AppButton.text(
                label: 'Fermer',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      children: [
        AvatarWidget(
          imageUrl: member.photoUrl,
          fallbackName: member.fullName,
          size: 48,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.fullName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Vue Assiduité 360°',
                style: TextStyle(
                  fontSize: 12,
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverview(BuildContext context, MemberAttendanceStats stats) {
    final ratePercent = (stats.attendanceRate * 100).toInt();
    final color = stats.attendanceRate >= 0.8
        ? context.colors.successText
        : (stats.attendanceRate >= 0.5 ? context.colors.warningText : context.colors.errorText);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, 'Séances', stats.totalSessions.toString()),
          _buildStatItem(context, 'Présences', stats.attendedSessions.toString()),
          _buildStatItem(context, 'Taux', '$ratePercent%', color: color),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
              fontSize: 11,
              color: color?.withValues(alpha: 0.7) ?? context.colors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildHistoryList(
      BuildContext context, List<UnifiedAttendanceRecord> history) {
    if (history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Center(child: Text('Aucun historique disponible')),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: history.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: context.colors.borderSubtle.withValues(alpha: 0.3)),
      itemBuilder: (context, index) {
        final record = history[index];
        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: record.source == 'Groupe'
                  ? context.colors.brandSecondary.withValues(alpha: 0.1)
                  : context.colors.brandPrimary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              record.source == 'Groupe'
                  ? Icons.group_rounded
                  : Icons.church_rounded,
              size: 14,
              color: record.source == 'Groupe'
                  ? context.colors.brandSecondary
                  : context.colors.brandPrimary,
            ),
          ),
          title: Text(
            '${record.source} - ${DateFormat('dd MMM').format(record.date)}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: record.notes != null
              ? Text(record.notes!,
                  maxLines: 1, overflow: TextOverflow.ellipsis)
              : null,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: record.isPresent
                  ? context.colors.successText.withValues(alpha: 0.1)
                  : context.colors.errorText.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              record.status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: record.isPresent ? context.colors.successText : context.colors.errorText,
              ),
            ),
          ),
        );
      },
    );
  }
}