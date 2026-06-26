import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/chat_message.dart';

part 'chat_message_model.g.dart';

@collection
class ChatMessageModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String remoteId;

  @Index()
  late String conversationId;

  late String senderId;
  late String senderName;
  late String content;

  late String type; // enum string
  List<String> readBy = [];

  late DateTime createdAt;
  DateTime? updatedAt;

  // Sync fields
  bool isSynced = true;
  bool isDeleted = false;
  DateTime? lastSyncedAt;

  String? jsonData;

  ChatMessage toEntity() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return ChatMessage.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return ChatMessage(
      id: remoteId,
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      content: content,
      type: MessageType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => MessageType.text,
      ),
      readBy: readBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static ChatMessageModel fromEntity(ChatMessage message) {
    final model = ChatMessageModel();
    model.isarId = Isar.autoIncrement;
    model.remoteId = message.id;
    model.conversationId = message.conversationId;
    model.senderId = message.senderId;
    model.senderName = message.senderName;
    model.content = message.content;
    model.type = message.type.name;
    model.readBy = message.readBy;
    model.createdAt = message.createdAt;
    model.updatedAt = message.updatedAt;

    model.isSynced = false;
    model.jsonData = jsonEncode(message.toJson());

    return model;
  }
}