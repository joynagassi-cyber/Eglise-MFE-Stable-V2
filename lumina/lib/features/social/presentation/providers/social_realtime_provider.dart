import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../data/repositories/social_realtime_repository.dart';

part 'social_realtime_provider.g.dart';

@riverpod
Stream<List<SocialPost>> watchPosts(WatchPostsRef ref) {
  final churchId = ref.watch(activeChurchIdProvider);

  final repository = ref.watch(socialRealtimeRepositoryProvider);
  return repository.watchPosts(churchId);
}

@riverpod
Stream<List<Comment>> watchComments(WatchCommentsRef ref, String postId) {
  final repository = ref.watch(socialRealtimeRepositoryProvider);
  return repository.watchComments(postId);
}

@riverpod
Stream<int> watchUnreadNotifications(WatchUnreadNotificationsRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(0);

  final repository = ref.watch(socialRealtimeRepositoryProvider);
  return repository.watchUnreadCount(userId);
}