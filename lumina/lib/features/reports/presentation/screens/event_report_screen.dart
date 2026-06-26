import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/widgets/navigation_hierarchy.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../providers/event_report_provider.dart';
import '../../../../core/providers/auth_provider.dart';

class EventReportScreen extends ConsumerStatefulWidget {
  const EventReportScreen({super.key});

  @override
  ConsumerState<EventReportScreen> createState() => _EventReportScreenState();
}

class _EventReportScreenState extends ConsumerState<EventReportScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  final _churchNameController = TextEditingController(
    text: 'Église Lumina',
  );

  @override
  void dispose() {
    _churchNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportState = ref.watch(eventReportGeneratorProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const BreadcrumbAppBar(
        currentLocation: '/ministere/reports/event',
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppSpacing.md),
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 100),
              child: SectionHeader(
                title: 'Paramètres du rapport',
                subtitle: 'Configurez la période et les détails',
                icon: Icons.settings_suggest_rounded,
                gradient: context.colors.brandGradient,
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: context.colors.borderSubtle.withValues(alpha: 0.2),
                  ),
                  boxShadow: AppSpacing.shadowSm,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Semantics(
                      label: 'Nom de l\'église',
                      textField: true,
                      child: TextField(
                        controller: _churchNameController,
                        decoration: InputDecoration(
                          labelText: 'Nom de l\'église',
                          prefixIcon: Icon(Icons.church_rounded, color: context.colors.brandPrimary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    
                    // Date Selection Area
                    _DateSelector(
                      label: 'Date de début',
                      date: _startDate,
                      onTap: () async {
                        await HapticHelper.light();
                        if (!context.mounted) return;
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          locale: const Locale('fr', 'FR'),
                          helpText: 'SÉLECTIONNER LA DATE DE DÉBUT',
                        );
                        if (date != null) {
                          await HapticHelper.selection();
                          setState(() => _startDate = date);
                        }
                      },
                    ),
                    Divider(height: 32),
                    _DateSelector(
                      label: 'Date de fin',
                      date: _endDate,
                      onTap: () async {
                        await HapticHelper.light();
                        if (!context.mounted) return;
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: _startDate,
                          lastDate: DateTime.now(),
                          locale: const Locale('fr', 'FR'),
                          helpText: 'SÉLECTIONNER LA DATE DE FIN',
                        );
                        if (date != null) {
                          await HapticHelper.selection();
                          if (!context.mounted) return;
                          setState(() => _endDate = date);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: AppSpacing.xxl),
            
            reportState.when(
              data: (file) => file != null
                  ? AnimatedEntrance.fromBottom(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: context.colors.successBg.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.check_circle_rounded,
                              color: context.colors.successText,
                              size: 64,
                            ),
                          ),
                          SizedBox(height: AppSpacing.md),
                          Text(
                            'Rapport généré avec succès',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            'Fichier: ${file.path.split('/').last}',
                            style: theme.textTheme.bodySmall,
                          ),
                          SizedBox(height: AppSpacing.lg),
                          GradientButton(
                            text: 'Générer un autre rapport',
                            onPressed: () => ref.invalidate(eventReportGeneratorProvider),
                          ),
                        ],
                      ),
                    )
                  : GradientButton(
                      text: 'GÉNÉRER LE RAPPORT',
                      icon: Icons.auto_awesome_rounded,
                      onPressed: _generateReport,
                    ),
              loading: () => Center(
                child: Column(
                  children: [
                    LoadingDots(size: 40),
                    SizedBox(height: AppSpacing.md),
                    Text('Génération en cours...', 
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              error: (e, _) => Column(
                children: [
                  Icon(Icons.error_outline_rounded, 
                    color: context.colors.errorText, 
                    size: 64,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text('Erreur de génération',
                    style: TextStyle(color: context.colors.errorText, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppSpacing.md),
                  GradientButton(
                    text: 'RÉESSAYER',
                    onPressed: _generateReport,
                    gradient: LinearGradient(colors: [context.colors.errorText, context.colors.errorText.withValues(alpha: 0.8)]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateReport() async {
    await HapticHelper.medium();
    try {
      await ref.read(eventReportGeneratorProvider.notifier).generateAndDownload(
            churchName: _churchNameController.text,
            churchId: ref.read(activeChurchIdProvider) ?? 'global',
            startDate: _startDate,
            endDate: _endDate,
            saveToSupabase: true,
          );
      await HapticHelper.success();
    } catch (e) {
      await HapticHelper.error();
    }
  }
}

class _DateSelector extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DateSelector({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(
        DateFormat('dd MMMM yyyy', 'fr_FR').format(date),
        style: TextStyle(
          color: context.colors.brandPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.colors.brandPrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.calendar_month_rounded,
          size: 20,
          color: context.colors.brandPrimary,
        ),
      ),
      onTap: onTap,
    ).withTouchTarget();
  }
}
