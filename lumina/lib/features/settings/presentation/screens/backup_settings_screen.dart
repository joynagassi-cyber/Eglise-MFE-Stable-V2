// lib/features/settings/presentation/screens/backup_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/backup/backup_provider.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../../../core/widgets/widgets.dart';

class BackupSettingsScreen extends ConsumerWidget {
  const BackupSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: Semantics(
          label: 'Retour',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Retour',
            onPressed: () async {
              await HapticHelper.light();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ).withTouchTarget(),
        ),
        title: const Text('Sauvegarde & Sync'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AnimatedEntrance.fromBottom(
            delay: const Duration(milliseconds: 100),
            child: GlassCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.backup_rounded,
                        size: AppSpacing.iconLg,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.smd),
                      Text(
                        'Sauvegarde',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Semantics(
                    label: 'Créer une sauvegarde',
                    button: true,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await HapticHelper.medium();
                        try {
                          await ref.read(createBackupProvider.future);
                          await HapticHelper.success();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Backup créé')),
                            );
                          }
                        } catch (e) {
                          await HapticHelper.error();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.backup, size: AppSpacing.iconSm),
                      label: const Text('Créer Backup'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Semantics(
                    label: 'Partager la sauvegarde',
                    button: true,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await HapticHelper.light();
                        await ref.read(shareBackupProvider.future);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.share, size: AppSpacing.iconSm),
                      label: const Text('Partager Backup'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AnimatedEntrance.fromBottom(
            delay: const Duration(milliseconds: 200),
            child: GlassCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.cloud_sync_rounded,
                        size: AppSpacing.iconLg,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: AppSpacing.smd),
                      Text(
                        'Synchronisation',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Semantics(
                    label: 'Synchroniser les données',
                    button: true,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await HapticHelper.medium();
                        try {
                          await ref.read(syncDataProvider.future);
                          await HapticHelper.success();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sync réussie')),
                            );
                          }
                        } catch (e) {
                          await HapticHelper.error();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(
                        Icons.cloud_sync,
                        size: AppSpacing.iconSm,
                      ),
                      label: const Text('Synchroniser'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}