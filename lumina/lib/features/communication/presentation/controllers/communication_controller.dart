import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/core/providers/repository_providers_messaging.dart';
import 'package:lumina/features/annonces/domain/entities/annonce.dart';
import 'package:lumina/features/social/domain/entities/social_post.dart';

part 'communication_controller.g.dart';

/// Controller for the Communication module.
/// Aggregates announcements, social feeds, and messaging stats.
@riverpod
class CommunicationController extends _$CommunicationController {
  @override
  Future<CommunicationState> build({String? churchId}) async {
    final annonceRepo = ref.watch(annonceRepositoryProvider);
    final socialRepo = ref.watch(socialRepositoryProvider);

    final announcements = await annonceRepo.getAnnonces(
      churchId: churchId ?? '',
    );
    final recentPosts = await socialRepo.getPosts(limit: 10);

    final publishedAnnouncements =
        announcements.where((a) => a.isPublished).toList();
    final pinnedAnnouncements = announcements.where((a) => a.isPinned).toList();

    return CommunicationState(
      announcements: publishedAnnouncements,
      pinnedAnnouncements: pinnedAnnouncements,
      recentPosts: recentPosts,
      totalAnnouncements: announcements.length,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

class CommunicationState {
  final List<Annonce> announcements;
  final List<Annonce> pinnedAnnouncements;
  final List<SocialPost> recentPosts;
  final int totalAnnouncements;

  const CommunicationState({
    this.announcements = const [],
    this.pinnedAnnouncements = const [],
    this.recentPosts = const [],
    this.totalAnnouncements = 0,
  });

  int get unreadAnnouncementCount =>
      announcements.where((a) => (a.viewsCount ?? 0) == 0).length;
}
