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
            SizedBox(height: 24),
            _buildSection(context, "Affichage", [
              ListTile(
                title: Text("Thème"),
                subtitle: Text(settings.themeMode.toUpperCase()),
                trailing: Icon(Icons.brightness_medium),
                onTap: () {}, // Handled in V2
              ),
            ]),
            SizedBox(height: 16),
            _buildSection(context, "Compte & Sécurité", [
              ListTile(
                title: Text("Changement de mot de passe"),
                onTap: () {},
              ),
              ListTile(
                title: Text("Sauvegardes manuelles"),
                onTap: () => context.push(AppRoutes.backupSettings),
              ),
            ]),
            SizedBox(height: 48),
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
          SizedBox(width: 16),
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

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: LuminaDesign.labelOf(context)),
        SizedBox(height: 8),
        LuminaCard(
          padding: EdgeInsets.zero,
          child: Column(children: children),
        ),
      ],
    );
  }
}
