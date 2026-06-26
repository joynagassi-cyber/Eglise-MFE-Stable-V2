import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/femmes_providers.dart';
import 'package:lumina/features/auth/presentation/widgets/permission_guard.dart';
import 'package:lumina/core/auth/domain/entities/enums/permission.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'training_card.dart';

class TrainingsTab extends ConsumerWidget {
  final String groupId;
  final Color accentColor;

  const TrainingsTab({
    super.key,
    required this.groupId,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainingsAsync = ref.watch(trainingsProvider(groupId));

    return trainingsAsync.when(
      data: (trainings) => Column(
        children: [
          if (trainings.isEmpty)
            const Expanded(
              child: Center(
                child: Text('Aucune formation disponible'),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: trainings.length,
                itemBuilder: (context, index) {
                  final t = trainings[index];
                  return TrainingCard(training: t, color: accentColor);
                },
              ),
            ),
          _buildBottomAction(
            context,
            'Créer une Formation',
            Icons.add_rounded,
            accentColor,
          ),
        ],
      ),
      loading: () => const Center(
        child: LoadingDots(),
      ),
      error: (e, _) => AppErrorWidget(message: e.toString()),
    );
  }

  Widget _buildBottomAction(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: PermissionGuard(
        permission: Permission.groupsEdit,
        child: ElevatedButton.icon(
          onPressed: () async {
            await HapticHelper.medium();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Création de formation : Bientôt disponible')),
              );
            }
          },
          icon: Icon(icon, color: context.colors.textInverse),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: context.colors.textInverse,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
