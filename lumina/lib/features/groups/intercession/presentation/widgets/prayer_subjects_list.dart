import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/intercession_providers.dart';
import 'package:lumina/core/theme/app_text.dart';
import 'package:lumina/core/widgets/widgets.dart';
class PrayerSubjectsList extends ConsumerWidget {
  final String groupId;
  const PrayerSubjectsList({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync =
        ref.watch(permanentPrayerSubjectsNotifierProvider(groupId));

    return subjectsAsync.when(
      data: (subjects) {
        if (subjects.isEmpty) {
          return const Center(child: Text('Aucun sujet permanent.'));
        }

        // Group by category
        final grouped = <String, List>{};
        for (var s in subjects) {
          grouped.putIfAbsent(s.category, () => []).add(s);
        }

        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: grouped.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(entry.key,
                      style: AppText.h3(context).copyWith(
                          color: Theme.of(context).colorScheme.primary)),
                ),
                ...entry.value.map((subject) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withValues(alpha: 0.5),
                      child: ListTile(
                        title: Text(subject.subject,
                            style: AppText.bodyLarge(context)),
                        subtitle: subject.description != null
                            ? Text(subject.description!)
                            : null,
                        trailing: Switch(
                          value: subject.isActive,
                          onChanged: (val) {
                            // Update logical state
                          },
                        ),
                      ),
                    )),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: LoadingState()),
      error: (e, _) => const Center(child: Text('Impossible de charger les sujets de prière')),
    );
  }
}