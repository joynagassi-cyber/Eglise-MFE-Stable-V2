import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/sacrament.dart';
import '../../domain/entities/sacrament_type.dart';
import '../../domain/repositories/i_sacrament_repository.dart';
import '../models/sacrament_model.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/utils/app_date_time.dart';

class SacramentRepositoryImpl implements ISacramentRepository {
  final SupabaseClient _client;
  final IsarService _isar;

  SacramentRepositoryImpl(this._client, this._isar);

  @override
  Future<List<Sacrament>> getSacraments({
    String? churchId,
    SacramentType? type,
    String? memberId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (_isar.isReady) {
        final localModels = await _isar.getSacraments();

        if (localModels.isNotEmpty) {
          var sacraments = localModels.map((m) => m.toDomain()).toList();

          if (churchId != null) {
            sacraments =
                sacraments.where((s) => s.churchId == churchId).toList();
          }
          if (type != null) {
            sacraments = sacraments.where((s) => s.type == type).toList();
          }
          if (memberId != null) {
            sacraments =
                sacraments.where((s) => s.memberId == memberId).toList();
          }
          if (startDate != null) {
            sacraments = sacraments
                .where(
                  (s) =>
                      s.date.isAfter(startDate) ||
                      s.date.isAtSameMomentAs(startDate),
                )
                .toList();
          }
          if (endDate != null) {
            sacraments = sacraments
                .where(
                  (s) =>
                      s.date.isBefore(endDate) ||
                      s.date.isAtSameMomentAs(endDate),
                )
                .toList();
          }

          return sacraments;
        }
      }

      var query = _client.from('sacraments').select();

      if (churchId != null) {
        query = query.eq('church_id', churchId);
      }
      if (type != null) {
        query = query.eq('type', _typeToString(type));
      }
      if (memberId != null) {
        query = query.eq('member_id', memberId);
      }

      final records = await query.order('date', ascending: false);

      final sacraments = records.map(_mapRecordToDomain).toList();
      if (_isar.isReady) {
        await _saveSacramentsToLocal(sacraments);
      }

      return sacraments;
    } catch (e) {
      if (_isar.isReady) {
        final localModels = await _isar.getSacraments();
        if (localModels.isNotEmpty) {
          var sacraments = localModels.map((m) => m.toDomain()).toList();

          if (churchId != null) {
            sacraments =
                sacraments.where((s) => s.churchId == churchId).toList();
          }
          if (type != null) {
            sacraments = sacraments.where((s) => s.type == type).toList();
          }
          if (memberId != null) {
            sacraments =
                sacraments.where((s) => s.memberId == memberId).toList();
          }

          return sacraments;
        }
      }
      return [];
    }
  }

  @override
  Future<Sacrament?> getSacramentById(String id) async {
    try {
      if (_isar.isReady) {
        final localModels = await _isar.getSacraments();
        final localModel = localModels.cast<SacramentModel?>().firstWhere(
              (m) => m?.id == id,
              orElse: () => null,
            );

        if (localModel != null) {
          return localModel.toDomain();
        }
      }

      final record =
          await _client.from('sacraments').select().eq('id', id).maybeSingle();
      if (record == null) return null;
      return _mapRecordToDomain(record);
    } catch (e) {
      if (_isar.isReady) {
        final localModels = await _isar.getSacraments();
        final localModel = localModels.cast<SacramentModel?>().firstWhere(
              (m) => m?.id == id,
              orElse: () => null,
            );

        return localModel?.toDomain();
      }
      return null;
    }
  }

  @override
  Future<Sacrament> createSacrament(Sacrament sacrament) async {
    final model = SacramentModel.fromDomain(sacrament)
      ..lastSyncedAt = AppDateTime.nowUtc();

    if (_isar.isReady) {
      await _isar.saveSacrament(model);
    }

    try {
      final body = sacrament.toJson();
      body.remove('id');

      final record =
          await _client.from('sacraments').insert(body).select().single();
      final createdSacrament = _mapRecordToDomain(record);

      if (_isar.isReady) {
        final syncedModel = SacramentModel.fromDomain(createdSacrament)
          ..lastSyncedAt = AppDateTime.nowUtc();

        await _isar.saveSacrament(syncedModel);
      }

      return createdSacrament;
    } catch (e) {
      return sacrament;
    }
  }

  @override
  Future<Sacrament> updateSacrament(Sacrament sacrament) async {
    final model = SacramentModel.fromDomain(sacrament)
      ..lastSyncedAt = AppDateTime.nowUtc();

    if (_isar.isReady) {
      await _isar.saveSacrament(model);
    }

    try {
      final body = sacrament.toJson();
      body.remove('id');

      final record = await _client
          .from('sacraments')
          .update(body)
          .eq('id', sacrament.id)
          .select()
          .single();

      final updatedSacrament = _mapRecordToDomain(record);

      if (_isar.isReady) {
        final syncedModel = SacramentModel.fromDomain(updatedSacrament)
          ..lastSyncedAt = AppDateTime.nowUtc();

        await _isar.saveSacrament(syncedModel);
      }

      return updatedSacrament;
    } catch (e) {
      return sacrament;
    }
  }

  @override
  Future<void> deleteSacrament(String id) async {
    if (_isar.isReady) {
      final localSacraments = await _isar.getSacraments();
      final toDelete = localSacraments.firstWhere(
        (m) => m.id == id,
        orElse: () => SacramentModel()..id = 'not_found',
      );

      if (toDelete.id != 'not_found') {
        await _isar.deleteSacrament(toDelete.isarId);
      }
    }

    try {
      await _client.from('sacraments').delete().eq('id', id);
    } catch (e) {
      // Ignore network errors for offline-first
    }
  }

  @override
  Future<List<Sacrament>> searchSacraments(String query) async {
    if (_isar.isReady) {
      final models = await _isar.searchSacraments(query);
      return models.map((m) => m.toDomain()).toList();
    }

    try {
      final records =
          await _client.from('sacraments').select().ilike('notes', '%$query%');
      return records.map(_mapRecordToDomain).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Sacrament>> getMemberSacraments(String memberId) async {
    return await getSacraments(memberId: memberId);
  }

  @override
  Future<bool> hasSacrament(String memberId, SacramentType type) async {
    final sacraments = await getMemberSacraments(memberId);
    return sacraments.any((s) => s.type == type);
  }

  Sacrament _mapRecordToDomain(Map<String, dynamic> record) {
    final data = Map<String, dynamic>.from(record);
    data['createdAt'] = record['created_at'];
    data['updatedAt'] = record['updated_at'];

    if (data['type'] != null) {
      data['type'] = _stringToType(data['type']);
    }

    return Sacrament.fromJson(data);
  }

  Future<void> _saveSacramentsToLocal(List<Sacrament> sacraments) async {
    if (!_isar.isReady) return;
    for (var s in sacraments) {
      final model = SacramentModel.fromDomain(s)
        ..lastSyncedAt = AppDateTime.nowUtc();
      await _isar.saveSacrament(model);
    }
  }

  String _typeToString(SacramentType type) {
    return type.when(
      baptism: () => 'baptism',
      baptismHolySpirit: () => 'baptism_holy_spirit',
      marriage: () => 'marriage',
      confirmation: () => 'confirmation',
      firstCommunion: () => 'first_communion',
      anointing: () => 'anointing',
      penance: () => 'penance',
    );
  }

  SacramentType _stringToType(String typeId) {
    return SacramentTypeX.fromString(typeId);
  }
}