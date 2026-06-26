import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/router/app_routes.dart';
import '../controllers/settings_controller.dart';

import '../../../../core/services/offline_sync_manager.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);
    final syncStatus = ref.watch(offlineSyncManagerProvider).getStatus();

    return LuminaPage(
      title: "Paramètres",
      onRefresh: () async => ref.invalidate(settingsControllerProvider),
      body: settingsAsync.when(
        data: (settings) => ListView(
          padding: const EdgeInsets.all(LuminaDesign.paddingLg),
          children: [
            _buildSyncStatus(context, syncStatus),
            const SizedBox(height: 24),
            _buildSection("Affichage", [
              ListTile(
                title: const Text("Thème"),
                subtitle: Text(settings.themeMode.toUpperCase()),
                trailing: const Icon(Icons.brightness_medium),
                onTap: () {}, // Handled in V2
              ),
            ]),
            const SizedBox(height: 16),
            _buildSection("Compte & Sécurité", [
              ListTile(
                title: const Text("Changement de mot de passe"),
                onTap: () {},
              ),
              ListTile(
                title: const Text("Sauvegardes manuelles"),
                onTap: () => context.push(AppRoutes.backupSettings),
              ),
            ]),
            const SizedBox(height: 48),
            LuminaButton(
              label: "Déconnexion",
              onPressed: () {}, // logic handled by AuthProvider
            ),
          ],
        ),
        loading: () => const LoadingState(),
        error: (e, st) => Center(child: Text("Erreur : $e")),
      ),
    );
  }

  Widget _buildSyncStatus(BuildContext context, SyncStatus status) {
    return LuminaCard(
      color: LuminaDesign.primary.withOpacity(0.05),
      child: Row(
        children: [
          Icon(Icons.sync, color: status.isHealthy ? Colors.green : LuminaDesign.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("État du système", style: LuminaDesign.labelOf(context)),
                Text(status.label, style: LuminaDesign.h2Of(context).copyWith(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: LuminaDesign.labelOf(context)),
        const SizedBox(height: 8),
        LuminaCard(
          padding: EdgeInsets.zero,
          child: Column(children: children),
        ),
      ],
    );
  }
}
