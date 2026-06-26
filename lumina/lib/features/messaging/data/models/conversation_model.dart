import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/conversation.dart';

part 'conversation_model.g.dart';

@collection
class ConversationModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String remoteId;

  late String type; // enum string
  List<String> participantsIds = [];
  String? title;

  String? lastMessageContent;
  DateTime? lastMessageAt;

  int unreadCount = 0;
  bool isPinned = false;
  bool isMuted = false;

  DateTime? createdAt;
  DateTime? updatedAt;

  // Sync fields
  bool isSynced = true;
  bool isDeleted = false;
  DateTime? lastSyncedAt;

  String? jsonData;

  Conversation toEntity() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return Conversation.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return Conversation(
      id: remoteId,
      type: ConversationType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => ConversationType.private,
      ),
      participantsIds: participantsIds,
      title: title,
      lastMessageContent: lastMessageContent,
      lastMessageAt: lastMessageAt,
      unreadCount: unreadCount,
      isPinned: isPinned,
      isMuted: isMuted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static ConversationModel fromEntity(Conversation conver) {
    final model = ConversationModel();
    model.isarId = Isar.autoIncrement;
    model.remoteId = conver.id;
    model.type = conver.type.name;
    model.participantsIds = conver.participantsIds;
    model.title = conver.title;
    model.lastMessageContent = conver.lastMessageContent;
    model.lastMessageAt = conver.lastMessageAt;
    model.unreadCount = conver.unreadCount;
    model.isPinned = conver.isPinned;
    model.isMuted = conver.isMuted;
    model.createdAt = conver.createdAt;
    model.updatedAt = conver.updatedAt;

    model.isSynced = false;
    model.jsonData = jsonEncode(conver.toJson());

    return model;
  }
}