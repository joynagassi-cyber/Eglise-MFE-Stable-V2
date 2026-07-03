import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:isar/isar.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/utils/supabase_extensions.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/repositories/member_repository.dart';
import '../../domain/entities/member.dart';
import '../models/member_models.dart' hide Member;
import '../models/member_model.dart';
import '../../../../core/utils/app_date_time.dart';
import '../../../../core/data/models/sync_item_model.dart';
import '../../../../core/services/device_service.dart';

class SupabaseMemberRepository implements MemberRepository {
  final sb.SupabaseClient _client;
  final IsarService _isar;
  final Ref _ref;

  SupabaseMemberRepository(this._client, this._isar, this._ref);

  String get _churchId => _ref.read(activeChurchIdProvider);

  Failure _handleError(dynamic e, String defaultMessage) {
    if (e is sb.PostgrestException) {
      return ServerFailure(e.message, statusCode: int.tryParse(e.code ?? ''));
    }
    if (e is IsarError) {
      return CacheFailure('Erreur Isar : ${e.message}');
    }
    return UnexpectedFailure('$defaultMessage : ${e.toString()}');
  }

  @override
  Future<Either<Failure, List<Member>>> getMembers({
    int page = 1,
    int perPage = 50,
    String? search,
  }) async {
    // 1. Recherche par mot-clé
    if (search != null && search.isNotEmpty) {
      if (_isar.isReady) {
        try {
          final models = await _isar.searchMembers(_churchId, search);
          if (models.isNotEmpty) {
            return Right(models.map((m) {
              return Member.fromJson({
                'id': m.id,
                'church_id': m.churchId,
                'first_name': m.firstName,
                'last_name': m.lastName,
                'gender': m.gender.name,
                'status': m.status.name,
                'photo_url': m.photoUrl,
                'primary_role': m.primaryRole.name,
              });
            }).toList());
          }
        } catch (e) {
          AppLogger.w('Erreur recherche locale: $e', 'MEM_REPO');
        }
      }

      try {
        // Fallback Supabase Search
        var query =
            _client.from('members').select().scoped(_ref);
        query =
            query.or('first_name.ilike.%$search%,last_name.ilike.%$search%');
        final response = await query.order('last_name').limit(perPage);
        return Right(
            (response as List).map((e) => Member.fromJson(e)).toList());
      } catch (e) {
        return Left(_handleError(e, 'Recherche membres échouée'));
      }
    }

    // 2. Liste paginée standard
    if (perPage > 50) perPage = 50;

    try {
      final start = (page - 1) * perPage;
      final end = start + perPage - 1;

      final query =
          _client.from('members').select().scoped(_ref);
      final response = await query.order('last_name').range(start, end);
      final members =
          (response as List).map((e) => Member.fromJson(e)).toList();

      //  Mise à jour silencieuse du cache Isar
      if (_isar.isReady) {
        unawaited(_isar.db.writeTxn(() async {
          for (final member in members) {
            await _isar.db.memberModels.put(MemberModel.fromDomain(member));
          }
        }));
      }

      return Right(members);
    } catch (e) {
      return Left(_handleError(e, 'Récupération membres échouée'));
    }
  }

  @override
  Future<Either<Failure, Member>> getMemberById(String id) async {
    try {
      // 1. Essayer Isar d'abord (Local-First)
      if (_isar.isReady) {
        final localMember =
            await _isar.db.memberModels.filter().idEqualTo(id).findFirst();
        if (localMember != null && localMember.jsonData != null) {
          return Right(Member.fromJson(jsonDecode(localMember.jsonData!)));
        }
      }

      // 2. Fallback Supabase
      final response = await _client
          .from('members').select().scoped(_ref).eq('id', id).single();

      final member = Member.fromJson(response);

      // Mettre à jour Isar en arrière-plan si prêt
      if (_isar.isReady) {
        unawaited(_isar.saveMember(
            MemberModel.fromDomain(member)..jsonData = jsonEncode(response)));
      }

      return Right(member);
    } catch (e) {
      return Left(_handleError(e, 'Membre introuvable (ID: $id)'));
    }
  }

  @override
  Future<Either<Failure, Member>> getMemberByUserId(String userId) async {
    try {
      // 1. Essayer Isar d'abord
      if (_isar.isReady) {
        final localMember = await _isar.db.memberModels
            .filter()
            .userIdEqualTo(userId)
            .findFirst();
        if (localMember != null && localMember.jsonData != null) {
          return Right(Member.fromJson(jsonDecode(localMember.jsonData!)));
        }
      }

      // 2. Fallback Supabase
      final response = await _client
          .from('members').select().scoped(_ref).eq('user_id', userId).single();

      final member = Member.fromJson(response);

      // Mettre à jour Isar
      if (_isar.isReady) {
        unawaited(_isar.saveMember(
            MemberModel.fromDomain(member)..jsonData = jsonEncode(response)));
      }

      return Right(member);
    } catch (e) {
      return Left(_handleError(e, 'Membre introuvable pour userId: $userId'));
    }
  }

