import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_text.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/enfants_providers.dart';

class ProgramsGrid extends ConsumerWidget {
  const ProgramsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(childrenProgramsNotifierProvider);

    return programsAsync.when(
      data: (programs) {
        if (programs.isEmpty) {
          // Fallback static programs if DB is empty for demo
          final demoPrograms = [
            {
              'title': 'Éveil (3-5 ans)',
              'color': context.colors.brandPrimary,
              'icon': Icons.toys
            },
            {
              'title': 'Explorateurs (6-8 ans)',
              'color': context.colors.warningText,
              'icon': Icons.explore
            },
            {
              'title': 'Champions (9-12 ans)',
              'color': context.colors.infoText,
              'icon': Icons.emoji_events
            },
          ];

          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: demoPrograms.length,
            itemBuilder: (context, index) {
              final p = demoPrograms[index];
              return _buildProgramCard(context, p['title'] as String,
                  p['color'] as Color, p['icon'] as IconData);
            },
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: programs.length,
          itemBuilder: (context, index) {
            final program = programs[index];
            return _buildProgramCard(
                context, program.name, context.colors.brandPrimary, Icons.school);
          },
        );
      },
      loading: () => Center(child: LoadingState()),
      error: (e, _) => Text('Error: $e'),
    );
  }

  Widget _buildProgramCard(
      BuildContext context, String title, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 40),
          SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppText.bodyBold(context).copyWith(color: color),
          ),
          SizedBox(height: 4),
          Text('12 inscrits pool', style: AppText.caption(context)),
        ],
      ),
    );
  }
}
