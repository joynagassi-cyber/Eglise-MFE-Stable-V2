import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

enum ConversationType { private, group }

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required ConversationType type,
    required List<String> participantsIds,
    String? title, // For group chats
    String? lastMessageContent,
    DateTime? lastMessageAt,
    @Default(0) int unreadCount,
    @Default(false) bool isPinned,
    @Default(false) bool isMuted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}