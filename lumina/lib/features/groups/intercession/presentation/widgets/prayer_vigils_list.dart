import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/intercession_providers.dart';
import 'package:lumina/core/theme/app_text.dart';

class PrayerVigilsList extends ConsumerWidget {
  final String groupId;
  const PrayerVigilsList({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vigilsAsync = ref.watch(prayerVigilsNotifierProvider(groupId));
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final onSurfaceVariantColor =
        Theme.of(context).colorScheme.onSurfaceVariant;

    return vigilsAsync.when(
      data: (vigils) {
        if (vigils.isEmpty) {
          return Center(child: Text('Aucune veillée prévue.'));
        }
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: vigils.length,
          itemBuilder: (context, index) {
            final vigil = vigils[index];
            final isOngoing = vigil.status == 'ongoing';

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: isOngoing
                        ? primaryColor.withValues(alpha: 0.5)
                        : context.colors.borderSubtle),
                color: isOngoing
                    ? primaryColor.withValues(alpha: 0.05)
                    : context.colors.textPrimary.withValues(alpha: 0.02),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: isOngoing ? primaryColor : surfaceColor,
                  child: Icon(
                    isOngoing
                        ? Icons.play_arrow_rounded
                        : Icons.nightlight_round,
                    color: isOngoing ? context.colors.textInverse : onSurfaceVariantColor,
                  ),
                ),
                title: Text(vigil.title, style: AppText.h3(context)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      '${DateFormat('dd MMM, HH:mm').format(vigil.startTime)} - ${DateFormat('HH:mm').format(vigil.endTime)}',
                      style: AppText.caption(context),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.people_outline, size: 14),
                        SizedBox(width: 4),
                        Text('${vigil.participantsCount} participants',
                            style: AppText.caption(context)),
                      ],
                    ),
                  ],
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        _getStatusColor(context, vigil.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    vigil.status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(context, vigil.status),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => Center(child: LoadingState()),
      error: (e, _) => Center(child: Text('Impossible de charger les veillées')),
    );
  }

  Color _getStatusColor(BuildContext context, String status) {
    return switch (status) {
      'ongoing' => context.colors.successText,
      'completed' => Theme.of(context).colorScheme.primary,
      'cancelled' => context.colors.errorText,
      _ => Theme.of(context).colorScheme.onSurfaceVariant,
    };
  }
}
