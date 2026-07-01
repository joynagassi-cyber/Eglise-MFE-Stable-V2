// lib/features/social/presentation/screens/create_post_screen.dart
// Écran universel de création de publication — accessible à tous les rôles
// Fonctionnalités : saisie, bouton "Améliorer avec l'IA", publication

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/features/social/presentation/providers/ai_social_providers.dart';
import 'package:lumina/features/social/presentation/providers/social_providers.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isImproved = false;
  String? _improvements;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _improveWithAi() async {
    final content = _controller.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Écrivez d\'abord quelque chose à améliorer'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isImproved = false;
      _improvements = null;
    });

    final editor = ref.read(postEditorProvider.notifier);
    editor.updateContent(content);
    await editor.improveWithAi();

    final state = ref.read(postEditorProvider);
    if (state.content.isNotEmpty && state.content != content) {
      _controller.text = state.content;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: state.content.length),
      );
      setState(() {
        _isImproved = true;
        _improvements = state.improvements;
      });
    }
  }

  Future<void> _publish() async {
    final content = _controller.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Écrivez quelque chose à partager'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final session = ref.read(currentSessionProvider);
    if (session == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous devez être connecté pour publier'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final editor = ref.read(postEditorProvider.notifier);
    final post = await editor.publish(
      authorId: session.userId,
      authorName: session.name,
      authorAvatarUrl: session.avatar,
    );

    if (post != null && mounted) {
      ref.invalidate(allPostsProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Publication partagée avec succès !'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Petite attente pour que l'utilisateur voie le message
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(postEditorProvider);

    return LuminaPage(
      title: "Nouvelle publication",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(LuminaDesign.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zone de texte
            Container(
              decoration: BoxDecoration(
                color: context.colors.bgCard,
                borderRadius: BorderRadius.circular(LuminaDesign.radiusMd),
                border: Border.all(color: context.colors.borderDefault),
              ),
              child: TextField(
                controller: _controller,
                maxLines: 6,
                minLines: 4,
                maxLength: 2000,
                onChanged: (value) {
                  ref.read(postEditorProvider.notifier).updateContent(value);
                  if (_isImproved) {
                    setState(() {
                      _isImproved = false;
                      _improvements = null;
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Partagez une pensée, un témoignage, un verset...\n\n'
                      '💡 Conseil : utilisez "Améliorer avec l\'IA" pour peaufiner votre texte !',
                  hintStyle: TextStyle(
                    color: context.colors.textTertiary,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(LuminaDesign.paddingMd),
                  counterStyle: TextStyle(
                    color: context.colors.textTertiary,
                    fontSize: 11,
                  ),
                ),
                style: TextStyle(
                  fontSize: 15,
                  color: context.colors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),

            // Feedback d'amélioration
            if (_isImproved && _improvements != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 16, color: Colors.green.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '✨ $_improvements',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Zone d'erreur
            if (editorState.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    editorState.error!,
                    style: TextStyle(fontSize: 12, color: Colors.red.shade700),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Bouton Améliorer avec l'IA
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: editorState.isLoading ? null : _improveWithAi,
                icon: editorState.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome, size: 18),
                label: Text(
                  editorState.isLoading
                      ? 'Amélioration en cours...'
                      : 'Améliorer avec l\'IA',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: LuminaDesign.primary,
                  side: BorderSide(color: LuminaDesign.primary.withOpacity(0.3)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(LuminaDesign.radiusMd),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Bouton Publier
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: editorState.isPublishing ? null : _publish,
                icon: editorState.isPublishing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  editorState.isPublishing
                      ? 'Publication en cours...'
                      : 'Publier',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: LuminaDesign.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(LuminaDesign.radiusMd),
                  ),
                  elevation: 0,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colors.bgPage,
                borderRadius: BorderRadius.circular(LuminaDesign.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: context.colors.textTertiary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Votre publication est visible par tous les membres de l\'église.\n'
                      'Les publications haineuses ou hors charte seront supprimées.',
                      style: TextStyle(
                        fontSize: 11,
                        color: context.colors.textTertiary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
