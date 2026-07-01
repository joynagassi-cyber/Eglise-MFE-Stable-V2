// lib/features/social/presentation/widgets/admin_moderation_panel.dart
// Panneau visible uniquement par les admins pour supprimer les posts signalés

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/features/social/domain/repositories/i_social_repository.dart';
import 'package:lumina/features/social/domain/entities/social_post.dart';
import 'package:lumina/features/social/presentation/providers/social_providers.dart';

class AdminModerationPanel extends ConsumerWidget {
  final SocialPost post;
  final VoidCallback? onDeleted;

  const AdminModerationPanel({
    super.key,
    required this.post,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);

    if (!isAdmin) return const SizedBox.shrink();
    return _buildPanel(context, ref);
  }

  Widget _buildPanel(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(LuminaDesign.radiusSm),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, size: 16, color: Colors.red.shade700),
              const SizedBox(width: 6),
              Text(
                'Panneau de modération',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Vous êtes administrateur. Vous pouvez supprimer cette publication si elle viole la charte.',
            style: TextStyle(
              fontSize: 11,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _confirmDelete(context, ref),
              icon: const Icon(Icons.delete_forever_rounded, size: 16),
              label: const Text(
                'Supprimer cette publication',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer la publication de ${post.authorName} ?\n\n'
          '"${post.content.length > 100 ? '${post.content.substring(0, 100)}...' : post.content}"\n\n'
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final repository = ref.read(socialRepositoryProvider);
      final result = await repository.deletePost(post.id);

      result.fold(
        (_) {
          ref.invalidate(allPostsProvider);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Publication supprimée'),
                backgroundColor: Colors.green,
              ),
            );
          }
          try {
            onDeleted?.call();
          } catch (_) {
            // Ignorer silencieusement — le callback ne doit pas casser l'UX
          }
        },
        (failure) {
          debugPrint('Erreur deletePost: $failure');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erreur : ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    }
  }
}
