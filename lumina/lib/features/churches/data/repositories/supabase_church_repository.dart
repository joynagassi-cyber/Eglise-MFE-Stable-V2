import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:isar/isar.dart';

import '../../domain/entities/church.dart';
import '../../domain/entities/federation.dart';
import '../../domain/repositories/church_repository.dart';
import '../../../../core/data/local/isar_service.dart';

import '../models/church_model.dart';
import '../models/federation_model.dart';
import '../../../../core/utils/app_date_time.dart';
import '../../../../core/services/device_service.dart';
import '../../../../core/data/models/sync_item_model.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

/// Implémentation du repository d'églises avec Supabase + Isar
///
/// Stratégie offline-first :
/// - Lecture : Isar en priorité
/// - Écriture : Supabase + mise à jour Isar
/// - Sync : Bidirectionnel Supabase ↔ Isar
class SupabaseChurchRepository implements ChurchRepository {
  final SupabaseClient _client;
  final IsarService _isarService;

  SupabaseChurchRepository(
      {required SupabaseClient client, required IsarService isar})
      : _client = client,
        _isarService = isar;

  Isar get _isar => _isarService.db;

  static const String _churchTable = 'churches';
  static const String _federationTable = 'federations';
  static const String _userChurchTable = 'user_churches';

  // ==================== CRUD Églises ====================

