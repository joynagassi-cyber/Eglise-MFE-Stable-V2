import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../domain/entities/social_comment.dart';
import '../providers/social_providers.dart';
import 'package:lumina/core/providers/repository_providers_messaging.dart';
import 'package:lumina/core/providers/auth_provider.dart';

class CommentSheet extends ConsumerStatefulWidget {
  final String postId;

  const CommentSheet({super.key, required this.postId});

  @override
  ConsumerState<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends ConsumerState<CommentSheet> {
  final _controller = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSending = true);

    try {
      final authState = ref.read(authProvider).valueOrNull;

      final comment = SocialComment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: widget.postId,
        authorId: authState?.userId ?? 'guest',
        authorName: authState?.name ?? 'Anonyme',
        authorAvatarUrl: authState?.avatar,
        content: content,
        createdAt: DateTime.now(),
      );

      await ref.read(socialRepositoryProvider).addComment(comment);
      if (mounted) {
        _controller.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Impossible d\'envoyer le commentaire')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(postCommentsProvider(widget.postId));

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: context.colors.bgPage,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Commentaires',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: context.colors.textPrimary),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          // List
          Expanded(
            child: commentsAsync.when(
              data: (comments) {
                if (comments.isEmpty) {
                  return Center(
                    child: Text('Soyez le premier à commenter !'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AvatarWidget(
                            imageUrl: comment.authorAvatarUrl,
                            fallbackName: comment.authorName,
                            size: 32,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      comment.authorName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: context.colors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      DateFormat(
                                        'dd MMM HH:mm',
                                      ).format(comment.createdAt),
                                      style: TextStyle(color: context.colors.textTertiary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(comment.content),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 3,
                itemBuilder: (_, __) => Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      ShimmerBox(height: 32, width: 32, borderRadius: 16),
                      SizedBox(width: 12),
                      Expanded(child: ShimmerBox(height: 40, borderRadius: 8)),
                    ],
                  ),
                ),
              ),
              error: (err, stack) => Center(child: Text('Impossible de charger les commentaires')),
            ),
          ),
          // Input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Écrire un commentaire...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: context.colors.bgCardLight,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: _isSending ? null : _sendComment,
                  icon: _isSending
                      ? const ShimmerBox(
                          width: 20,
                          height: 20,
                          borderRadius: 10,
                        )
                      : Icon(Icons.send_rounded,
                          color: context.colors.brandPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