  @override
  Future<Either<Failure, void>> createMember(Member member) async {
    try {
      final uuid = const Uuid().v4();
      final newMember = member.copyWith(
        id: uuid,
        churchId: _churchId,
        createdAt: AppDateTime.nowUtc(),
        updatedAt: AppDateTime.nowUtc(),
      );

      final deviceId = await DeviceService.getDeviceIdStatic();
      final userId = _client.auth.currentUser?.id ?? 'unknown';

      if (_isar.isReady) {
        final model = MemberModel.fromDomain(newMember)
          ..jsonData = jsonEncode(newMember.toJson())
          ..isSynced = false
          ..version = 1
          ..deviceId = deviceId
          ..createdBy = userId
          ..updatedBy = userId;

        // PHASE 5: SyncOperationModel supprimé → SyncItemModel direct
        await _isar.db.writeTxn(() async {
          await _isar.db.memberModels.put(model);
        });
        await _isar.queueSyncItem(SyncItemModel()
          ..tableName = 'members'
          ..action = 'INSERT'
          ..jsonData = jsonEncode(newMember.toJson())
          ..createdAt = DateTime.now()
          ..localId = uuid
          ..churchId = _churchId
          ..operationId = const Uuid().v4()
          ..deviceId = deviceId
          ..userId = userId);
      } else {
        await _client.from('members').insert(newMember.toJson());
      }
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Échec création membre'));
    }
  }

