import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final socialRealtimeRepositoryProvider = Provider((ref) {
  return SocialRealtimeRepository(supabase: Supabase.instance.client);
});

class SocialRealtimeRepository {
  final SupabaseClient supabase;

  SocialRealtimeRepository({required this.supabase});

  Stream<List<SocialPost>> watchPosts(String churchId) {
    return supabase
        .from('social_posts')
        .stream(primaryKey: ['id'])
        .eq('church_id', churchId)
        .order('created_at', ascending: false)
        .map((data) => data.map((e) => SocialPost.fromJson(e)).toList());
  }

  Stream<List<Comment>> watchComments(String postId) {
    return supabase
        .from('social_comments')
        .stream(primaryKey: ['id'])
        .eq('post_id', postId)
        .order('created_at')
        .map((data) => data.map((e) => Comment.fromJson(e)).toList());
  }

  Stream<int> watchUnreadCount(String userId) {
    return supabase
        .from('social_notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) => data.where((e) => e['is_read'] == false).length);
  }
}

class SocialPost {
  final String id;
  final String churchId;
  final String authorId;
  final String content;
  final DateTime createdAt;

  SocialPost({
    required this.id,
    required this.churchId,
    required this.authorId,
    required this.content,
    required this.createdAt,
  });

  factory SocialPost.fromJson(Map<String, dynamic> json) {
    return SocialPost(
      id: json['id'],
      churchId: json['church_id'],
      authorId: json['author_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class Comment {
  final String id;
  final String postId;
  final String authorId;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['post_id'],
      authorId: json['author_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}