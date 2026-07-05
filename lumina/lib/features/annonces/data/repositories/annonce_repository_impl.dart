import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/annonce.dart';
import '../../domain/entities/commentaire.dart';
import '../../domain/repositories/i_annonce_repository.dart';
import '../models/annonce_model.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/utils/supabase_extensions.dart';
import '../../../../features/notifications/domain/services/notification_service.dart';

class AnnonceRepositoryImpl implements IAnnonceRepository {
  final SupabaseClient _supabase;
  final IsarService _isar;
  final Ref _ref;
  final _logger = Logger();

  AnnonceRepositoryImpl(this._supabase, this._isar, this._ref);

  @override
  Future<List<Annonce>> getAnnonces({
    String? churchId,
    String? type,
    String? status,
    bool? isPublished,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      if (_isar.isReady) {
        final localModels = await _isar.getAnnonces();

        if (localModels.isNotEmpty) {
          var annonces = localModels.map((m) => m.toDomain()).toList();

          if (churchId != null) {
            annonces = annonces.where((a) => a.churchId == churchId).toList();
          }
          if (type != null) {
            annonces = annonces.where((a) => a.type == type).toList();
          }
          if (status != null) {
            annonces = annonces.where((a) => a.status == status).toList();
          }
          if (isPublished != null) {
            annonces =
                annonces.where((a) => a.isPublished == isPublished).toList();
          }
          if (startDate != null) {
            annonces = annonces
                .where(
                  (a) =>
                      a.date.isAfter(startDate) ||
                      a.date.isAtSameMomentAs(startDate),
                )
                .toList();
          }
          if (endDate != null) {
            annonces = annonces
                .where(
                  (a) =>
                      a.date.isBefore(endDate) ||
                      a.date.isAtSameMomentAs(endDate),
                )
                .toList();
          }

          annonces.sort((a, b) {
            if (a.isPinned != b.isPinned) {
              return b.isPinned ? -1 : 1; // Pinned first
            }
            return b.date.compareTo(a.date);
          });

          if (limit != null && limit > 0) {
            annonces = annonces.take(limit).toList();
          }
          return annonces;
        }
      }

      //  ISCHUS: Filtrage church_id automatique via SecureInterceptor
      var query = _supabase
          .from('annonces').select().scoped(_ref);

      //  Filtrage par groupes d'appartenance
      final userId = _supabase.auth.currentUser?.id;
      if (userId != null) {
        try {
          // Get member_id
          final memberRes = await _supabase
              .from('members')
              .select('id')
              .eq('profile_id', userId)
              .maybeSingle();
          final memberId = memberRes?['id']?.toString();

          if (memberId != null) {
            // Get active groups
            final groupsRes = await _supabase
                .from('group_memberships')
                .select('group_id')
                .eq('member_id', memberId)
                .eq('status', 'active');

            final groupIds = (groupsRes as List)
                .map((g) => g['group_id'].toString())
                .toList();

            if (groupIds.isNotEmpty) {
              final inList = groupIds.map((id) => '"$id"').join(',');
              query = query.or('group_id.is.null,group_id.in.($inList)');
            } else {
              query = query.filter('group_id', 'is', null);
            }
          }
        } catch (e) {
          _logger.w('Failed to apply group filter', error: e);
        }
      }

      if (status != null) {
        query = query.eq('status', status);
      }

      final List<dynamic> data = await query
          .order('is_pinned', ascending: false)
          .order('date', ascending: false);

      final annonces = data.map((json) => Annonce.fromJson(json)).toList();
      if (_isar.isReady) {
        await _saveAnnoncesToLocal(annonces);
      }

      return annonces;
    } catch (e) {
      if (_isar.isReady) {
        final localModels = await _isar.getAnnonces();
        if (localModels.isNotEmpty) {
          var annonces = localModels.map((m) => m.toDomain()).toList();
          if (churchId != null) {
            annonces = annonces.where((a) => a.churchId == churchId).toList();
          }
          return annonces;
        }
      }
      return [];
    }
  }