  @override
  Future<Church?> getChurchById(String id) async {
    // Chercher dans Isar
    if (_isarService.isReady) {
      final model = await _isar.churchModels.filter().idEqualTo(id).findFirst();

      if (model != null) {
        return model.toDomain();
      }
    }

    // Sinon, chercher dans Supabase
    try {
      final record =
          await _client.from(_churchTable).select().eq('id', id).maybeSingle();
      if (record == null) return null;
      final churchModel = _mapSupabaseToModel(record);

      // Sauvegarder dans Isar
      if (_isarService.isReady) {
        await _isar.writeTxn(() async {
          await _isar.churchModels.put(churchModel);
        });
      }

      return churchModel.toDomain();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Church>> getAllChurches() async {
    // Lire depuis Isar
    if (_isarService.isReady) {
      final models = await _isar.churchModels.where().findAll();

      if (models.isNotEmpty) {
        return models.map((m) => m.toDomain()).toList();
      }
    }

    // Si aucune donnée locale, récupérer depuis Supabase
    try {
      final records = await _client.from(_churchTable).select();

      final churchModels = records.map(_mapSupabaseToModel).toList();

      if (_isarService.isReady) {
        await _isar.writeTxn(() async {
          await _isar.churchModels.putAll(churchModels);
        });
      }

      return churchModels.map((m) => m.toDomain()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Church>> getUserChurches(String userId) async {
    try {
      // Récupérer les IDs des églises de l'utilisateur depuis user_churches
      final records = await _client
          .from(_userChurchTable)
          .select('church_id')
          .eq('user_id', userId);

      final churchIds =
          records.map((r) => r['church_id'] as String).toSet().toList();

      if (churchIds.isEmpty) return [];

      // Récupérer les églises depuis Isar ou Supabase
      final churches = <Church>[];
      for (final churchId in churchIds) {
        final church = await getChurchById(churchId);
        if (church != null) churches.add(church);
      }

      return churches;
    } catch (e) {
      // En cas d'erreur, retourner les données locales
      if (_isarService.isReady) {
        final models = await _isar.churchModels.where().findAll();
        return models.map((m) => m.toDomain()).toList();
      }
      return [];
    }
  }

  @override
  Future<List<Church>> getChildChurches(String parentChurchId) async {
    // Chercher dans Isar
    if (_isarService.isReady) {
      final models = await _isar.churchModels
          .filter()
          .parentChurchIdEqualTo(parentChurchId)
          .findAll();

      if (models.isNotEmpty) {
        return models.map((m) => m.toDomain()).toList();
      }
    }

    // Sinon Supabase
    try {
      final records = await _client
          .from(_churchTable)
          .select()
          .eq('parent_church_id', parentChurchId);

      final churchModels = records.map(_mapSupabaseToModel).toList();

      if (_isarService.isReady) {
        await _isar.writeTxn(() async {
          await _isar.churchModels.putAll(churchModels);
        });
      }

      return churchModels.map((m) => m.toDomain()).toList();
    } catch (e) {
      if (_isarService.isReady) {
        final models = await _isar.churchModels
            .filter()
            .parentChurchIdEqualTo(parentChurchId)
            .findAll();
        return models.map((m) => m.toDomain()).toList();
      }
      return [];
    }
  }

  @override
  Future<List<Church>> getFederationChurches(String federationId) async {
    // Chercher dans Isar
    if (_isarService.isReady) {
      final models = await _isar.churchModels
          .filter()
          .federationIdEqualTo(federationId)
          .findAll();

      if (models.isNotEmpty) {
        return models.map((m) => m.toDomain()).toList();
      }
    }

    // Sinon Supabase
    try {
      final records = await _client
          .from(_churchTable)
          .select()
          .eq('federation_id', federationId);

      final churchModels = records.map(_mapSupabaseToModel).toList();

      if (_isarService.isReady) {
        await _isar.writeTxn(() async {
          await _isar.churchModels.putAll(churchModels);
        });
      }

      return churchModels.map((m) => m.toDomain()).toList();
    } catch (e) {
      if (_isarService.isReady) {
        final models = await _isar.churchModels
            .filter()
            .federationIdEqualTo(federationId)
            .findAll();
        return models.map((m) => m.toDomain()).toList();
      }
      return [];
    }
  }

  @override
  Future<Church> createChurch(Church church) async {
    try {
      final deviceId = await DeviceService.getDeviceIdStatic();
      final userId = _client.auth.currentUser?.id ?? 'unknown';
      final uuid = church.id.isEmpty ? const Uuid().v4() : church.id;
      
      final newChurch = church.copyWith(
        id: uuid,
        createdAt: AppDateTime.nowUtc(),
        updatedAt: AppDateTime.nowUtc(),
      );

      final data = _mapDomainToSupabase(newChurch);
      data['id'] = uuid; // Ensure UUID is passed
      
      if (_isarService.isReady) {
        final churchModel = ChurchModel.fromDomain(newChurch)
          ..isSynced = false
          ..version = 1
          ..deviceId = deviceId
          ..createdBy = userId
          ..updatedBy = userId;

        await _isar.writeTxn(() async {
          await _isar.churchModels.put(churchModel);
        });

        // PHASE 5: SyncOperationModel supprimé → SyncItemModel direct
        await _isar.queueSyncItem(SyncItemModel()
          ..tableName = 'churches'
          ..action = 'INSERT'
          ..jsonData = jsonEncode(data)
          ..createdAt = DateTime.now()
          ..localId = uuid
          ..churchId = uuid
          ..operationId = const Uuid().v4()
          ..deviceId = deviceId
          ..userId = userId);

        return churchModel.toDomain();
      } else {
        final record =
            await _client.from(_churchTable).insert(data).select().single();
        return _mapSupabaseToModel(record).toDomain();
      }
    } catch (e) {
      return church;
    }
  }

  @override
  Future<Church> updateChurch(Church church) async {
    try {
      final updatedChurch = church.copyWith(updatedAt: AppDateTime.nowUtc());
      final data = _mapDomainToSupabase(updatedChurch);
      final deviceId = await DeviceService.getDeviceIdStatic();
      final userId = _client.auth.currentUser?.id ?? 'unknown';

      if (_isarService.isReady) {
        final localModel = await _isar.churchModels.filter().idEqualTo(updatedChurch.id).findFirst();
        final currentVersion = localModel?.version ?? 0;

        final churchModel = ChurchModel.fromDomain(updatedChurch)
          ..isarId = localModel?.isarId ?? Isar.autoIncrement
          ..isSynced = false
          ..version = currentVersion + 1
          ..deviceId = deviceId
          ..createdBy = localModel?.createdBy ?? userId
          ..updatedBy = userId;

        await _isar.writeTxn(() async {
          await _isar.churchModels.put(churchModel);
        });

        // PHASE 5: SyncOperationModel supprimé → SyncItemModel direct
        await _isar.queueSyncItem(SyncItemModel()
          ..tableName = 'churches'
          ..action = 'UPDATE'
          ..jsonData = jsonEncode(data)
          ..createdAt = DateTime.now()
          ..localId = updatedChurch.id
          ..churchId = updatedChurch.id
          ..operationId = const Uuid().v4()
          ..deviceId = deviceId
          ..userId = userId);

        return churchModel.toDomain();
      } else {
        final record = await _client
            .from(_churchTable)
            .update(data)
            .eq('id', updatedChurch.id)
            .select()
            .single();
        return _mapSupabaseToModel(record).toDomain();
      }
    } catch (e) {
      return church;
    }
  }

  @override
  Future<void> deleteChurch(String id) async {
    try {
      final deviceId = await DeviceService.getDeviceIdStatic();
      final userId = _client.auth.currentUser?.id ?? 'unknown';

      if (_isarService.isReady) {
        final local = await _isar.churchModels.filter().idEqualTo(id).findFirst();
        
        if (local != null) {
          local
            ..isDeleted = true
            ..deletedAt = DateTime.now()
            ..deletedBy = userId
            ..updatedAt = DateTime.now()
            ..updatedBy = userId
            ..version = local.version + 1;

          await _isar.writeTxn(() async {
            await _isar.churchModels.put(local);
          });

          // PHASE 5: SyncOperationModel supprimé → SyncItemModel direct
          await _isar.queueSyncItem(SyncItemModel()
            ..tableName = 'churches'
            ..action = 'DELETE'
            ..jsonData = jsonEncode({'id': id})
            ..createdAt = DateTime.now()
            ..localId = id
            ..churchId = id
            ..operationId = const Uuid().v4()
            ..deviceId = deviceId
            ..userId = userId);
        }
      } else {
        await _client.from(_churchTable).update({
          'is_deleted': true,
          'deleted_at': DateTime.now().toIso8601String(),
          'deleted_by': userId,
        }).eq('id', id);
      }
    } catch (e) {
      rethrow;
    }
  }

  // ==================== CRUD Fédérations ====================

  @override
  Future<Federation?> getFederationById(String id) async {
    // Chercher dans Isar
    if (_isarService.isReady) {
      final model =
          await _isar.federationModels.filter().idEqualTo(id).findFirst();

      if (model != null) {
        return model.toDomain();
      }
    }

    // Sinon Supabase
    try {
      final record = await _client
          .from(_federationTable)
          .select()
          .eq('id', id)
          .maybeSingle();
      if (record == null) return null;
      final federationModel = _mapSupabaseToFederationModel(record);

      if (_isarService.isReady) {
        await _isar.writeTxn(() async {
          await _isar.federationModels.put(federationModel);
        });
      }

      return federationModel.toDomain();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Federation>> getAllFederations() async {
    // Lire depuis Isar
    if (_isarService.isReady) {
      final models = await _isar.federationModels.where().findAll();

      if (models.isNotEmpty) {
        return models.map((m) => m.toDomain()).toList();
      }
    }

    // Sinon Supabase
    try {
      final records = await _client.from(_federationTable).select();

      final federationModels =
          records.map(_mapSupabaseToFederationModel).toList();

      if (_isarService.isReady) {
        await _isar.writeTxn(() async {
          await _isar.federationModels.putAll(federationModels);
        });
      }

      return federationModels.map((m) => m.toDomain()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Federation> createFederation(Federation federation) async {
    try {
      final data = _mapFederationDomainToSupabase(federation);
      final record =
          await _client.from(_federationTable).insert(data).select().single();

      final federationModel = _mapSupabaseToFederationModel(record);

      if (_isarService.isReady) {
        await _isar.writeTxn(() async {
          await _isar.federationModels.put(federationModel);
        });
      }

      return federationModel.toDomain();
    } catch (e) {
      if (_isarService.isReady) {
        final federationModel = FederationModel.fromDomain(federation)
          ..isSynced = false;

        await _isar.writeTxn(() async {
          await _isar.federationModels.put(federationModel);
        });
      }

      return federation;
    }
  }

  @override
  Future<Federation> updateFederation(Federation federation) async {
    try {
      final data = _mapFederationDomainToSupabase(federation);
      final record = await _client
          .from(_federationTable)
          .update(data)
          .eq('id', federation.id)
          .select()
          .single();

      final federationModel = _mapSupabaseToFederationModel(record);

      if (_isarService.isReady) {
        await _isar.writeTxn(() async {
          await _isar.federationModels.put(federationModel);
        });
      }

      return federationModel.toDomain();
    } catch (e) {
      if (_isarService.isReady) {
        final federationModel = FederationModel.fromDomain(federation)
          ..isSynced = false;

        await _isar.writeTxn(() async {
          await _isar.federationModels.put(federationModel);
        });
      }

      return federation;
    }
  }

  @override
  Future<void> deleteFederation(String id) async {
    try {
      await _client.from(_federationTable).delete().eq('id', id);

      if (_isarService.isReady) {
        await _isar.writeTxn(() async {
          await _isar.federationModels.filter().idEqualTo(id).deleteFirst();
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addChurchToFederation(
    String churchId,
    String federationId,
  ) async {
    final federation = await getFederationById(federationId);
    if (federation == null) throw Exception('Fédération introuvable');

    final updatedFederation = federation.copyWith(
      memberChurchIds: [...federation.memberChurchIds, churchId],
      updatedAt: AppDateTime.nowUtc(),
    );

    await updateFederation(updatedFederation);

    // Mettre à jour l'église également
    final church = await getChurchById(churchId);
    if (church != null) {
      final updatedChurch = church.copyWith(
        federationId: federationId,
        updatedAt: AppDateTime.nowUtc(),
      );
      await updateChurch(updatedChurch);
    }
  }

  @override
  Future<void> removeChurchFromFederation(
    String churchId,
    String federationId,
  ) async {
    final federation = await getFederationById(federationId);
    if (federation == null) return;

    final updatedFederation = federation.copyWith(
      memberChurchIds:
          federation.memberChurchIds.where((id) => id != churchId).toList(),
      updatedAt: AppDateTime.nowUtc(),
    );

    await updateFederation(updatedFederation);

    // Retirer la fédération de l'église
    final church = await getChurchById(churchId);
    if (church != null && church.federationId == federationId) {
      final updatedChurch = church.copyWith(
        federationId: null,
        updatedAt: AppDateTime.nowUtc(),
      );
      await updateChurch(updatedChurch);
    }
  }

  // ==================== Synchronisation ====================

  @override
  Future<void> syncChurches() async {
    final records = await _client.from(_churchTable).select();
    final churchModels = records.map(_mapSupabaseToModel).toList();

    if (_isarService.isReady) {
      await _isar.writeTxn(() async {
        await _isar.churchModels.clear();
        await _isar.churchModels.putAll(churchModels);
      });
    }
  }

  @override
  Future<void> syncFederations() async {
    final records = await _client.from(_federationTable).select();
    final federationModels =
        records.map(_mapSupabaseToFederationModel).toList();

    if (_isarService.isReady) {
      await _isar.writeTxn(() async {
        await _isar.federationModels.clear();
        await _isar.federationModels.putAll(federationModels);
      });
    }
  }

  // ==================== Streams Temps Réel ====================

  @override
  Stream<Church?> watchChurch(String id) async* {
    if (!_isarService.isReady) {
      yield* _client
          .from(_churchTable)
          .stream(primaryKey: ['id'])
          .eq('id', id)
          .map((data) {
            if (data.isEmpty) return null;
            return _mapSupabaseToModel(data.first).toDomain();
          });
      return;
    }

    yield* _isar.churchModels
        .filter()
        .idEqualTo(id)
        .watch(fireImmediately: true)
        .map((models) => models.isEmpty ? null : models.first.toDomain());
  }

  @override
  Stream<List<Church>> watchUserChurches(String userId) async* {
    if (!_isarService.isReady) {
      yield await getUserChurches(userId);
      // Pour le stream temps réel des many-to-many,
      // il faudrait écouter `user_churches` sur web via Supabase, complèxe pour l'instant.
      // On se contente d'un snapshot.
      return;
    }
    final churches = await getUserChurches(userId);
    yield churches;

    await for (final _ in _isar.churchModels.watchLazy()) {
      final updated = await getUserChurches(userId);
      yield updated;
    }
  }

  @override
  Stream<List<Church>> watchAllChurches() async* {
    if (!_isarService.isReady) {
      yield* _client.from(_churchTable).stream(primaryKey: ['id']).map((data) =>
          data.map((json) => _mapSupabaseToModel(json).toDomain()).toList());
      return;
    }

    yield* _isar.churchModels
        .where()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toDomain()).toList());
  }

  @override
  Stream<Federation?> watchFederation(String id) async* {
    if (!_isarService.isReady) {
      yield* _client
          .from(_federationTable)
          .stream(primaryKey: ['id'])
          .eq('id', id)
          .map((data) {
            if (data.isEmpty) return null;
            return _mapSupabaseToFederationModel(data.first).toDomain();
          });
      return;
    }

    yield* _isar.federationModels
        .filter()
        .idEqualTo(id)
        .watch(fireImmediately: true)
        .map((models) => models.isEmpty ? null : models.first.toDomain());
  }

  // ==================== Recherche & Filtres ====================

  @override
  Future<List<Church>> searchChurches(String query) async {
    if (_isarService.isReady) {
      final models = await _isar.churchModels
          .filter()
          .nameContains(query, caseSensitive: false)
          .findAll();

      return models.map((m) => m.toDomain()).toList();
    }

    try {
      final records =
          await _client.from(_churchTable).select().ilike('name', '%$query%');
      return records.map(_mapSupabaseToModel).map((m) => m.toDomain()).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<Church>> getChurchesByType(ChurchType type) async {
    if (_isarService.isReady) {
      final models =
          await _isar.churchModels.filter().typeEqualTo(type).findAll();

      return models.map((m) => m.toDomain()).toList();
    }
    try {
      final records =
          await _client.from(_churchTable).select().eq('type', type.name);
      return records.map(_mapSupabaseToModel).map((m) => m.toDomain()).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<Church>> getChurchesByCity(String city) async {
    if (_isarService.isReady) {
      final models =
          await _isar.churchModels.filter().cityEqualTo(city).findAll();

      return models.map((m) => m.toDomain()).toList();
    }

    try {
      final records =
          await _client.from(_churchTable).select().eq('city', city);
      return records.map(_mapSupabaseToModel).map((m) => m.toDomain()).toList();
    } catch (_) {
      return [];
    }
  }

  // ==================== Statistiques ====================

  @override
  Future<int> getTotalMemberCount() async {
    final churches = await getAllChurches();
    return churches.fold<int>(0, (sum, church) => sum + church.memberCount);
  }

  @override
  Future<Map<String, dynamic>> getChurchStats(String churchId) async {
    final church = await getChurchById(churchId);
    if (church == null) return {};

    final childChurches = await getChildChurches(churchId);
    final totalChildMembers = childChurches.fold<int>(
      0,
      (sum, child) => sum + child.memberCount,
    );

    return {
      'church_id': churchId,
      'member_count': church.memberCount,
      'child_churches_count': childChurches.length,
      'total_child_members': totalChildMembers,
      'total_members': church.memberCount + totalChildMembers,
      'has_federation': church.isInFederation,
      'church_type': church.type.name,
    };
  }

  // ==================== Mapping Helpers ====================

  ChurchModel _mapSupabaseToModel(Map<String, dynamic> record) {
    return ChurchModel()
      ..id = record['id'] as String
      ..name = record['name'] as String
      ..type = ChurchType.values.byName(record['type'] as String)
      ..description = record['description'] as String?
      ..address = record['address'] as String?
      ..city = record['city'] as String?
      ..postalCode = record['postal_code'] as String?
      ..country = record['country'] as String? ?? 'RDC'
      ..phone = record['phone'] as String?
      ..email = record['email'] as String?
      ..website = record['website'] as String?
      ..parentChurchId = record['parent_church_id'] as String?
      ..federationId = record['federation_id'] as String?
      ..memberCount = record['member_count'] as int? ?? 0
      ..foundedDate = record['founded_date'] != null
          ? DateTime.parse(record['founded_date'] as String)
          : null
      ..leadPastorId = record['lead_pastor_id'] as String?
      ..logoUrl = record['logo_url'] as String?
      ..coverImageUrl = record['cover_image_url'] as String?
      ..isSynced = true
      ..lastSyncedAt = AppDateTime.nowUtc()
      ..createdAt = DateTime.parse(record['created_at'] as String)
      ..updatedAt = record['updated_at'] != null
          ? DateTime.parse(record['updated_at'] as String)
          : null;
  }

  Map<String, dynamic> _mapDomainToSupabase(Church church) {
    return {
      'name': church.name,
      'type': church.type.name,
      'description': church.description,
      'address': church.address,
      'city': church.city,
      'postal_code': church.postalCode,
      'country': church.country,
      'phone': church.phone,
      'email': church.email ?? '',
      'website': church.website,
      'parent_church_id': church.parentChurchId,
      'federation_id': church.federationId,
      'member_count': church.memberCount,
      'founded_date': church.foundedDate?.toIso8601String(),
      'lead_pastor_id': church.leadPastorId,
      'logo_url': church.logoUrl,
      'cover_image_url': church.coverImageUrl,
    };
  }

  FederationModel _mapSupabaseToFederationModel(Map<String, dynamic> record) {
    return FederationModel()
      ..id = record['id'] as String
      ..name = record['name'] as String
      ..type = FederationType.values.byName(record['type'] as String)
      ..description = record['description'] as String?
      ..headquarters = record['headquarters'] as String?
      ..memberChurchIds = (record['member_church_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          []
      ..leadChurchId = record['lead_church_id'] as String?
      ..leaderId = record['leader_id'] as String?
      ..email = record['email'] as String?
      ..phone = record['phone'] as String?
      ..website = record['website'] as String?
      ..logoUrl = record['logo_url'] as String?
      ..totalMembers = record['total_members'] as int? ?? 0
      ..establishedDate = record['established_date'] != null
          ? DateTime.parse(record['established_date'] as String)
          : null
      ..isSynced = true
      ..lastSyncedAt = AppDateTime.nowUtc()
      ..createdAt = DateTime.parse(record['created_at'] as String)
      ..updatedAt = record['updated_at'] != null
          ? DateTime.parse(record['updated_at'] as String)
          : null;
  }

  Map<String, dynamic> _mapFederationDomainToSupabase(Federation federation) {
    return {
      'name': federation.name,
      'type': federation.type.name,
      'description': federation.description,
      'headquarters': federation.headquarters,
      'member_church_ids': federation.memberChurchIds,
      'lead_church_id': federation.leadChurchId,
      'leader_id': federation.leaderId,
      'email': federation.email ?? '',
      'phone': federation.phone,
      'website': federation.website,
      'logo_url': federation.logoUrl,
      'total_members': federation.totalMembers,
      'established_date': federation.establishedDate?.toIso8601String(),
    };
  }
}