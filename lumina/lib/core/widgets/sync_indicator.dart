import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/offline_sync_manager.dart';
import 'loading_dots.dart';

part 'sync_indicator.g.dart';

/// Provider pour l'état de synchronisation globale (Queue Isar)
@riverpod
Stream<int> pendingSyncCount(PendingSyncCountRef ref) {
  final syncManager = ref.watch(offlineSyncManagerProvider);
  return Stream.value(syncManager.pendingCount);
}

/// Widget indicateur de synchronisation
///
/// Affiche un indicateur visuel exhaustif (Connectivité + Queue)
class SyncIndicator extends ConsumerWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncManager = ref.watch(offlineSyncManagerProvider);
    final count = syncManager.pendingCount;
    final isOnline = syncManager.isOnline;
    final isSyncing = syncManager.isSyncing;

    // Si tout est ok (En ligne, 0 attente, pas en cours), on n'affiche rien ou un petit point vert?
    // Selon le design: on affiche si déconnecté ou si queue > 0
    if (isOnline && count == 0 && !isSyncing) {
      return const SizedBox.shrink();
    }

    final color = !isOnline
        ? context.colors.errorText
        : (count > 0 ? context.colors.warningText : context.colors.brandPrimary);

    final icon = !isOnline
        ? Icons.cloud_off
        : (isSyncing ? Icons.sync : Icons.cloud_done);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSyncing)
            LoadingDots(size: 14, color: color)
          else
            Icon(icon, size: 14, color: color),
          SizedBox(width: 8),
          Text(
            !isOnline
                ? 'Hors ligne'
                : (count > 0 ? '$count en attente' : 'Synchronisé'),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
