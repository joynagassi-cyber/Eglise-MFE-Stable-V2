import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:go_router/go_router.dart';

import '../providers/dashboard_kpi_provider.dart';
import '../../../../core/extensions/context_extension.dart';


class SuperadminDashboardView extends ConsumerWidget {
  const SuperadminDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpiAsync = ref.watch(dashboardKpiProvider);

    return kpiAsync.when(
      data: (stats) => SingleChildScrollView(
        padding: const EdgeInsets.all(LuminaDesign.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("Centre de Pilotage"),
            const SizedBox(height: LuminaDesign.paddingLg),
            
            // --- SECTION 1: ÉTAT GLOBAL ---
            Text("SANTÉ DU RÉSEAU", style: LuminaDesign.labelOf(context)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildNetworkStat("Antennes", "12", Icons.hub, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildNetworkStat("Membres", "${stats.membersCount}", Icons.people, Colors.orange)),
              ],
            ),
            
            const SizedBox(height: LuminaDesign.paddingLg),

            // --- SECTION 2: ALERTE DE CONFIANCE (AUDIT) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("FLUX DE VIGILANCE", style: LuminaDesign.labelOf(context)),
                TextButton(
                  onPressed: () => context.push(AppRoutes.auditHistory),
                  child: const Text("Voir tout l'audit"),
                ),
              ],
            ),
            _buildAuditPreview(ref),

            const SizedBox(height: LuminaDesign.paddingLg),

            // --- SECTION 3: ACTIONS CRITIQUES ---
            Text("PILOTAGE STRATÉGIQUE", style: LuminaDesign.labelOf(context)),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: [
                _AdminActionTile(label: "Finances Globales", icon: Icons.account_balance_rounded, onTap: () => context.push(AppRoutes.finance)),
                _AdminActionTile(label: "Sécurité & Rôles", icon: Icons.shield_outlined, onTap: () => context.push(AppRoutes.adminSettings)),
                _AdminActionTile(label: "Rapports d'Activité", icon: Icons.analytics_outlined, onTap: () => context.push(AppRoutes.reports)),
                _AdminActionTile(label: "Configuration", icon: Icons.settings_applications_outlined, onTap: () => context.push(AppRoutes.settings)),
              ],
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
      loading: () => const LoadingState(),
      error: (e, st) => const Center(child: Text("Erreur de chargement du centre de pilotage")),
    );
  }

  Widget _buildHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("ADMINISTRATION SUPRÊME", style: LuminaDesign.labelOf(context).copyWith(color: LuminaDesign.primary)),
        Text(title, style: LuminaDesign.h1Of(context)),
      ],
    );
  }

  Widget _buildNetworkStat(String label, String value, IconData icon, Color color) {
    return LuminaCard(
      color: color.withOpacity(0.05),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: LuminaDesign.labelOf(context)),
              Text(value, style: LuminaDesign.h2Of(context).copyWith(fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuditPreview(WidgetRef ref) {
    // Simulation du flux d'audit simplifié pour le dashboard
    return const LuminaCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _AuditItem(title: "Nouvelle dépense validée", subtitle: "Antenne Paris • Trésorier Marc", time: "Il y a 5 min", icon: Icons.check_circle_outline, color: Colors.green),
          Divider(height: 1),
          _AuditItem(title: "Tentative d'accès refusée", subtitle: "IP: 192.168.1.1 • Inconnu", time: "Il y a 22 min", icon: Icons.warning_amber_rounded, color: Colors.red),
          Divider(height: 1),
          _AuditItem(title: "Mise à jour du rôle", subtitle: "Membre -> Berger • Admin Sarah", time: "Il y a 1h", icon: Icons.sync_rounded, color: Colors.blue),
        ],
      ),
    );
  }
}

class _AdminActionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _AdminActionTile({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LuminaCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: context.colors.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: LuminaDesign.bodyLargeOf(context).copyWith(fontSize: 13, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

class _AuditItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;

  const _AuditItem({required this.title, required this.subtitle, required this.time, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color, size: 20),
      title: Text(title, style: LuminaDesign.bodyLargeOf(context).copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: LuminaDesign.labelOf(context).copyWith(fontSize: 11)),
      trailing: Text(time, style: LuminaDesign.labelOf(context).copyWith(fontSize: 10)),
    );
  }
}