  @override
  Future<Annonce?> getAnnonceById(String id) async {
    try {
      if (_isar.isReady) {
        final localModels = await _isar.getAnnonces();
        final localModel = localModels.cast<AnnonceModel?>().firstWhere(
              (m) => m?.id == id,
              orElse: () => null,
            );
        if (localModel != null) return localModel.toDomain();
      }

      final response = await _supabase
          .from('annonces').select().scoped(_ref).eq('id', id).maybeSingle();
      if (response == null) return null;
      return Annonce.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Annonce> createAnnonce(Annonce annonce) async {
    if (_isar.isReady) {
      final model = AnnonceModel.fromDomain(annonce)
        ..lastSyncedAt = DateTime.now();
      await _isar.saveAnnonce(model);
    }

    try {
      final data = annonce.toJson();
      final response =
          await _supabase.from('annonces').upsert(data).select().single();
      final createdAnnonce = Annonce.fromJson(response);

      if (_isar.isReady) {
        final syncedModel = AnnonceModel.fromDomain(createdAnnonce)
          ..lastSyncedAt = DateTime.now();
        await _isar.saveAnnonce(syncedModel);
      }

      // Notification: notifier tous les membres si l'annonce est publiee
      if (createdAnnonce.isPublished) {
        final notifService = NotificationService(_ref);
        unawaited(notifService.onAnnouncementCreated(
          title: createdAnnonce.title,
          announcementId: createdAnnonce.id,
        ));
      }

      return createdAnnonce;
    } catch (e) {
      return annonce;
    }
  }

  @override
  Future<Annonce> updateAnnonce(Annonce annonce) async {
    if (_isar.isReady) {
      final model = AnnonceModel.fromDomain(annonce)
        ..lastSyncedAt = DateTime.now();
      await _isar.saveAnnonce(model);
    }

    try {
      final data = annonce.toJson();
      final response = await _supabase
          .from('annonces')
          .update(data)
          .eq('id', annonce.id)
          .select()
          .single();
      final updatedAnnonce = Annonce.fromJson(response);

      if (_isar.isReady) {
        final syncedModel = AnnonceModel.fromDomain(updatedAnnonce)
          ..lastSyncedAt = DateTime.now();
        await _isar.saveAnnonce(syncedModel);
      }

      return updatedAnnonce;
    } catch (e) {
      return annonce;
    }
  }

  @override
  Future<void> deleteAnnonce(String id) async {
    if (_isar.isReady) {
      final localAnnonces = await _isar.getAnnonces();
      final toDelete = localAnnonces.firstWhere(
        (m) => m.id == id,
        orElse: () => AnnonceModel()..id = 'not_found',
      );

      if (toDelete.id != 'not_found') {
        await _isar.deleteAnnonce(toDelete.isarId);
      }
    }

    try {
      await _supabase
          .from('annonces').delete().scoped(_ref).eq('id', id);
    } catch (e) {
      _logger.e('Error deleting annonce remote', error: e);
    }
  }

  @override
  Future<List<Annonce>> searchAnnonces(String query) async {
    final allAnnonces = await getAnnonces();
    final lowerQuery = query.toLowerCase();

    return allAnnonces.where((a) {
      return a.title.toLowerCase().contains(lowerQuery) ||
          (a.content?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  @override
  Future<List<Annonce>> getPublishedAnnonces({
    String? churchId,
    int? limit,
  }) async {
    return await getAnnonces(
      churchId: churchId,
      isPublished: true,
      status: 'PUBLIE',
      limit: limit,
    );
  }

  @override
  Future<List<Annonce>> getPinnedAnnonces({
    String? churchId,
    int? limit,
  }) async {
    final allAnnonces = await getAnnonces(
      churchId: churchId,
      isPublished: true,
    );
    var pinned = allAnnonces.where((a) => a.isPinned).toList();
    pinned.sort((a, b) => b.date.compareTo(a.date));
    if (limit != null && limit > 0) pinned = pinned.take(limit).toList();
    return pinned;
  }

  @override
  Future<void> incrementViews(String id) async {
    try {
      await _supabase.rpc(
        'increment_annonce_views',
        params: {'annonce_id': id},
      );
    } catch (e) {
      // Fallback update
      final res = await _supabase
          .from('annonces')
          .select('views_count')
          .eq('id', id)
          .maybeSingle();
      if (res != null) {
        final current = res['views_count'] as int? ?? 0;
        await _supabase
            .from('annonces')
            .update({'views_count': current + 1}).eq('id', id);
      }
    }
  }

  @override
  Future<void> likeAnnonce(String id, String userId) async {
    try {
      await _supabase.rpc(
        'like_annonce',
        params: {'annonce_id': id, 'user_id': userId},
      );
    } catch (e, stack) {
      AppLogger.e('Error fetching annonces', 'ANNONCE_REPO', e, stack);
    }
  }

  @override
  Future<void> unlikeAnnonce(String id, String userId) async {}

  @override
  Future<List<Commentaire>> getCommentaires(String annonceId) async {
    try {
      final List<dynamic> data = await _supabase
          .from('social_comments')
          .select()
          .eq('post_id', annonceId);

      return data.map((json) => Commentaire.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Commentaire> addCommentaire(Commentaire commentaire) async {
    try {
      final data = commentaire.toJson();
      final response = await _supabase
          .from('social_comments')
          .upsert(data)
          .select()
          .single();
      return Commentaire.fromJson(response);
    } catch (e) {
      return commentaire;
    }
  }

  @override
  Future<void> deleteCommentaire(String id) async {
    try {
      await _supabase.from('social_comments').delete().eq('id', id);
    } catch (e, stack) {
      AppLogger.e('Error syncing annonces', 'ANNONCE_REPO', e, stack);
    }
  }

  @override
  Future<void> likeCommentaire(String id, String userId) async {}
  @override
  Future<void> unlikeCommentaire(String id, String userId) async {}

  @override
  Stream<List<Annonce>> watchAnnonces({required String churchId}) async* {
    if (!_isar.isReady) {
      // Fallback pure realtime Supabase
      yield* _supabase
          .from('annonces')
          .stream(primaryKey: ['id'])
          .eq('church_id', churchId)
          .map((records) =>
              records.map((json) => Annonce.fromJson(json)).toList());
      return;
    }

    // START: Real-time Supabase to Isar Sync
    _supabase
        .from('annonces')
        .stream(primaryKey: ['id'])
        .eq('church_id', churchId)
        .listen((records) async {
          await _isar.db.writeTxn(() async {
            for (final record in records) {
              final annonce = Annonce.fromJson(record);
              final model = AnnonceModel.fromDomain(annonce)
                ..lastSyncedAt = DateTime.now();
              await _isar.saveAnnonce(model);
            }
          });
          _logger
              .i('Real-time sync: Updated ${records.length} annonces in Isar');
        });
    // END: Real-time Sync

    yield* _isar.db.annonceModels
        .filter()
        .churchIdEqualTo(churchId)
        .isDeletedEqualTo(false)
        .sortByDateDesc()
        .watch(fireImmediately: true)
        .map((models) => models.map((e) => e.toDomain()).toList());
  }

  Future<void> _saveAnnoncesToLocal(List<Annonce> annonces) async {
    if (!_isar.isReady) return;
    for (var a in annonces) {
      final model = AnnonceModel.fromDomain(a)..lastSyncedAt = DateTime.now();
      await _isar.saveAnnonce(model);
    }
  }
}