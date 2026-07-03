import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/services/pdf_export_service.dart';

import '../../../../core/providers/auth_provider.dart';

import '../providers/bilan_providers.dart';
import '../widgets/bilan_filters_bar.dart';
import '../widgets/bilan_pdf_customizer.dart';
import '../widgets/bilan_oil_mode_banner.dart';
import '../widgets/bilan_overview_tab.dart';
import '../widgets/bilan_budget_tab.dart';
import '../widgets/bilan_dimensions_tab.dart';
import '../widgets/bilan_seal_tab.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';
import 'package:intl/intl.dart';
class BilanScreen extends ConsumerStatefulWidget {
  const BilanScreen({super.key});

  @override
  ConsumerState<BilanScreen> createState() => _BilanScreenState();
}

class _BilanScreenState extends ConsumerState<BilanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(bilanActiveTabProvider.notifier).state =
            _tabController.index;
      }
    });

    // Setup initial index from provider (in case of deep linking or state restoration)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activeTabIndex = ref.read(bilanActiveTabProvider);
      if (activeTabIndex != _tabController.index) {
        _tabController.animateTo(activeTabIndex);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _exportBilanPdf(
    BuildContext context,
    StorageService storageService,
  ) async {
    final summary = ref.read(consolidatedBilanProvider).valueOrNull;
    final breakdown = ref.read(bilanPerGroupProvider).valueOrNull;
    final branding = ref.read(churchBrandingProvider).valueOrNull;
    final activeChurchId = ref.read(activeChurchIdProvider);
    final authStateVal = ref.read(authProvider).valueOrNull;

    if (summary != null && breakdown != null && branding != null) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => BilanPdfCustomizer(
          onCancel: () => Navigator.pop(context),
          onConfirm: (options) async {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: LoadingDots(size: 24),
                    ),
                    SizedBox(width: 16),
                    Text(context.l10n.bilan_export_pdf),
                  ],
                ),
                duration: const Duration(seconds: 2),
              ),
            );

            try {
              final pdfBytes = await PdfExportService.generateBilanPdf(
                summary: summary,
                categoryBreakdown: breakdown,
                branding: branding,
                period: DateTimeRange(
                  start: summary.periodStart ?? DateTime.now(),
                  end: summary.periodEnd ?? DateTime.now(),
                ),
                options: options,
              );

              final fileName =
                  'Bilan_${branding.name}_${DateTime.now().millisecondsSinceEpoch}.pdf';

              final file = await storageService.saveAndProcessReport(
                fileName: fileName,
                bytes: pdfBytes,
                uploadToCloud: true,
                entityType: 'bilan_report',
                entityId: 'bilan_${DateTime.now().millisecondsSinceEpoch}',
                churchId: activeChurchId,
                token: authStateVal?.accessToken,
              );

              if (!context.mounted) return;
              await storageService.openFile(file);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.bilan_report_ready),
                  backgroundColor: context.colors.successText,
                ),
              );
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Impossible de télécharger le rapport PDF'),
                    backgroundColor: context.colors.errorText),
              );
            }
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.bilan_data_incomplete)),
      );
    }
  }

  Future<void> _exportFec(
    BuildContext context,
    StorageService storageService,
  ) async {
    final activeChurchId = ref.read(activeChurchIdProvider);
    final range = ref.read(bilanComputedDateRangeProvider);
    
    final repo = ref.read(bilanRepositoryProvider);
    final fecService = ref.read(fecExportServiceProvider);
    final authStateVal = ref.read(authProvider).valueOrNull;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Préparation de l\'export FEC (OHADA)...')),
    );

    try {
      final lines = await repo.getFecLines(
        churchId: activeChurchId,
        startDate: range.start,
        endDate: range.end,
      );

      if (lines.isEmpty) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucune donnée à exporter pour cette période')),
        );
        return;
      }

      final csvBytes = fecService.generateFecCsv(lines);
      final fileName = 'FEC_OHADA_${activeChurchId}_${DateFormat('yyyyMM').format(range.start)}.csv';

      final file = await storageService.saveAndProcessReport(
        fileName: fileName,
        bytes: csvBytes,
        uploadToCloud: true,
        entityType: 'fec_export',
        entityId: 'fec_${DateTime.now().millisecondsSinceEpoch}',
        churchId: activeChurchId,
        token: authStateVal?.accessToken,
      );

      if (!context.mounted) return;
      await storageService.openFile(file);
      
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export FEC prêt'),
          backgroundColor: context.colors.successText,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'export FEC'),
          backgroundColor: context.colors.errorText,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final storageService = ref.watch(storageServiceProvider);
    final isOilMode = ref.watch(bilanOilModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.bilan_title),
        actions: [
          IconButton(
            tooltip: 'Mode Onction (Masquer Noms)',
            icon: Icon(
              isOilMode ? Icons.visibility_off : Icons.visibility,
              color: isOilMode ? context.colors.warningText : null,
            ),
            onPressed: () {
              ref.read(bilanOilModeProvider.notifier).state = !isOilMode;
            },
          ),
          IconButton(
            tooltip: context.l10n.bilan_export_pdf,
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () => _exportBilanPdf(context, storageService),
          ),
          IconButton(
            tooltip: 'Exporter FEC (Expert)',
            icon: Icon(Icons.file_download_outlined),
            onPressed: () => _exportFec(context, storageService),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard_rounded), text: 'Vue d\'ensemble'),
            Tab(icon: Icon(Icons.track_changes_rounded), text: 'Budget vs Réel'),
            Tab(icon: Icon(Icons.analytics_rounded), text: 'Dimensions'),
            Tab(icon: Icon(Icons.lock_rounded), text: 'Clôture & Audit'),
          ],
        ),
      ),
      body: Column(
        children: [
          const BilanOilModeBanner(),
          const BilanFiltersBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                BilanOverviewTab(),
                BilanBudgetTab(),
                BilanDimensionsTab(),
                BilanSealTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
