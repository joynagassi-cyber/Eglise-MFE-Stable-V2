import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/widgets/navigation_hierarchy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/services/storage/report_storage_service.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/utils/haptic_helper.dart';

final reportsHistoryProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
  ref,
  churchId,
) async {
  return await ReportStorageService().getReports(churchId: churchId);
});

class ReportsHistoryScreen extends ConsumerWidget {
  final String churchId;

  const ReportsHistoryScreen({super.key, required this.churchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportsHistoryProvider(churchId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: BreadcrumbAppBar(
        currentLocation: '/ministere/reports/history',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: AppSpacing.iconMd),
            onPressed: () async {
              await HapticHelper.light();
              ref.invalidate(reportsHistoryProvider(churchId));
            },
          ).withTouchTarget(),
        ],
      ),
      body: reports.when(
        data: (data) => data.isEmpty
            ? const AnimatedEntrance.fromBottom(
                child: EmptyState(
                  icon: Icons.history_rounded,
                  title: 'Aucun rapport sauvegardé',
                  subtitle: 'Les rapports générés apparaîtront ici',
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                itemCount: data.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  return AnimatedEntrance.fromBottom(
                    delay: Duration(milliseconds: 100 + (index * 50)),
                    child: _ReportCard(report: data[index], churchId: churchId),
                  );
                },
              ),
        loading: () => const ShimmerCardList(
          itemCount: 5,
          itemHeight: 100,
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: context.colors.errorText),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Une erreur est survenue lors du chargement',
                style: theme.textTheme.bodyMedium?.copyWith(color: context.colors.errorText),
              ),
              const SizedBox(height: AppSpacing.lg),
              GradientButton(
                text: 'RÉESSAYER',
                onPressed: () => ref.invalidate(reportsHistoryProvider(churchId)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportCard extends ConsumerWidget {
  final Map<String, dynamic> report;
  final String churchId;

  const _ReportCard({required this.report, required this.churchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final type = report['type'] as String;
    final title = report['title'] as String;
    final createdAt = DateTime.parse(report['created_at'] as String);
    final fileSize = report['file_size'] as int?;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: context.colors.borderSubtle.withValues(alpha: 0.2),
        ),
        boxShadow: AppSpacing.shadowSm,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await HapticHelper.light();
            if (context.mounted) {
              await _downloadReport(context, ref);
            }
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getTypeColor(context, type).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_getTypeIcon(type), color: _getTypeColor(context, type), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd/MM/yyyy • HH:mm', 'fr_FR').format(createdAt),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      if (fileSize != null)
                        Text(
                          '${(fileSize / 1024).toStringAsFixed(1)} KB',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: context.colors.textSecondary.withValues(alpha: 0.7),
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 20),
                      color: context.colors.errorText,
                      onPressed: () async {
                        await HapticHelper.medium();
                        if (context.mounted) {
                          await _deleteReport(context, ref);
                        }
                      },
                    ).withTouchTarget(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'event':
        return Icons.event_rounded;
      case 'member':
        return Icons.people_rounded;
      case 'finance':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.description_rounded;
    }
  }

  Color _getTypeColor(BuildContext context, String type) {
    switch (type) {
      case 'event':
        return context.colors.brandPrimary;
      case 'member':
        return context.colors.brandSecondary;
      case 'finance':
        return context.colors.successText;
      default:
        return context.colors.textTertiary;
    }
  }

  Future<void> _downloadReport(BuildContext context, WidgetRef ref) async {
    try {
      final url = await ReportStorageService().getDownloadUrl(
        report['file_path'],
      );
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Impossible de télécharger le rapport')));
      }
    }
  }

  Future<void> _deleteReport(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le rapport'),
        content: const Text('Cette action est irréversible.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Supprimer', style: TextStyle(color: context.colors.errorText, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ReportStorageService().deleteReport(
          report['id'],
          report['file_path'],
        );
        ref.invalidate(reportsHistoryProvider(churchId));
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Rapport supprimé')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Erreur lors de la suppression')));
        }
      }
    }
  }
}
