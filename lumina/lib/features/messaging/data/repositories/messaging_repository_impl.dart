import 'dart:async';
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/i_messaging_repository.dart';
import '../models/conversation_model.dart';
import '../models/chat_message_model.dart';
import '../../../../core/utils/app_date_time.dart';
import '../../../../core/services/offline_sync_manager.dart';
import '../../../../core/utils/church_filter_mixin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagingRepositoryImpl with ChurchFilterMixin implements IMessagingRepository {
  final SupabaseClient _supabase;
  final IsarService _isarService;
  final OfflineSyncManager _syncManager;
  final Ref _ref;

  MessagingRepositoryImpl(this._supabase, this._isarService, this._syncManager, this._ref);

  @override
  Future<void> dispose() async {
    AppLogger.d('MessagingRepository disposed', 'MessagingRepo');
  }

  @override
  Future<void> unsubscribeFromMessages(String conversationId) async {
  }

  @override
  Future<List<Conversation>> getConversations() async {
    final churchId = getActiveChurchId(_ref);
    
    if (!_isarService.isReady) {
      final List<dynamic> data = await applyChurchFilter(
        _supabase.from('conversations').select(),
        churchId,
        allowEmpty: true,
      ).order('last_message_at', ascending: false);
      return data.map((json) => Conversation.fromJson(json)).toList();
    }
    final isar = _isarService.db;

    try {
      final List<dynamic> data = await applyChurchFilter(
        _supabase.from('conversations').select(),
        churchId,
        allowEmpty: true,
      ).order('last_message_at', ascending: false)
          .timeout(const Duration(seconds: 20));

      await isar.writeTxn(() async {
        for (final json in data) {
          final conversation = Conversation.fromJson(json);
          await isar.conversationModels.put(
            ConversationModel.fromEntity(conversation),
          );
        }
      });
    } catch (e, stack) {
      AppLogger.e(
          'Failed to fetch/sync conversations', 'MessagingRepo', e, stack);
    }

    final models = await isar.conversationModels
        .where()
        .sortByLastMessageAtDesc()
        .findAll();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Stream<List<Conversation>> watchConversations() async* {
    final churchId = getActiveChurchId(_ref);
    
    if (!_isarService.isReady) {
      final stream = _supabase.from('conversations').stream(primaryKey: ['id']);
      final filteredStream = (churchId != null && churchId != '*') 
        ? stream.eq('church_id', churchId) 
        : stream;
        
      yield* filteredStream
          .order('last_message_at', ascending: false)
          .asyncMap((data) async =>
              data.map((json) => Conversation.fromJson(json)).toList());
      return;
    }

    final controller = StreamController<List<Conversation>>();
    
    final channel = _supabase
          .channel('public:conversations')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'conversations',
            filter: (churchId != null && churchId != '*') 
              ? PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'church_id', value: churchId)
              : null,
            callback: (payload) async {
              if (payload.newRecord.isNotEmpty) {
                final conversation = Conversation.fromJson(payload.newRecord);
                await _isarService.db.writeTxn(() async {
                  await _isarService.db.conversationModels.put(
                    ConversationModel.fromEntity(conversation),
                  );
                });
              }
            },
          )
          .subscribe();

    final isarSubscription = _isarService.db.conversationModels
        .where()
        .sortByLastMessageAtDesc()
        .watch(fireImmediately: true)
        .listen((models) {
      controller.add(models.map((e) => e.toEntity()).toList());
    });

    controller.onCancel = () {
      isarSubscription.cancel();
      channel.unsubscribe();
      controller.close();
    };

    yield* controller.stream;
  }

  @override
  Future<List<ChatMessage>> getMessages(
    String conversationId, {
    int limit = 50,
  }) async {
    if (!_isarService.isReady) {
      final List<dynamic> data = await _supabase
          .from('chat_messages')
          .select()
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: false)
          .limit(limit);
      return data.map((json) => ChatMessage.fromJson(json)).toList();
    }
    final isar = _isarService.db;

    try {
      final List<dynamic> data = await _supabase
          .from('chat_messages')
          .select()
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: false)
          .limit(limit)
          .timeout(const Duration(seconds: 20));

      await isar.writeTxn(() async {
        for (final json in data) {
          final message = ChatMessage.fromJson(json);
          await isar.chatMessageModels.put(
            ChatMessageModel.fromEntity(message),
          );
        }
      });
    } catch (e, stack) {
      AppLogger.e('Failed to fetch/sync messages for $conversationId',
          'MessagingRepo', e, stack);
    }

    final models = await isar.chatMessageModels
        .filter()
        .conversationIdEqualTo(conversationId)
        .sortByCreatedAtDesc()
        .limit(limit)
        .findAll();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Stream<List<ChatMessage>> watchMessages(String conversationId) async* {
    if (!_isarService.isReady) {
      yield* _supabase
          .from('chat_messages')
          .stream(primaryKey: ['id'])
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: false)
          .limit(50)
          .asyncMap((data) async =>
              data.map((json) => ChatMessage.fromJson(json)).toList());
      return;
    }

    final controller = StreamController<List<ChatMessage>>();
    
    final channel = _supabase
          .channel('chat_messages:$conversationId')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'chat_messages',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'conversation_id',
              value: conversationId,
            ),
            callback: (payload) async {
              if (payload.newRecord.isNotEmpty) {
                final message = ChatMessage.fromJson(payload.newRecord);
                await _isarService.db.writeTxn(() async {
                  await _isarService.db.chatMessageModels.put(
                    ChatMessageModel.fromEntity(message)..isSynced = true,
                  );
                });
              }
            },
          )
          .subscribe();

    final isarSubscription = _isarService.db.chatMessageModels
        .filter()
        .conversationIdEqualTo(conversationId)
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .listen((models) {
      controller.add(models.map((e) => e.toEntity()).toList());
    });

    controller.onCancel = () {
      isarSubscription.cancel();
      channel.unsubscribe();
      controller.close();
    };

    yield* controller.stream;
  }

  @override
  Future<String> createConversation(
    List<String> participantsIds, {
    String? title,
  }) async {
    if (participantsIds.length == 2) {
      try {
        final existing = await _supabase
            .from('conversations')
            .select('id')
            .eq('type', 'private')
            .contains('participants_ids', participantsIds)
            .maybeSingle();

        if (existing != null) {
          return existing['id'] as String;
        }
      } catch (e) {
        AppLogger.w(
            'Error checking for existing conversation: $e', 'MessagingRepo');
      }
    }

    final conversation = Conversation(
      id: '',
      type: participantsIds.length > 2
          ? ConversationType.group
          : ConversationType.private,
      participantsIds: participantsIds,
      title: title,
      createdAt: AppDateTime.nowUtc(),
      updatedAt: AppDateTime.nowUtc(),
      lastMessageAt: AppDateTime.nowUtc(),
    );

    try {
      final response = await _supabase
          .from('conversations')
          .insert(conversation.toJson())
          .select()
          .single()
          .timeout(const Duration(seconds: 20));
      final created = Conversation.fromJson(response);
      if (_isarService.isReady) {
        final isar = _isarService.db;
        await isar.writeTxn(() async {
          await isar.conversationModels.put(
            ConversationModel.fromEntity(created),
          );
        });
      }
      return created.id;
    } catch (e) {
      if (!_isarService.isReady) rethrow;
      final isar = _isarService.db;
      final tempId = AppDateTime.tempId();
      final tempConversation = conversation.copyWith(id: tempId);
      await isar.writeTxn(() async {
        await isar.conversationModels.put(
          ConversationModel.fromEntity(tempConversation),
        );
      });
      return tempId;
    }
  }

  @override
  Future<String> getOrCreateGroupConversation(String groupId, String title) async {
    try {
      final existing = await _supabase
          .from('conversations')
          .select('id')
          .eq('type', 'group')
          .contains('metadata', {'group_id': groupId})
          .maybeSingle();

      if (existing != null) {
        return existing['id'] as String;
      }

      final conversation = Conversation(
        id: '',
        type: ConversationType.group,
        participantsIds: [],
        title: title,
        createdAt: AppDateTime.nowUtc(),
        updatedAt: AppDateTime.nowUtc(),
        lastMessageAt: AppDateTime.nowUtc(),
      );

      final response = await _supabase
          .from('conversations')
          .insert({
            ...conversation.toJson(),
            'metadata': {'group_id': groupId}
          })
          .select()
          .single();

      final created = Conversation.fromJson(response);
      return created.id;
    } catch (e, stack) {
      AppLogger.e('Failed to get/create group conversation for $groupId',
          'MessagingRepo', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> sendMessage(ChatMessage message) async {
    final churchId = getActiveChurchId(_ref);
    
    try {
      final json = message.toJson();
      json.remove('id');
      
      if (_isarService.isReady) {
        final model = ChatMessageModel.fromEntity(message)..isSynced = false;
        await _isarService.db.writeTxn(() => _isarService.db.chatMessageModels.put(model));

        await _syncManager.registerAction(
          entityType: 'chat_messages',
          action: 'INSERT',
          payload: json,
          churchId: churchId ?? '',
          recordId: message.id,
        );
      } else {
        await _supabase
            .from('chat_messages')
            .insert(json)
            .timeout(const Duration(seconds: 20));
      }
    } catch (e, stack) {
      AppLogger.e('Failed to send message', 'MessagingRepo', e, stack);
      if (!_isarService.isReady) rethrow;
    }
  }

  @override
  Future<void> markAsRead(String conversationId, String userId) async {
    try {
      await _supabase
          .from('chat_messages')
          .update({'is_read': true})
          .eq('conversation_id', conversationId)
          .neq('sender_id', userId)
          .timeout(const Duration(seconds: 10));
    } catch (e, stack) {
      AppLogger.e('Failed to mark messages as read', 'MessagingRepo', e, stack);
    }
  }

  @override
  Future<String?> uploadFile(File file, String folder) async {
    try {
      final fileName =
          '${AppDateTime.nowMillis()}_${file.path.split('/').last}';
      final path = '$folder/$fileName';

      await _supabase.storage
          .from('chat_attachments')
          .upload(
            path,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          )
          .timeout(const Duration(seconds: 60));

      final publicUrl =
          _supabase.storage.from('chat_attachments').getPublicUrl(path);
      return publicUrl;
    } catch (e, stack) {
      AppLogger.e(
          'Failed to upload file to $folder', 'MessagingRepo', e, stack);
      return null;
    }
  }

  @override
  Future<void> togglePinConversation(
      String conversationId, bool isPinned) async {
    try {
      final isar = _isarService.db;
      await isar.writeTxn(() async {
        final conv = await isar.conversationModels
            .filter()
            .remoteIdEqualTo(conversationId)
            .findFirst();
        if (conv != null) {
          conv.isPinned = isPinned;
          await isar.conversationModels.put(conv);
        }
      });
    } catch (e, stack) {
      AppLogger.e('Failed to toggle pin for $conversationId', 'MessagingRepo',
          e, stack);
    }
  }

  @override
  Future<void> toggleMuteConversation(
      String conversationId, bool isMuted) async {
    try {
      final isar = _isarService.db;
      await isar.writeTxn(() async {
        final conv = await isar.conversationModels
            .filter()
            .remoteIdEqualTo(conversationId)
            .findFirst();
        if (conv != null) {
          conv.isMuted = isMuted;
          await isar.conversationModels.put(conv);
        }
      });
    } catch (e, stack) {
      AppLogger.e('Failed to toggle mute for $conversationId', 'MessagingRepo',
          e, stack);
    }
  }

  @override
  Future<void> blockUser(String userId) async {
  }

  @override
  Future<void> unblockUser(String userId) async {
  }

  @override
  Future<void> clearHistory(String conversationId) async {
    try {
      final isar = _isarService.db;
      await isar.writeTxn(() async {
        await isar.chatMessageModels
            .filter()
            .conversationIdEqualTo(conversationId)
            .deleteAll();
      });
    } catch (e) {
      throw Exception('Failed to clear history: $e');
    }
  }

  @override
  Future<List<ChatMessage>> searchMessages(
      String conversationId, String query) async {
    if (query.trim().isEmpty) return [];
    try {
      final isar = _isarService.db;
      final localResults = await isar.chatMessageModels
          .filter()
          .conversationIdEqualTo(conversationId)
          .and()
          .contentContains(query, caseSensitive: false)
          .findAll();

      return localResults.map((m) => m.toEntity()).toList();
    } catch (e, stack) {
      AppLogger.e('Failed to search messages for $conversationId',
          'MessagingRepo', e, stack);
      return [];
    }
  }

  @override
  Future<List<String>> getSharedMediaUrls(String conversationId) async {
    try {
      final isar = _isarService.db;
      final localMedia = await isar.chatMessageModels
          .filter()
          .conversationIdEqualTo(conversationId)
          .and()
          .typeEqualTo('image')
          .findAll();

      return localMedia.map((m) => m.content).toList();
    } catch (e, stack) {
      AppLogger.e('Failed to fetch shared media for $conversationId',
          'MessagingRepo', e, stack);
      return [];
    }
  }
}
