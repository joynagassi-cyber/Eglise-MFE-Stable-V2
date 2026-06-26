import 'package:flutter/material.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/l10n/app_localizations.dart';
import 'package:lumina/features/dashboard/presentation/widgets/premium_dashboard_scaffold.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/pdf_export_service.dart';
import '../domain/services/audit_service.dart';
import '../../../../core/providers/user_context_provider.dart';
import '../../../core/providers/auth_provider.dart';
import 'widgets/audit_filters_bar.dart';
import 'widgets/audit_anomaly_list.dart';
import 'widgets/audit_timeline.dart';

class AuditDashboardScreen extends ConsumerWidget {
  const AuditDashboardScreen({super.key});

  Future<void> _exportAuditPdf(
    BuildContext context,
    WidgetRef ref,
    String churchName,
    StorageService storageService,
  ) async {
    // ... same implementation as before ...
    final anomalies = ref.read(auditAnomaliesProvider);
    final period = DateTimeRange(
      start: ref.read(auditFilterStartDateProvider) ??
          DateTime.now().subtract(const Duration(days: 30)),
      end: ref.read(auditFilterEndDateProvider) ?? DateTime.now(),
    );

    if (anomalies.isNotEmpty) {
      try {
        final pdfBytes = await PdfExportService.generateAuditPdf(
          anomalies: anomalies,
          churchName: churchName,
          period: period,
        );

        final fileName =
            'Audit_${churchName}_${DateTime.now().millisecondsSinceEpoch}.pdf';

        final activeChurchId = ref.read(activeChurchIdProvider);
        final authStateVal = ref.read(authProvider).valueOrNull;

        final file = await storageService.saveAndProcessReport(
          fileName: fileName,
          bytes: pdfBytes,
          uploadToCloud: true,
          entityType: 'audit_report',
          entityId: 'audit_${DateTime.now().millisecondsSinceEpoch}',
          churchId: activeChurchId,
          token: authStateVal?.accessToken,
        );

        if (!context.mounted) return;
        await storageService.openFile(file);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.auditReportSaved),
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.exportError(e.toString()),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userContext = ref.watch(userContextNotifierProvider).valueOrNull;
    final churchName = userContext?.group?.label ?? 'Mon Église';
    final storageService = ref.watch(storageServiceProvider);

    return PremiumDashboardScaffold(
      title: AppLocalizations.of(context)!.auditSecurity,
      subtitle: AppLocalizations.of(context)!.surveillanceReports,
      headerAction: IconButton(
        icon: const Icon(Icons.picture_as_pdf),
        onPressed: () =>
            _exportAuditPdf(context, ref, churchName, storageService),
      ),
      onRefresh: () async {
        // Refresh logic - e.g. ref.refresh(auditAnomaliesProvider)
        // Since providers might be auto-dispose or listened to, we can just trigger a refresh
        // For now, simple no-op or explicit refresh if we knew the providers better
      },
      body: const SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            AuditFiltersBar(),
            SizedBox(height: AppSpacing.md),
            AuditAnomalyList(),
            Divider(height: AppSpacing.xl, thickness: 0.5),
            AuditTimeline(),
            SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}