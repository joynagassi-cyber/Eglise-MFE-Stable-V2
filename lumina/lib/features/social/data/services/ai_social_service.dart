// lib/features/social/data/services/ai_social_service.dart
// Service pour interagir avec les Edge Functions IA du Social (génération, amélioration, modération)

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/logging/app_logger.dart';

/// Résultat de l'amélioration IA
class AiImproveResult {
  final String improved;
  final String corrections;
  final bool intentionPreserved;

  const AiImproveResult({
    required this.improved,
    required this.corrections,
    required this.intentionPreserved,
  });

  factory AiImproveResult.fromJson(Map<String, dynamic> json) {
    return AiImproveResult(
      improved: json['improved'] as String? ?? '',
      corrections: json['corrections'] as String? ?? '',
      intentionPreserved: json['intentionPreserved'] as bool? ?? true,
    );
  }
}

/// Résultat de la modération IA
class AiModerationResult {
  final bool flagged;
  final String category;
  final int severity;
  final String reason;

  const AiModerationResult({
    required this.flagged,
    this.category = 'none',
    this.severity = 0,
    this.reason = '',
  });

  factory AiModerationResult.fromJson(Map<String, dynamic> json) {
    return AiModerationResult(
      flagged: json['flagged'] as bool? ?? false,
      category: json['category'] as String? ?? 'none',
      severity: json['severity'] as int? ?? 0,
      reason: json['reason'] as String? ?? '',
    );
  }
}

/// Résultat de la génération de post IA
class AiGenerateResult {
  final bool success;
  final String? postId;
  final String? verse;
  final String? content;
  final String? error;

  const AiGenerateResult({
    required this.success,
    this.postId,
    this.verse,
    this.content,
    this.error,
  });

  factory AiGenerateResult.fromJson(Map<String, dynamic> json) {
    return AiGenerateResult(
      success: json['success'] as bool? ?? false,
      postId: json['post_id'] as String?,
      verse: json['verse'] as String?,
      content: json['content'] as String?,
      error: json['error'] as String?,
    );
  }
}

class AiSocialService {
  final SupabaseClient _supabase;

  AiSocialService(this._supabase);

  /// Améliorer un post utilisateur avec l'IA
  /// Préserve l'intention, corrige les fautes, reformule
  Future<AiImproveResult> improvePost({
    required String content,
    String? postId,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'improve-post',
        body: {
          'content': content,
          'post_id': postId,
        },
      );

      if (response.data != null) {
        return AiImproveResult.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
      }
    } catch (e, stack) {
      AppLogger.e('Erreur improve-post', 'AI_SOCIAL', e, stack);
    }

    // Fallback : retourner le texte original
    return AiImproveResult(
      improved: content,
      corrections: 'Service non disponible',
      intentionPreserved: true,
    );
  }

  /// Modérer un post avec l'IA
  /// Détecte : haine, méchanceté, colère, hors contexte chrétien
  Future<AiModerationResult> moderatePost({
    required String postId,
    required String content,
    String? authorName,
    bool isAiGenerated = false,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'moderate-post',
        body: {
          'post_id': postId,
          'content': content,
          'author_name': authorName,
          'is_ai_generated': isAiGenerated,
        },
      );

      if (response.data != null) {
        return AiModerationResult.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
      }
    } catch (e, stack) {
      AppLogger.e('Erreur moderate-post', 'AI_SOCIAL', e, stack);
    }

    // Fallback safe : ne pas flaguer en cas d'erreur
    return const AiModerationResult(flagged: false);
  }

  /// Générer un post biblique automatique (appel admin)
  Future<AiGenerateResult> generateAiPost({
    String? tone,   // 'morning' ou 'evening'
    String? churchId,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'generate-ai-post',
        body: {
          if (tone != null) 'tone': tone,
          if (churchId != null) 'church_id': churchId,
        },
      );

      if (response.data != null) {
        return AiGenerateResult.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
      }
    } catch (e, stack) {
      AppLogger.e('Erreur generate-ai-post', 'AI_SOCIAL', e, stack);
    }

    return AiGenerateResult(
      success: false,
      error: 'Service de génération non disponible',
    );
  }
}