  @override
  Future<Either<Failure, void>> updateMember(Member member) async {
    try {
      final updatedMember = member.copyWith(updatedAt: AppDateTime.nowUtc());
      final deviceId = await DeviceService.getDeviceIdStatic();
      final userId = _client.auth.currentUser?.id ?? 'unknown';

      if (_isar.isReady) {
        final localModel = await _isar.db.memberModels.filter().idEqualTo(updatedMember.id).findFirst();
        final currentVersion = localModel?.version ?? 0;

        final model = MemberModel.fromDomain(updatedMember)
          ..isarId = localModel?.isarId ?? Isar.autoIncrement
          ..jsonData = jsonEncode(updatedMember.toJson())
          ..isSynced = false
          ..version = currentVersion + 1
          ..deviceId = deviceId
          ..createdBy = localModel?.createdBy ?? userId
          ..updatedBy = userId;

        // PHASE 5: SyncOperationModel supprimé → SyncItemModel direct
        await _isar.db.writeTxn(() async {
          await _isar.db.memberModels.put(model);
        });
        await _isar.queueSyncItem(SyncItemModel()
          ..tableName = 'members'
          ..action = 'UPDATE'
          ..jsonData = jsonEncode(updatedMember.toJson())
          ..createdAt = DateTime.now()
          ..localId = updatedMember.id
          ..churchId = _churchId
          ..operationId = const Uuid().v4()
          ..deviceId = deviceId
          ..userId = userId);
      } else {
        await _client
            .from('members')
            .update(updatedMember.toJson())
            .eq('id', updatedMember.id);
      }
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Échec mise à jour membre'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMember(String id) async {
    try {
      final deviceId = await DeviceService.getDeviceIdStatic();
      final userId = _client.auth.currentUser?.id ?? 'unknown';

      // 1. Suppression/Marquage local
      if (_isar.isReady) {
        final local =
            await _isar.db.memberModels.filter().idEqualTo(id).findFirst();
        
        if (local != null) {
          local
            ..isDeleted = true
            ..deletedAt = DateTime.now()
            ..deletedBy = userId
            ..updatedAt = DateTime.now()
            ..updatedBy = userId
            ..version = local.version + 1;

          // PHASE 5: SyncOperationModel supprimé → SyncItemModel direct
          await _isar.db.writeTxn(() async {
            await _isar.db.memberModels.put(local);
          });
          await _isar.queueSyncItem(SyncItemModel()
            ..tableName = 'members'
            ..action = 'DELETE'
            ..jsonData = jsonEncode({'id': id})
            ..createdAt = DateTime.now()
            ..localId = id
            ..churchId = local.churchId ?? _churchId
            ..operationId = const Uuid().v4()
            ..deviceId = deviceId
            ..userId = userId);
        }
      } else {
        await _client.from('members').update({
          'is_deleted': true,
          'deleted_at': DateTime.now().toIso8601String(),
          'deleted_by': userId,
        }).eq('id', id);
      }
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Échec suppression membre'));
    }
  }

  @override
  Stream<List<Member>> watchMembers() async* {

    if (!_isar.isReady) {
      final stream = (_churchId != 'global' && _churchId != '*')
          ? _client
              .from('members')
              .stream(primaryKey: ['id']).eq('church_id', _churchId)
          : _client.from('members').stream(primaryKey: ['id']);

      yield* stream.map((data) => data.map((e) => Member.fromJson(e)).toList());
      return;
    }

    // Synchronisation en temps réel Supabase -> Isar
    final supabaseStream = (_churchId != 'global' && _churchId != '*')
        ? _client
            .from('members')
            .stream(primaryKey: ['id']).eq('church_id', _churchId)
        : _client.from('members').stream(primaryKey: ['id']);

    supabaseStream.listen((records) async {
      if (records.isEmpty) return;
      
      await _isar.db.writeTxn(() async {
        for (final record in records) {
          final member = Member.fromJson(record);
          final model = MemberModel.fromDomain(member)
            ..jsonData = jsonEncode(member.toJson())
            ..isSynced = true;
          // FIX: Utilisation de putMemberRaw au lieu de saveMember pour éviter le deadlock (transaction imbriquée)
          await _isar.putMemberRaw(model);
        }
      });
      AppLogger.d(
        'Real-time sync: Updated ${records.length} members in Isar',
        'MEM_REPO',
      );
    });

    // On écoute Isar pour la réactivité (Offline-First)
    final query = _isar.db.memberModels.where();
    final filteredQuery = (_churchId != 'global' && _churchId != '*')
        ? query.filter().churchIdEqualTo(_churchId)
        : query;

    yield* filteredQuery.watch(fireImmediately: true).map((models) {
      return models.map((m) => m.toDomain()).toList().cast<Member>();
    });
  }

  @override
  Future<Either<Failure, String>> uploadMemberPhoto(
      String memberId, File photoFile) async {
    return const Left(UnexpectedFailure('Utiliser PhotoService directement'));
  }

  @override
  Future<Either<Failure, List<FamilyRelationship>>> getFamilyRelationships(
    String memberId,
  ) async {
    try {
      var query = _client.from('family_relationships').select();

      if (_churchId != 'global' && _churchId != '*') {
        query = query.eq('church_id', _churchId);
      }

      final response = await query
          .or('member_id.eq.$memberId,related_member_id.eq.$memberId');
      return Right((response as List)
          .map((e) => FamilyRelationship.fromJson(e))
          .toList());
    } catch (e) {
      return Left(_handleError(e, 'Échec récupération relations familiales'));
    }
  }

  @override
  Future<Either<Failure, void>> addFamilyRelationship(
      FamilyRelationship relationship) async {
    try {
      final data = relationship.toJson();
      data['church_id'] = _churchId;

      await _client.from('family_relationships').insert(data);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Échec ajout relation familiale'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFamilyRelationship(
      String relationshipId) async {
    try {
      var query = _client
          .from('family_relationships')
          .delete()
          .eq('id', relationshipId);

      if (_churchId != 'global' && _churchId != '*') {
        query = query.eq('church_id', _churchId);
      }

      await query;
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Échec suppression relation familiale'));
    }
  }

  @override
  Future<Either<Failure, SpiritualTracking?>> getSpiritualTracking(
      String memberId) async {
    try {
      var query =
          _client.from('spiritual_tracking').select().eq('member_id', memberId);

      if (_churchId != 'global' && _churchId != '*') {
        query = query.eq('church_id', _churchId);
      }

      final response = await query.maybeSingle();
      return Right(
          response != null ? SpiritualTracking.fromJson(response) : null);
    } catch (e) {
      return Left(_handleError(e, 'Échec récupération suivi spirituel'));
    }
  }

  @override
  Future<Either<Failure, void>> updateSpiritualTracking(
      SpiritualTracking tracking) async {
    try {
      final data = tracking.toJson();
      data['church_id'] = _churchId;

      await _client.from('spiritual_tracking').upsert(data);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Échec mise à jour suivi spirituel'));
    }
  }

  @override
  Future<Either<Failure, List<MemberHistory>>> getMemberHistory(
      String memberId) async {
    try {
      var query =
          _client.from('member_history').select().eq('member_id', memberId);

      if (_churchId != 'global' && _churchId != '*') {
        query = query.eq('church_id', _churchId);
      }

      final response = await query.order('event_date', ascending: false);
      return Right(
          (response as List).map((e) => MemberHistory.fromJson(e)).toList());
    } catch (e) {
      return Left(_handleError(e, 'Échec récupération historique membre'));
    }
  }

  @override
  Future<Either<Failure, List<Member>>> getMembersByGroup(
      String groupId) async {
    try {
      final response = await _client
          .from('members').select('*, group_memberships!inner(group_id)').scoped(_ref)
          .eq('group_memberships.group_id', groupId);

      return Right((response as List).map((e) => Member.fromJson(e)).toList());
    } catch (e) {
      return Left(_handleError(e, 'Échec récupération membres du groupe'));
    }
  }
}