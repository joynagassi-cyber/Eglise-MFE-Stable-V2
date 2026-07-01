import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/architecture/result.dart';
import '../../../../core/errors/failures.dart' as err;
import '../entities/social_post.dart';
import '../entities/social_comment.dart';

/// Signature de résultat pour les opérations sociales
/// Succès : void / Échec : sous-classe de err.Failure
typedef SocialResult = Result<void, err.Failure>;

abstract class ISocialRepository {
  Future<List<SocialPost>> getPosts({int limit = 20, int offset = 0});
  Future<SocialResult> createPost(SocialPost post);
  Future<SocialResult> deletePost(String id);
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