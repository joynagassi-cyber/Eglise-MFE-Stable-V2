import 'package:flutter/material.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/utils/haptic_helper.dart';

class EventsSection extends StatelessWidget {
  final List<dynamic> upcomingEvents;
  final VoidCallback onAddEvent;

  const EventsSection({
    super.key,
    required this.upcomingEvents,
    required this.onAddEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Événements à venir',
          icon: Icons.calendar_today,
          trailingLabel: 'Planifier',
          onTrailingTap: onAddEvent,
        ),
        const SizedBox(height: AppSpacing.md),
        if (upcomingEvents.isEmpty)
          const EmptyState(
            icon: Icons.event_available,
            title: 'Aucun événement',
            subtitle: 'Planifiez votre prochaine activité.',
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: upcomingEvents.length,
            itemBuilder: (context, index) {
              final event = upcomingEvents[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  title: Text(event.title),
                  subtitle: Text(event.date.toString()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await HapticHelper.medium();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Détails : Bientôt disponible')),
                      );
                    }
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}