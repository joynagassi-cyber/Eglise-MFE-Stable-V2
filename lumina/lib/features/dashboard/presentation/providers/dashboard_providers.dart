import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import '../../../../features/messaging/presentation/providers/messaging_providers.dart';
import '../../../../features/social/presentation/providers/social_providers.dart';
import '../../../annonces/domain/entities/annonce.dart';
import '../../../annonces/presentation/providers/annonce_providers.dart';

/// Aggregates all unread messages from all conversations
final totalUnreadMessagesProvider = Provider<int>((ref) {
  final conversationsAsync = ref.watch(conversationsProvider);
  return conversationsAsync.when(
    data: (conversations) => conversations.fold<int>(
      0,
      (sum, conversation) => sum + conversation.unreadCount,
    ),
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Count of pinned announcements
final pinnedAnnoncesCountProvider = Provider<int>((ref) {
  final annoncesAsync = ref.watch(pinnedAnnoncesProvider);
  return annoncesAsync.when(
    data: (annonces) => annonces.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Latest published announcements for the dashboard
final recentAnnoncesProvider = FutureProvider<List<Annonce>>((ref) async {
  final repository = ref.watch(annonceRepositoryProvider);
  return await repository.getPublishedAnnonces(limit: 10);
});

/// Count of recent testimonies (SocialPosts containing specific keywords)
final recentTestimoniesCountProvider = Provider<int>((ref) {
  final postsAsync = ref.watch(allPostsProvider);
  return postsAsync.when(
    data: (posts) {
      final now = DateTime.now();
      return posts.where((post) {
        final content = post.content.toLowerCase();
        final isTestimony = content.contains('témoignage') ||
            content.contains('merci seigneur') ||
            content.contains('rend grâce');
        final isRecent = now.difference(post.createdAt).inDays < 7;
        return isTestimony && isRecent;
      }).length;
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

enum DashboardPerspective {
  overview, // Église (Stats)
  personal, // Ma Vie (Membre)
  monitoring, // Supervision (Groupes)
}

/// Controller for the SuperAdmin dashboard perspective
final dashboardPerspectiveProvider =
    StateProvider<DashboardPerspective>((ref) => DashboardPerspective.overview);

enum GroupPerspective {
  group, // Mon Groupe
  personal, // Ma Vie (Membre)
}

/// Controller for the Group Leader dashboard perspective
final groupPerspectiveProvider =
    StateProvider<GroupPerspective>((ref) => GroupPerspective.group);

/// Target group selected by the Superadmin in monitoring view
final superadminTargetGroupProvider = StateProvider<String?>((ref) => null);
