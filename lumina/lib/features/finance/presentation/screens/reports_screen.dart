// lib/features/finance/presentation/screens/reports_screen.dart
// Rapports Financiers - Deep Purple Theme

import 'dart:async';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/features/finance/presentation/providers/finance_providers.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(reportActionsProvider);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = context.colors.textPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rapports Financiers',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 100),
              child: _buildIllustration(isDark),
            ),
            SizedBox(height: AppSpacing.xl),
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 200),
              child: Text(
                'Générer un rapport mensuel',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 300),
              child: Text(
                'Sélectionnez le mois pour lequel vous souhaitez générer le rapport PDF détaillé.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 400),
              child: _buildMonthSelector(isDark, theme),
            ),
            SizedBox(height: AppSpacing.xl),
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 500),
              child: state.isGenerating
                  ? Center(
                      child: LoadingState(
                        message: 'Génération du rapport...',
                      ),
                    )
                  : Column(
                      children: [
                        GradientButton(
                          text: 'GÉNÉRER RAPPORT PDF',
                          icon: Icons.picture_as_pdf_rounded,
                          onPressed: () async {
                            await HapticHelper.medium();
                            unawaited(ref
                                .read(reportActionsProvider.notifier)
                                .generateMonthlyReport(
                                  _selectedDate,
                                  isPdf: true,
                                ));
                          },
                        ),
                        SizedBox(height: AppSpacing.md),
                        GradientButton(
                          text: 'GÉNÉRER RAPPORT EXCEL',
                          icon: Icons.table_chart_rounded,
                          onPressed: () async {
                            await HapticHelper.medium();
                            unawaited(ref
                                .read(reportActionsProvider.notifier)
                                .generateMonthlyReport(
                                  _selectedDate,
                                  isPdf: false,
                                ));
                          },
                        ),
                      ],
                    ),
            ),
            if (state.reportPath != null && !state.isGenerating) ...[
              SizedBox(height: AppSpacing.xl),
              AnimatedEntrance.fromBottom(
                delay: const Duration(milliseconds: 100),
                child: _buildSuccessActions(context, state.reportPath!, theme),
              ),
            ],
            if (state.hasError) ...[
              SizedBox(height: AppSpacing.lg),
              AnimatedEntrance.fromBottom(
                delay: const Duration(milliseconds: 600),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: context.colors.errorText.withValues(alpha: 0.1),
                    borderRadius: AppSpacing.borderRadiusMd,
                    border: Border.all(
                      color: context.colors.errorText.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: context.colors.errorText),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          state.error ?? 'Une erreur est survenue',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: context.colors.errorText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(bool isDark) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: context.colors.brandPrimaryGradient,
        borderRadius: AppSpacing.borderRadiusCard,
        boxShadow: AppSpacing.shadowPrimary(context.colors.brandPrimary),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.description_rounded,
              size: 150,
              color: context.colors.textOnBrand.withValues(alpha: 0.1),
            ),
          ),
          Center(
            child: Icon(
              Icons.picture_as_pdf_rounded,
              size: 70,
              color: context.colors.textOnBrand,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(bool isDark, ThemeData theme) {
    return Semantics(
      label:
          'Sélectionner le mois, actuellement ${DateFormat('MMMM yyyy', 'fr_FR').format(_selectedDate)}',
      button: true,
      enabled: true,
      child: InkWell(
        onTap: () async {
          await HapticHelper.light();
          unawaited(_pickMonth());
        },
        borderRadius: AppSpacing.borderRadiusMd,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: context.colors.bgCard,
            borderRadius: AppSpacing.borderRadiusMd,
            border: Border.all(
              color: context.colors.borderSubtle,
            ),
            boxShadow: AppSpacing.shadowSm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MOIS SÉLECTIONNÉ',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxs),
                  Text(
                    DateFormat(
                      'MMMM yyyy',
                      'fr_FR',
                    ).format(_selectedDate).toUpperCase(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.brandPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm + 2),
                decoration: BoxDecoration(
                  color: context.colors.brandPrimary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.calendar_month_rounded,
                  color: context.colors.brandPrimary,
                  size: AppSpacing.iconLg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessActions(
    BuildContext context,
    String path,
    ThemeData theme,
  ) {
    final fileName = path.split('/').last;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.brandPrimary.withValues(alpha: 0.05),
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: context.colors.brandPrimary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_rounded,
                color: context.colors.successText,
                size: 28,
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rapport généré avec succès !',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    Text(
                      'Sauvegardé dans "Gestion Totale"',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await HapticHelper.light();
                    unawaited(ref
                        .read(reportActionsProvider.notifier)
                        .openLastReport());
                  },
                  icon: Icon(Icons.open_in_new_rounded),
                  label: Text('OUVRIR'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.colors.brandPrimary,
                    side: BorderSide(color: context.colors.brandPrimary),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await HapticHelper.medium();
                    if (!context.mounted) return;
                    unawaited(ref
                        .read(reportActionsProvider.notifier)
                        .shareLastReport(context, fileName));
                  },
                  icon: Icon(Icons.share_rounded),
                  label: Text('PARTAGER'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.brandPrimary,
                    foregroundColor: context.colors.textOnBrand,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.year,
      locale: const Locale('fr', 'FR'),
      helpText: 'Sélectionner le mois du rapport',
      cancelText: 'Annuler',
      confirmText: 'Confirmer',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: context.colors.brandPrimary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      await HapticHelper.selection();
      setState(() => _selectedDate = picked);
    }
  }
}
