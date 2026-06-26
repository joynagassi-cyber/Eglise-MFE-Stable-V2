import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
// import '../../../../core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/features/bible/data/services/bible_download_service.dart';
import 'package:lumina/features/bible/core/services/bible_import_service.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class BibleOfflineScreen extends ConsumerStatefulWidget {
  const BibleOfflineScreen({super.key});

  @override
  ConsumerState<BibleOfflineScreen> createState() => _BibleOfflineScreenState();
}

class _BibleOfflineScreenState extends ConsumerState<BibleOfflineScreen> {
  final List<String> _translations = ['ls1910', 'kjv', 'darby', 'bds'];
  Map<String, int> _downloadedCounts = {};
  final int _totalChaptersPerBible = 1189;

  @override
  void initState() {
    super.initState();
    _checkCache();
  }

  Future<void> _checkCache() async {
    final Map<String, int> counts = {};
    for (final t in _translations) {
      counts[t] = await ref
          .read(bibleDownloadServiceProvider.notifier)
          .getDownloadedChaptersCount(t);
    }
    if (mounted) {
      setState(() {
        _downloadedCounts = counts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final importState = ref.watch(bibleImportServiceProvider);

    // Auto-update count when import completes
    if (!importState.isImporting && importState.progress == 1.0) {
      _checkCache();
    }

    final totalDownloaded = _downloadedCounts.values.fold(0, (a, b) => a + b);
    final totalExpected = _translations.length * _totalChaptersPerBible;
    final isFullyDownloaded = totalDownloaded >= totalExpected;
    final percentage = totalExpected > 0
        ? (totalDownloaded / totalExpected * 100).clamp(0, 100).toInt()
        : 0;

    return Scaffold(
      backgroundColor: context.colors.bgPrimary,
      appBar: GlassAppBar(
        title: const Text('MODE HORS-LIGNE'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: context.colors.iconPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: AppSpacing.xxl),
            if (importState.isImporting) ...[
              _buildProgressSection(importState),
              const SizedBox(height: AppSpacing.xxl),
            ],
            _buildStatusCard(
                isFullyDownloaded, percentage, totalDownloaded, totalExpected),
            const SizedBox(height: AppSpacing.xxl),
            _buildActionButtons(
                importState, isFullyDownloaded, totalDownloaded),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(Icons.auto_awesome_rounded,
            size: 64, color: context.colors.accent.withOpacity(0.8)),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Bible Locale',
          style: AppTypography.h3.copyWith(color: context.colors.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Rendez la Bible entièrement disponible hors-ligne en quelques secondes.',
          style: AppTypography.editorialDisplay
              .copyWith(color: context.colors.textSecondary, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatusCard(bool isFullyDownloaded, int percentage,
      int totalDownloaded, int totalExpected) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      backgroundColor: context.colors.bgCard,
      borderRadius: 16,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Louis Segond 1910',
                style: AppTypography.editorialSection
                    .copyWith(color: context.colors.accent, fontSize: 14),
              ),
              Icon(
                isFullyDownloaded
                    ? Icons.check_circle_rounded
                    : Icons.info_outline_rounded,
                color: isFullyDownloaded ? context.colors.successText : context.colors.textTertiary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chapitres disponibles',
                    style: AppTypography.editorialDisplay
                        .copyWith(color: context.colors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$totalDownloaded ',
                          style: AppTypography.h2
                              .copyWith(color: context.colors.textPrimary, fontSize: 24),
                        ),
                        TextSpan(
                          text: '/ $totalExpected',
                          style: AppTypography.h2
                              .copyWith(color: context.colors.textTertiary, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                '$percentage%',
                style: AppTypography.editorialSection.copyWith(
                  color: isFullyDownloaded
                      ? context.colors.successText
                      : context.colors.accent,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BibleImportState state) {
    return Column(
      children: [
        Text(
          'Importation en cours...',
          style: AppTypography.editorialSection
              .copyWith(color: context.colors.textPrimary, fontSize: 14),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (state.currentItem != null)
          Text(
            state.currentItem!,
            style: AppTypography.editorialDisplay
                .copyWith(color: context.colors.accent, fontSize: 16),
          ),
        const SizedBox(height: AppSpacing.md),
        AppProgressBar(
          value: state.progress > 0 ? state.progress : null,
          backgroundColor: context.colors.borderSubtle,
          color: context.colors.accent,
          height: 8,
          borderRadius: 4,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '${(state.progress * 100).toStringAsFixed(1)}%',
          style: AppTypography.editorialSection
              .copyWith(color: context.colors.textTertiary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
      BibleImportState state, bool isFullyDownloaded, int totalDownloaded) {
    if (state.isImporting) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colors.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.accent.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: LoadingDots(size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Text('Importation optimisée...',
                style: TextStyle(color: context.colors.textSecondary)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isFullyDownloaded)
          GradientButton(
            text: totalDownloaded > 0
                ? 'RÉINITIALISER ET RÉIMPORTER'
                : 'ACTIVER LE MODE HORS-LIGNE',
            onPressed: () {
              ref.read(bibleImportServiceProvider.notifier).importAllBibles();
            },
            gradient: context.colors.brandGradient,
          ),
        const SizedBox(height: AppSpacing.md),
        if (totalDownloaded > 0)
          TextButton.icon(
            onPressed: () => _showClearCacheConfirm(context),
            icon: Icon(Icons.delete_outline,
                color: context.colors.errorIcon, size: 20),
            label: Text('Désactiver le mode hors-ligne',
                style: TextStyle(color: context.colors.errorText)),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: context.colors.errorBorder),
              ),
            ),
          ),
      ],
    );
  }

  void _showClearCacheConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.bgPrimary,
        title: Text('Désactiver ?',
            style: TextStyle(color: context.colors.errorText)),
        content: Text(
          'Cela effacera les chapitres stockés sur votre téléphone. Les notes et bookmarks seront conservés.',
          style: TextStyle(color: context.colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler', style: TextStyle(color: context.colors.textDisabled)),
          ),
          GradientButton(
            text: 'DÉSACTIVER',
            onPressed: () async {
              Navigator.pop(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              await ref
                  .read(bibleDownloadServiceProvider.notifier)
                  .clearAllTranslations();
              await _checkCache();
              if (context.mounted) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                      content: const Text('Mode hors-ligne désactivé'),
                      backgroundColor: context.colors.successBg),
                );
              }
            },
            gradient: LinearGradient(
                colors: [context.colors.errorIcon, context.colors.errorBorder]),
          ),
        ],
      ),
    );
  }
}
