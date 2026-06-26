

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/features/messaging/domain/entities/chat_message.dart';
import 'package:lumina/features/messaging/presentation/providers/messaging_providers.dart';

import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/core/providers/repository_providers_messaging.dart';
import '../../../../core/extensions/context_extension.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  const ChatScreen({super.key, required this.conversationId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final auth = ref.read(authProvider).valueOrNull;
    final msg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: widget.conversationId,
      senderId: auth?.userId ?? 'guest',
      senderName: auth?.name ?? 'Anonyme',
      content: content,
      type: MessageType.text,
      createdAt: DateTime.now(),
    );

    await ref.read(messagingRepositoryProvider).sendMessage(msg);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.conversationId));
    final auth = ref.watch(authProvider).valueOrNull;

    return LuminaPage(
      title: "Discussion",
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) => ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(LuminaDesign.paddingMd),
                itemCount: messages.length,
                itemBuilder: (ctx, i) {
                  final m = messages[i];
                  final isMe = m.senderId == auth?.userId;
                  return _MessageBubble(message: m, isMe: isMe);
                },
              ),
              loading: () => const LoadingState(),
              error: (e, _) => Center(child: Text("Erreur : $e")),
            ),
          ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(LuminaDesign.paddingMd),
      color: context.colors.bgPage,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Écrire un message...",
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: LuminaDesign.primary),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? LuminaDesign.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: LuminaDesign.shadowSm,
        ),
        child: Text(
          message.content,
          style: TextStyle(color: isMe ? Colors.white : context.colors.textPrimary),
        ),
      ),
    );
  }
}
