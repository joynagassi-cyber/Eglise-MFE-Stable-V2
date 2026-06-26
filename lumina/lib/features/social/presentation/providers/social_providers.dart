import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/social_post.dart';
import '../../domain/entities/social_comment.dart';
import 'package:lumina/core/providers/repository_providers_messaging.dart';

final allPostsProvider = StreamProvider<List<SocialPost>>((ref) {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.watchPosts();
});

final postCommentsProvider = StreamProvider.family<List<SocialComment>, String>(
  (ref, postId) {
    final repository = ref.watch(socialRepositoryProvider);
    return repository.watchComments(postId);
  },
);
