import "package:lumina/core/widgets/widgets.dart";
import 'package:flutter/material.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import 'package:lumina/features/messaging/domain/entities/conversation.dart';
import 'package:lumina/features/messaging/presentation/providers/messaging_providers.dart';
import 'package:lumina/features/profile/domain/entities/profile.dart';
import 'package:lumina/features/profile/presentation/providers/profile_provider.dart';
import 'package:lumina/core/providers/auth_provider.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final conversationsAsync = ref.watch(conversationsProvider);
    final currentUserId = ref.watch(currentUserIdProvider) ?? 'guest';

    return LuminaPage(
      title: "Messagerie",
      onRefresh: () async => ref.invalidate(conversationsProvider),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.brebis),
        backgroundColor: LuminaDesign.primary,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: conversationsAsync.when(
              data: (conversations) {
                final filtered = _filterConversations(conversations);
                if (filtered.isEmpty) return const Center(child: Text("Aucune discussion"));
                
                return ListView.builder(
                  padding: const EdgeInsets.all(LuminaDesign.paddingMd),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) {
                    final conv = filtered[i];
                    final otherId = conv.participantsIds.firstWhere((id) => id != currentUserId, orElse: () => '');
                    final profileAsync = ref.watch(otherUserProfileProvider(otherId));
                    
                    return LuminaCard(
                      onTap: () => context.push(AppRoutes.messagingConversationWithId(conv.id)),
                      child: Row(
                        children: [
                          _buildAvatar(profileAsync),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(profileAsync.valueOrNull?.displayName ?? "Discussion", style: LuminaDesign.bodyLargeOf(context).copyWith(fontWeight: FontWeight.bold)),
                                Text(conv.lastMessageContent ?? "Nouvelle discussion", maxLines: 1, overflow: TextOverflow.ellipsis, style: LuminaDesign.labelOf(context)),
                              ],
                            ),
                          ),
                          if (conv.unreadCount > 0)
                            CircleAvatar(radius: 10, backgroundColor: LuminaDesign.primary, child: Text("${conv.unreadCount}", style: const TextStyle(fontSize: 10, color: Colors.white))),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const LoadingState(),
              error: (e, _) => Center(child: Text("Erreur : $e")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _filterButton("Tous", "all"),
          _filterButton("Directs", "direct"),
          _filterButton("Groupes", "group"),
        ],
      ),
    );
  }

  Widget _filterButton(String label, String val) {
    final selected = _selectedFilter == val;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _selectedFilter = val),
        selectedColor: LuminaDesign.primary.withOpacity(0.2),
      ),
    );
  }

  Widget _buildAvatar(AsyncValue<Profile?> profile) {
    return profile.when(
      data: (p) => CircleAvatar(
        radius: 25,
        backgroundColor: LuminaDesign.primary.withOpacity(0.1),
        backgroundImage: p?.avatarUrl != null ? NetworkImage(p!.avatarUrl!) : null,
        child: p?.avatarUrl == null ? Text(p?.initials ?? "?") : null,
      ),
      loading: () => const CircleAvatar(radius: 25, child: LoadingDots()),
      error: (_, __) => const CircleAvatar(radius: 25, child: Icon(Icons.error)),
    );
  }

  List<Conversation> _filterConversations(List<Conversation> list) {
    if (_selectedFilter == 'direct') return list.where((c) => c.type == ConversationType.private).toList();
    if (_selectedFilter == 'group') return list.where((c) => c.type == ConversationType.group).toList();
    return list;
  }
}
