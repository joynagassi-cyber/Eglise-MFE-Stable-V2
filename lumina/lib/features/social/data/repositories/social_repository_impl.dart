import 'dart:async';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/architecture/result.dart';
import '../../../../core/errors/failures.dart' as err;
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/services/offline_sync_manager.dart';
import '../../../../core/utils/supabase_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/social_post.dart';
import '../../domain/repositories/i_social_repository.dart';
import '../models/social_post_model.dart';
import '../models/social_comment_model.dart';
import '../../domain/entities/social_comment.dart';

class SocialRepositoryImpl implements ISocialRepository {
  final SupabaseClient _supabase;
  final IsarService _isarService;
  final OfflineSyncManager _syncManager;
  final Ref _ref;

  SocialRepositoryImpl(this._supabase, this._isarService, this._syncManager, this._ref);

  /// Raccourci pour lire l'ID d'église active depuis le provider
  String get _churchId => _ref.read(activeChurchIdProvider);

  @override
  Future<List<SocialPost>> getPosts({int limit = 20, int offset = 0}) async {
    final churchId = _churchId;

    if (!_isarService.isReady) {
      final List<dynamic> data = await _supabase
          .from('social_posts')
          .select('*, members(first_name, last_name, avatar_url)')
          .scoped(_ref, allowEmpty: true)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1)
          .timeout(const Duration(seconds: 20));
      return data.map((json) => _mapPostJson(json as Map<String, dynamic>)).toList();
    }
    final isar = _isarService.db;

    try {
      final List<dynamic> data = await _supabase
          .from('social_posts')
          .select()
          .scoped(_ref, allowEmpty: true)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      await isar.writeTxn(() async {
        for (final json in data) {
          final post = _mapPostJson(json as Map<String, dynamic>);
          final model = SocialPostModel.fromEntity(post)..churchId = churchId;
          await isar.socialPostModels.put(model);
        }
      });
    } catch (e, stack) {
      AppLogger.e('Failed to fetch/sync social posts', 'SocialRepo', e, stack);
    }

