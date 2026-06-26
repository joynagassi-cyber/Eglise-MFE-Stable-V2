import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../entities/conversation.dart';
import '../entities/chat_message.dart';

abstract class IMessagingRepository {
  Future<List<Conversation>> getConversations();
  Stream<List<Conversation>> watchConversations();

  Future<List<ChatMessage>> getMessages(
    String conversationId, {
    int limit = 50,
  });
  Stream<List<ChatMessage>> watchMessages(String conversationId);

  Future<String> createConversation(
    List<String> participantsIds, {
    String? title,
  });

  Future<String> getOrCreateGroupConversation(String groupId, String title);

  Future<void> sendMessage(ChatMessage message);
  Future<void> markAsRead(String conversationId, String userId);
  Future<String?> uploadFile(File file, String folder);

  // Chat Settings
  Future<void> togglePinConversation(String conversationId, bool isPinned);
  Future<void> toggleMuteConversation(String conversationId, bool isMuted);
  Future<void> blockUser(String userId);
  Future<void> unblockUser(String userId);
  Future<void> clearHistory(String conversationId);
  Future<List<ChatMessage>> searchMessages(String conversationId, String query);
  Future<List<String>> getSharedMediaUrls(String conversationId);

  /// Libère les ressources et ferme les connexions WebSocket
  Future<void> dispose();

  /// Arrête l'écoute temps-réel pour une conversation spécifique
  Future<void> unsubscribeFromMessages(String conversationId);
}

final messagingRepositoryProvider = Provider<IMessagingRepository>((ref) {
  throw UnimplementedError('messagingRepositoryProvider not overridden');
});