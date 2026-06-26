import "package:lumina/core/widgets/widgets.dart";
import 'package:flutter/material.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import 'package:lumina/features/events/presentation/providers/event_providers.dart';
import 'package:intl/intl.dart';

class VieSpirituelleHomeScreen extends ConsumerWidget {
  const VieSpirituelleHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LuminaPage(
      title: "Vie Spirituelle",
      onRefresh: () async => ref.invalidate(upcomingEventsProvider),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(LuminaDesign.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickActions(context),
            SizedBox(height: LuminaDesign.paddingLg),
            Text("AGENDA PASTORAL", style: LuminaDesign.labelOf(context)),
            SizedBox(height: 8),
            _buildUpcomingEvents(ref, context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _QuickAction(title: "Jalons", icon: Icons.flag, onTap: () => context.push(AppRoutes.vieSpirituelleJalons)),
        _QuickAction(title: "Célébrations", icon: Icons.celebration, onTap: () => context.push(AppRoutes.vieSpirituelleCelebrations)),
        _QuickAction(title: "Sacrements", icon: Icons.church, onTap: () => context.push(AppRoutes.sacraments)),
        _QuickAction(title: "Calendrier", icon: Icons.calendar_month, onTap: () => context.push(AppRoutes.vieSpirituelleEvents)),
      ],
    );
  }

  Widget _buildUpcomingEvents(WidgetRef ref, BuildContext context) {
    final eventsAsync = ref.watch(upcomingEventsProvider);
    return eventsAsync.when(
      data: (events) {
        if (events.isEmpty) return Text("Aucun événement prévu.");
        return Column(
          children: events.take(3).map((e) => LuminaCard(
            onTap: () => context.push("${AppRoutes.vieSpirituelleEvents}/${e.id}"),
            child: Row(
              children: [
                Icon(Icons.event, color: LuminaDesign.primary),
                SizedBox(width: 16),
                Expanded(child: Text(e.title, style: LuminaDesign.bodyLargeOf(context))),
                Text(DateFormat('dd/MM').format(e.date), style: LuminaDesign.labelOf(context)),
              ],
            ),
          )).toList(),
        );
      },
      loading: () => const LoadingState(),
      error: (e, _) => Text("Erreur : $e"),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _QuickAction({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LuminaCard(
      onTap: onTap,
      color: LuminaDesign.primary.withOpacity(0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: LuminaDesign.primary),
          SizedBox(height: 8),
          Text(title, style: LuminaDesign.labelOf(context)),
        ],
      ),
    );
  }
}