    final query = isar.socialPostModels.where();
    final models = await query
        .filter()
        .optional(churchId != '*' && churchId != 'global', (q) => q.churchIdEqualTo(churchId))
        .sortByCreatedAtDesc()
        .offset(offset)
        .limit(limit)
        .findAll();

    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Stream<List<SocialPost>> watchPosts() async* {
    final churchId = _churchId;

    if (!_isarService.isReady) {
      yield* _supabase.from('social_posts')
          .stream(primaryKey: ['id'])
          .order('created_at', ascending: false)
          .limit(20)
          .asyncMap((records) async {
            return records.map((json) => _mapPostJson(json)).toList();
          });
      return;
    }

    final controller = StreamController<List<SocialPost>>();

    final channel = _supabase
          .channel('social_posts')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'social_posts',
            filter: churchId != '*' && churchId != 'global'
                ? PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'church_id', value: churchId)
                : null,
            callback: (payload) async {
              if (payload.newRecord.isNotEmpty) {
                final post = _mapPostJson(payload.newRecord);
                await _isarService.db.writeTxn(() async {
                  await _isarService.db.socialPostModels.put(
                    SocialPostModel.fromEntity(post)
                      ..churchId = churchId
                      ..isSynced = true,
                  );
                });
              }
            },
          )
          .subscribe();

    final query = _isarService.db.socialPostModels.where();
    final filteredQuery = query.filter()
        .optional(churchId != '*' && churchId != 'global', (q) => q.churchIdEqualTo(churchId))
        .sortByCreatedAtDesc();

    final isarSubscription = filteredQuery
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
  Future<SocialResult> createPost(SocialPost post) async {
    try {
      final churchId = _churchId;

      if (_isarService.isReady) {
        final isar = _isarService.db;
        final model = SocialPostModel.fromEntity(post)
          ..churchId = churchId
          ..isSynced = false;

        await isar.writeTxn(() async {
          await isar.socialPostModels.put(model);
        });

        await _syncManager.registerAction(
          entityType: 'social_posts',
          action: 'INSERT',
          payload: post.toJson(),
          churchId: churchId,
          recordId: post.id,
        );
      } else {
        await _supabase.from('social_posts').upsert(post.toJson());
      }

      return const Success(null);
    } catch (e, st) {
      return Failure(
        err.ServerFailure('Échec de la création du post: $e', stackTrace: st),
      );
    }
  }

  @override
  Future<void> likePost(String postId) async {
    final churchId = _churchId;

    if (_isarService.isReady) {
      final isar = _isarService.db;
      final model = await isar.socialPostModels
          .filter()
          .remoteIdEqualTo(postId)
          .findFirst();

      if (model != null) {
        await isar.writeTxn(() async {
          model.likesCount += 1;
          await isar.socialPostModels.put(model);
        });

        await _syncManager.registerAction(
          entityType: 'social_posts',
          action: 'UPDATE',
          payload: {'id': postId, 'likes_count': model.likesCount},
          churchId: churchId,
          recordId: 'like_$postId',
        );
      }
    } else {
      await _supabase.rpc('increment_likes', params: {'p_post_id': postId});
    }
  }

  @override
  Future<SocialResult> deletePost(String id) async {
    try {
      final churchId = _churchId;

      if (_isarService.isReady) {
        final isar = _isarService.db;
        final model = await isar.socialPostModels
            .filter()
            .remoteIdEqualTo(id)
            .findFirst();

        if (model != null) {
          await isar.writeTxn(() async {
            model.isDeleted = true;
            model.isSynced = false;
            await isar.socialPostModels.put(model);
          });

          await _syncManager.registerAction(
            entityType: 'social_posts',
            action: 'DELETE',
            payload: {'id': id},
            churchId: churchId,
            recordId: id,
          );
        } else {
          AppLogger.w(
            'deletePost: post $id introuvable dans Isar (pas encore synchronisé)',
            'SocialRepo',
          );
          return Failure(
            err.CacheFailure('Publication $id introuvable. Peut-être pas encore synchronisée.'),
          );
        }
      } else {
        await _supabase.from('social_posts').delete().eq('id', id);
      }

      return const Success(null);
    } catch (e, st) {
      return Failure(
        err.ServerFailure('Échec de la suppression du post $id: $e', stackTrace: st),
      );
    }
  }

  @override
  Future<List<SocialComment>> getComments(String postId) async {
    final churchId = _churchId;

    if (!_isarService.isReady) {
      final List<dynamic> data = await _supabase
          .from('social_comments')
          .select()
          .eq('post_id', postId)
          .order('created_at', ascending: false);
      return data.map((json) => SocialComment.fromJson(json)).toList();
    }
    final isar = _isarService.db;

    try {
      final List<dynamic> data = await _supabase
          .from('social_comments')
          .select()
          .eq('post_id', postId)
          .order('created_at', ascending: false);

      await isar.writeTxn(() async {
        for (final json in data) {
          final comment = SocialComment.fromJson(json);
          final model = SocialCommentModel.fromEntity(comment)..churchId = churchId;
          await isar.socialCommentModels.put(model);
        }
      });
    } catch (e, stack) {
      AppLogger.e('Failed to fetch/sync social comments for $postId',
          'SocialRepo', e, stack);
    }

    final models = await isar.socialCommentModels
        .filter()
        .postIdEqualTo(postId)
        .sortByCreatedAtDesc()
        .findAll();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Stream<List<SocialComment>> watchComments(String postId) async* {
    if (!_isarService.isReady) {
      yield* _supabase
          .from('social_comments')
          .stream(primaryKey: ['id'])
          .eq('post_id', postId)
          .order('created_at', ascending: false)
          .map((data) =>
              data.map((json) => SocialComment.fromJson(json)).toList());
      return;
    }

    final controller = StreamController<List<SocialComment>>();

    final channel = _supabase
          .channel('social_comments:$postId')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'social_comments',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'post_id',
              value: postId,
            ),
            callback: (payload) async {
              if (payload.newRecord.isNotEmpty) {
                final comment = SocialComment.fromJson(payload.newRecord);
                await _isarService.db.writeTxn(() async {
                  await _isarService.db.socialCommentModels.put(
                    SocialCommentModel.fromEntity(comment)..isSynced = true,
                  );
                });
              }
            },
          )
          .subscribe();

    final isarSubscription = _isarService.db.socialCommentModels
        .filter()
        .postIdEqualTo(postId)
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
  Future<void> addComment(SocialComment comment) async {
    final churchId = _churchId;

    if (_isarService.isReady) {
      final isar = _isarService.db;
      final model = SocialCommentModel.fromEntity(comment)
        ..churchId = churchId
        ..isSynced = false;

      await isar.writeTxn(() async {
        await isar.socialCommentModels.put(model);
      });

      await _syncManager.registerAction(
        entityType: 'social_comments',
        action: 'INSERT',
        payload: comment.toJson(),
        churchId: churchId,
        recordId: comment.id,
      );
    } else {
      await _supabase.from('social_comments').upsert(comment.toJson());
    }
  }

  SocialPost _mapPostJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json);
    final member = data['members'] as Map<String, dynamic>?;
    if (member != null) {
      final firstName = member['first_name'] ?? '';
      final lastName = member['last_name'] ?? '';
      data['author_name'] = '$firstName $lastName'.trim();
      data['author_avatar_url'] = member['avatar_url'];
    } else {
      data['author_name'] ??= 'Membre';
    }
    if (data['media_urls'] != null && data['media_urls'] is List) {
      data['image_urls'] = List<String>.from(data['media_urls'] as List);
    }
    return SocialPost.fromJson(data);
  }
}
