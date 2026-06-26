import "package:lumina/core/widgets/widgets.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import '../providers/dashboard_kpi_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/extensions/context_extension.dart';

class GroupDashboardView extends ConsumerWidget {
  const GroupDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpiAsync = ref.watch(dashboardKpiProvider);

    return kpiAsync.when(
      data: (stats) => SingleChildScrollView(
        padding: const EdgeInsets.all(LuminaDesign.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, "Gestion du Groupe"),
            SizedBox(height: LuminaDesign.paddingLg),
            _buildKPIs(context, stats),
            SizedBox(height: LuminaDesign.paddingLg),
            _buildActions(context),
            SizedBox(height: LuminaDesign.paddingLg),
            _buildSectionTitle(context, "Alertes de Vigilance"),
            _buildAlerts(stats, context),
          ],
        ),
      ),
      loading: () => const LoadingState(),
      error: (e, st) => Center(child: Text("Erreur de chargement")),
    );
  }

  Widget _buildHeader(context, BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("ESPACE RESPONSABLE", style: LuminaDesign.labelOf(context)),
        Text(title, style: LuminaDesign.h1Of(context)),
      ],
    );
  }

  Widget _buildKPIs(context, BuildContext context, var stats) {
    return Row(
      children: [
        Expanded(
          child: LuminaCard(
            color: LuminaDesign.primary.withOpacity(0.05),
            child: Column(
              children: [
                Text("Membres", style: LuminaDesign.labelOf(context)),
                Text("${stats.membersCount}", style: LuminaDesign.h2Of(context)),
              ],
            ),
          ),
        ),
        SizedBox(width: LuminaDesign.paddingMd),
        Expanded(
          child: LuminaCard(
            color: Colors.green.withOpacity(0.05),
            child: Column(
              children: [
                Text("Caisse", style: LuminaDesign.labelOf(context)),
                Text("${stats.balance.toInt()} F", style: LuminaDesign.h2Of(context)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        LuminaButton(
          label: "Prendre les présences",
          icon: Icons.checklist_rtl_rounded,
          onPressed: () => context.push(AppRoutes.equipe),
        ),
        SizedBox(height: LuminaDesign.paddingMd),
        Row(
          children: [
            Expanded(
              child: LuminaCard(
                onTap: () => context.push(AppRoutes.brebis),
                child: Column(
                  children: [
                    Icon(Icons.person_add_alt_1, color: LuminaDesign.primary),
                    Text("Nouveau"),
                  ],
                ),
              ),
            ),
            SizedBox(width: LuminaDesign.paddingMd),
            Expanded(
              child: LuminaCard(
                onTap: () => context.push(AppRoutes.financeHistory),
                child: Column(
                  children: [
                    Icon(Icons.history, color: context.colors.textTertiary),
                    Text("Historique"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlerts(var stats, BuildContext context) {
    return Column(
      children: [
        if (stats.birthdaysCount > 0)
          LuminaCard(
            color: Colors.pink.withOpacity(0.05),
            onTap: () => context.push(AppRoutes.brebis),
            child: Row(
              children: [
                Icon(Icons.cake_rounded, color: Colors.pink),
                SizedBox(width: 16),
                Text("${stats.birthdaysCount} Anniversaires cette semaine"),
              ],
            ),
          ),
        if (stats.absenceAlertsCount > 0)
          LuminaCard(
            color: Colors.orange.withOpacity(0.05),
            onTap: () => context.push(AppRoutes.equipe),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange),
                SizedBox(width: 16),
                Text("${stats.absenceAlertsCount} Absences prolongées"),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(context, BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: LuminaDesign.paddingMd),
      child: Text(title.toUpperCase(), style: LuminaDesign.labelOf(context)),
    );
  }
}
