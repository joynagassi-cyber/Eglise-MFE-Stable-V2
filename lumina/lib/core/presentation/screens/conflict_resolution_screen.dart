import 'dart:async';
import 'package:lumina/core/extensions/context_extension.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/glass_card.dart';
import 'package:lumina/core/widgets/empty_state.dart';
import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/data/models/sync_item_model.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';
import 'package:isar/isar.dart';

class ConflictResolutionScreen extends ConsumerWidget {
  const ConflictResolutionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isarService = ref.watch(isarServiceProvider);

    if (!isarService.isReady) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Conflits de Synchronisation'),
          centerTitle: true,
        ),
        body: const EmptyState(
          icon: Icons.wifi_off_rounded,
          title: 'Mode Web (En ligne)',
          subtitle:
              'La gestion des conflits n\'est nécessaire qu\'en mode hors ligne (application mobile).',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conflits de Synchronisation'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<SyncItemModel>>(
        stream: isarService.db.syncItemModels
            .where()
            .filter()
            .isConflictEqualTo(true)
            .watch(fireImmediately: true),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyState(
              icon: Icons.check_circle_outline_rounded,
              title: 'Aucun conflit détecté',
              subtitle:
                  'Toutes vos modifications locales sont à jour ou en attente simple.',
            );
          }

          final conflicts = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: conflicts.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final item = conflicts[index];
              return _ConflictCard(item: item);
            },
          );
        },
      ),
    );
  }
}

class _ConflictCard extends ConsumerWidget {
  final SyncItemModel item;
  const _ConflictCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> localData = {};
    Map<String, dynamic>? remoteData;

    try {
      localData = jsonDecode(item.jsonData) as Map<String, dynamic>;
      if (item.remoteData != null) {
        remoteData = jsonDecode(item.remoteData!) as Map<String, dynamic>;
      }
    } catch (e) {
      // Logic for corrupted data: we fallback to empty maps but we could log it
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: context.colors.warningText),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Table: ${item.tableName}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                item.action,
                style: TextStyle(
                  color: item.action == 'DELETE'
                      ? context.colors.errorText
                      : context.colors.brandPrimary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Divider(),
          const Text(
            'Un conflit est survenu car les données sur le serveur ont changé depuis votre dernière modification hors ligne.',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _ResolutionButton(
                  label: 'Garder le mien',
                  color: context.colors.brandPrimary,
                  onPressed: () => _resolve(ref, keepLocal: true),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ResolutionButton(
                  label: 'Garder le serveur',
                  color: context.colors.errorText,
                  onPressed: () => _resolve(ref, keepLocal: false),
                ),
              ),
            ],
          ),
          if (remoteData != null) ...[
            const SizedBox(height: AppSpacing.md),
            TextButton.icon(
              onPressed: () => _showDiff(context, localData, remoteData!),
              icon: const Icon(Icons.compare_arrows_rounded),
              label: const Text('Comparer les différences'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _resolve(WidgetRef ref, {required bool keepLocal}) async {
    final isarService = ref.read(isarServiceProvider);
    final isar = isarService.db;

    await isar.writeTxn(() async {
      if (keepLocal) {
        // Pour garder le local, on reset le conflit et on retente la synchro (mais potentiellement il faut forcer un override via SQL ou autre si Supabase refuse)
        // Ici on va juste reset le status pour qu'il soit repris comme un update normal.
        item.isConflict = false;
        item.attempts = 0;
        item.lastError = null;
        await isar.syncItemModels.put(item);
      } else {
        // Pour garder le serveur, on supprime simplement l'item de synchro locale
        // Les données locales devront être rafraîchies via un fetch global ou spécifique.
        await isar.syncItemModels.delete(item.isarId);
      }
    });

    if (keepLocal) {
      unawaited(ref.read(offlineSyncManagerProvider).forceSync());
    }
  }

  void _showDiff(BuildContext context, Map local, Map remote) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const Text('Comparaison Local vs Serveur',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: [
                    _buildDiffTable(context, local, remote),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiffTable(BuildContext context, Map local, Map remote) {
    final keys = {...local.keys, ...remote.keys}.toList()..sort();
    return Table(
      border:
          TableBorder.all(color: context.colors.borderSubtle.withOpacity(0.5)),
      children: [
        const TableRow(
          children: [
            Padding(
                padding: EdgeInsets.all(8),
                child: Text('Champ',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(
                padding: EdgeInsets.all(8),
                child: Text('Local',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(
                padding: EdgeInsets.all(8),
                child: Text('Serveur',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        ...keys.map((k) {
          final lVal = local[k].toString();
          final rVal = remote[k].toString();
          final isDiff = lVal != rVal;
          return TableRow(
            decoration: isDiff
                ? BoxDecoration(color: context.colors.warningText.withOpacity(0.1))
                : null,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(k, style: const TextStyle(fontSize: 11))),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(lVal,
                      style: TextStyle(
                          fontSize: 11,
                          color: isDiff ? context.colors.brandPrimary : null))),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(rVal,
                      style: TextStyle(
                          fontSize: 11,
                          color: isDiff ? context.colors.errorText : null))),
            ],
          );
        }),
      ],
    );
  }
}

class _ResolutionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ResolutionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
