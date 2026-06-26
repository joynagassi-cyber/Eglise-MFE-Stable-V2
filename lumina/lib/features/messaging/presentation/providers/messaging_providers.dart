// lib/features/messaging/presentation/providers/messaging_providers.dart
// Riverpod providers for messaging, E2EE, and presence

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/chat_message.dart';
import 'package:lumina/core/providers/repository_providers_messaging.dart';

final conversationsProvider = StreamProvider<List<Conversation>>((ref) {
  final repository = ref.watch(messagingRepositoryProvider);
  return repository.watchConversations();
});

final conversationProvider = Provider.family<Conversation?, String>((ref, id) {
  final conversations = ref.watch(conversationsProvider).valueOrNull;
  if (conversations == null) return null;
  return conversations.where((c) => c.id == id).firstOrNull;
});

final chatMessagesProvider = StreamProvider.family<List<ChatMessage>, String>((
  ref,
  conversationId,
) {
  final repository = ref.watch(messagingRepositoryProvider);
  return repository.watchMessages(conversationId);
});

/// Stream of online user IDs from the PresenceService.
final onlineUsersProvider = StreamProvider<Set<String>>((ref) {
  final presenceService = ref.watch(presenceServiceProvider);
  return presenceService.onlineUsers;
});

/// Check if a specific user is online.
final isUserOnlineProvider = Provider.family<bool, String>((ref, userId) {
  final onlineUsers = ref.watch(onlineUsersProvider);
  return onlineUsers.when(
    data: (users) => users.contains(userId),
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Controller to handle group-specific chat navigation and initialization.
final groupChatControllerProvider = Provider((ref) {
  final repository = ref.watch(messagingRepositoryProvider);

  Future<String?> getOrCreateGroupChat(String groupId, String title) async {
    try {
      final conversationId = await repository.getOrCreateGroupConversation(groupId, title);
      return conversationId;
    } catch (e) {
      return null;
    }
  }

  return getOrCreateGroupChat;
});
