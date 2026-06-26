import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_text.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/enfants_providers.dart';

class ResourceVault extends ConsumerWidget {
  const ResourceVault({super.key});

  void _showComingSoon(BuildContext context) async {
    await HapticHelper.light();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Téléchargement bientôt disponible',
            style: AppTypography.bodyMedium.copyWith(color: context.colors.textInverse),
          ),
          backgroundColor: context.colors.brandPrimary,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourcesAsync = ref.watch(pedagogicResourcesNotifierProvider);

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            labelColor: context.colors.brandPrimary,
            unselectedLabelColor: context.colors.textSecondary,
            indicatorColor: context.colors.brandPrimary,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'Leçons'),
              Tab(text: 'Jeux'),
              Tab(text: 'Médias'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: resourcesAsync.when(
              data: (resources) => TabBarView(
                children: [
                  _buildResourceList(context, resources, 'lesson'),
                  _buildResourceList(context, resources, 'game'),
                  _buildResourceList(context, resources, 'media'),
                ],
              ),
              loading: () => const Center(child: LoadingState()),
              error: (e, _) => Text('Error: $e'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceList(
      BuildContext context, List resources, String category) {
    final filtered = resources.where((r) => r.category == category).toList();
    if (filtered.isEmpty) {
      // Demo items
      return ListView(
        children: [
          _buildResourceTile(
              context, 'Histoire de Noé', 'PDF - 2.4MB', Icons.description),
          _buildResourceTile(
              context, 'Parabole du Semeur', 'MP4 - 45MB', Icons.video_library),
        ],
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final res = filtered[index];
        return _buildResourceTile(context, res.title,
            res.contentSummary ?? category, Icons.file_present);
      },
    );
  }

  Widget _buildResourceTile(
      BuildContext context, String title, String subtitle, IconData icon) {
    return Card(
      elevation: 0,
      color: context.colors.bgCard.withValues(alpha: 0.5),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: context.colors.brandPrimary),
        title: Text(title, style: AppText.bodyMedium(context)),
        subtitle: Text(subtitle, style: AppText.caption(context)),
        trailing: const Icon(Icons.download_rounded, size: 20),
        onTap: () => _showComingSoon(context),
      ),
    );
  }
}
