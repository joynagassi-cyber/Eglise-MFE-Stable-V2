import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/social_post.dart';
import '../entities/social_comment.dart';

abstract class ISocialRepository {
  Future<List<SocialPost>> getPosts({int limit = 20, int offset = 0});
  Future<void> createPost(SocialPost post);
  Future<void> deletePost(String id);
  Future<void> likePost(String postId);
  Stream<List<SocialPost>> watchPosts();

  // Comments
  Future<List<SocialComment>> getComments(String postId);
  Stream<List<SocialComment>> watchComments(String postId);
  Future<void> addComment(SocialComment comment);
}

final socialRepositoryProvider = Provider<ISocialRepository>((ref) {
  throw UnimplementedError('socialRepositoryProvider not overridden');
});