// lib/features/social/presentation/providers/ai_social_providers.dart
// Providers Riverpod pour les fonctionnalités IA du social

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:lumina/core/providers/repository_providers_messaging.dart';
import '../../domain/repositories/i_social_repository.dart' show ISocialRepository;
import 'package:lumina/core/providers/supabase_provider.dart';
import '../../data/services/ai_social_service.dart';
import '../../domain/entities/social_post.dart';

// ── Provider du service AI ─────────────────────────────────

final aiSocialServiceProvider = Provider<AiSocialService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return AiSocialService(supabase);
});

// ── Provider pour améliorer un post ────────────────────────

final improvePostProvider = FutureProvider.family<AiImproveResult, String>(
  (ref, content) async {
    final service = ref.watch(aiSocialServiceProvider);
    return service.improvePost(content: content);
  },
);

// ── Provider pour modérer un post (appelé après création) ──

final moderatePostProvider = FutureProvider.family<AiModerationResult, SocialPost>(
  (ref, post) async {
    final service = ref.watch(aiSocialServiceProvider);
    return service.moderatePost(
      postId: post.id,
      content: post.content,
      authorName: post.authorName,
      isAiGenerated: post.isAiGenerated,
    );
  },
);

// ── Provider pour générer un post IA (admin) ───────────────

final generateAiPostProvider = FutureProvider.family<AiGenerateResult, String?>(
  (ref, tone) async {
    final service = ref.watch(aiSocialServiceProvider);
    return service.generateAiPost(tone: tone);
  },
);

// ── Notifier pour l'édition de post avec amélioration IA ───

class PostEditorNotifier extends StateNotifier<PostEditorState> {
  final AiSocialService _aiService;
  final ISocialRepository _repository;

  PostEditorNotifier(this._aiService, this._repository)
      : super(PostEditorState());

  /// Met à jour le contenu
  void updateContent(String content) {
    state = state.copyWith(content: content, isImproved: false);
  }

  /// Améliore le contenu avec l'IA
  Future<void> improveWithAi() async {
    if (state.content.trim().isEmpty) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _aiService.improvePost(content: state.content);
      state = state.copyWith(
        content: result.improved,
        isImproved: true,
        isLoading: false,
        improvements: result.corrections,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur: $e',
      );
    }
  }

  /// Publie le post et déclenche la modération si nécessaire
  Future<SocialPost?> publish({
    required String authorId,
    required String authorName,
    String? authorAvatarUrl,
    List<String> imageUrls = const [],
  }) async {
    if (state.content.trim().isEmpty) return null;
    
    state = state.copyWith(isPublishing: true, error: null);
    
    try {
      // Générer un UUID côté client pour que l'ID soit connu
      // avant l'appel à moderate-post (évite post_id vide)
      final postId = const Uuid().v4();
      
      final post = SocialPost(
        id: postId,
        authorId: authorId,
        authorName: authorName,
        authorAvatarUrl: authorAvatarUrl,
        content: state.content,
        imageUrls: imageUrls,
        createdAt: DateTime.now(),
      );
      
      await _repository.createPost(post);
      
      // Déclencher la modération IA en arrière-plan avec le vrai ID
      _moderatePost(post); // ignore: unawaited_futures
      
      state = state.copyWith(isPublishing: false, content: '');
      return post;
    } catch (e) {
      state = state.copyWith(
        isPublishing: false,
        error: 'Erreur publication: $e',
      );
      return null;
    }
  }

  /// Modération IA en arrière-plan (fire & forget)
  Future<void> _moderatePost(SocialPost post) async {
    try {
      await _aiService.moderatePost(
        postId: post.id,
        content: post.content,
        authorName: post.authorName,
      );
    } catch (e) {
      // Échec silencieux — la modération n'est pas bloquante
    }
  }

  /// Réinitialise l'éditeur
  void reset() {
    state = PostEditorState();
  }
}

// ── État de l'éditeur ─────────────────────────────────────

class PostEditorState {
  final String content;
  final bool isLoading;
  final bool isPublishing;
  final bool isImproved;
  final String? error;
  final String? improvements;

  const PostEditorState({
    this.content = '',
    this.isLoading = false,
    this.isPublishing = false,
    this.isImproved = false,
    this.error,
    this.improvements,
  });

  PostEditorState copyWith({
    String? content,
    bool? isLoading,
    bool? isPublishing,
    bool? isImproved,
    String? error,
    String? improvements,
  }) {
    return PostEditorState(
      content: content ?? this.content,
      isLoading: isLoading ?? this.isLoading,
      isPublishing: isPublishing ?? this.isPublishing,
      isImproved: isImproved ?? this.isImproved,
      error: error,
      improvements: improvements ?? this.improvements,
    );
  }
}

// Provider pour l'éditeur de post
final postEditorProvider =
    StateNotifierProvider<PostEditorNotifier, PostEditorState>((ref) {
  final aiService = ref.watch(aiSocialServiceProvider);
  final repository = ref.watch(socialRepositoryProvider);
  return PostEditorNotifier(aiService, repository);
});
