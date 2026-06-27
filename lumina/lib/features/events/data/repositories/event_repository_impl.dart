import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/event_type.dart';
import '../../domain/repositories/i_event_repository.dart';
import '../models/event_model.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/utils/app_date_time.dart';
import '../../../../core/services/device_service.dart';
import '../../../../core/data/models/sync_item_model.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class EventRepositoryImpl implements IEventRepository {
  final SupabaseClient _client;
  final IsarService _isar;

  EventRepositoryImpl(this._client, this._isar);

  @override
  Future<List<Event>> getEvents({
    String? churchId,
    EventType? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (_isar.isReady) {
        final localModels = await _isar.getEvents();

        if (localModels.isNotEmpty) {
          var events = localModels.map((m) => m.toDomain()).toList();

          if (churchId != null) {
            events = events.where((e) => e.churchId == churchId).toList();
          }
          if (type != null) {
            events = events.where((e) => e.type == type).toList();
          }
          if (status != null) {
            events = events.where((e) => e.status == status).toList();
          }
          if (startDate != null) {
            events = events
                .where(
                  (e) =>
                      e.date.isAfter(startDate) ||
                      e.date.isAtSameMomentAs(startDate),
                )
                .toList();
          }
          if (endDate != null) {
            events = events
                .where(
                  (e) =>
                      e.date.isBefore(endDate) ||
                      e.date.isAtSameMomentAs(endDate),
                )
                .toList();
          }

          return events;
        }
      }

      var query = _client.from('events').select();
      if (churchId != null) {
        query = query.eq('church_id', churchId);
      }
      if (type != null) {
        query = query.eq('type', type.value);
      }
      if (status != null) {
        query = query.eq('status', status);
      }

      final records = await query.order('date', ascending: false);

      final events = records.map(_mapRecordToDomain).toList();
      if (_isar.isReady) {
        await _saveEventsToLocal(events);
      }

      return events;
    } catch (e) {
      if (_isar.isReady) {
        final localModels = await _isar.getEvents();
        if (localModels.isNotEmpty) {
          var events = localModels.map((m) => m.toDomain()).toList();

          if (churchId != null) {
            events = events.where((e) => e.churchId == churchId).toList();
          }
          if (type != null) {
            events = events.where((e) => e.type == type).toList();
          }
          if (status != null) {
            events = events.where((e) => e.status == status).toList();
          }

          return events;
        }
      }
      return [];
    }
  }

  @override
  Future<Event?> getEventById(String id) async {
    try {
      if (_isar.isReady) {
        final localModels = await _isar.getEvents();
        final localModel = localModels.cast<EventModel?>().firstWhere(
              (m) => m?.id == id,
              orElse: () => null,
            );

        if (localModel != null) {
          return localModel.toDomain();
        }
      }

      final record =
          await _client.from('events').select().eq('id', id).maybeSingle();
      if (record == null) return null;
      return _mapRecordToDomain(record);
    } catch (e) {
      if (_isar.isReady) {
        final localModels = await _isar.getEvents();
        final localModel = localModels.cast<EventModel?>().firstWhere(
              (m) => m?.id == id,
              orElse: () => null,
            );

        return localModel?.toDomain();
      }
      return null;
    }
  }

  @override
  Future<Event> createEvent(Event event) async {
    final deviceId = await DeviceService.getDeviceIdStatic();
    final userId = _client.auth.currentUser?.id ?? 'unknown';
    final uuid = event.id.isEmpty ? const Uuid().v4() : event.id;

    final newEvent = event.copyWith(
      id: uuid,
      createdAt: AppDateTime.nowUtc(),
      updatedAt: AppDateTime.nowUtc(),
    );

    final data = _eventToJson(newEvent);
    data['id'] = uuid;

    if (_isar.isReady) {
      final model = EventModel.fromDomain(newEvent)
        ..lastSyncedAt = null
        ..version = 1
        ..deviceId = deviceId
        ..createdBy = userId
        ..updatedBy = userId;

      await _isar.db.writeTxn(() async {
        await _isar.db.eventModels.put(model);
      });

      // PHASE 5: SyncOperationModel supprimé → SyncItemModel direct
      await _isar.queueSyncItem(SyncItemModel()
        ..tableName = 'events'
        ..action = 'INSERT'
        ..jsonData = jsonEncode(data)
        ..createdAt = DateTime.now()
        ..localId = uuid
        ..churchId = newEvent.churchId
        ..operationId = const Uuid().v4()
        ..deviceId = deviceId
        ..userId = userId);

      return newEvent;
    } else {
      await _client.from('events').insert(data);
      return newEvent;
    }
  }

  @override
  Future<Event> updateEvent(Event event) async {
    final deviceId = await DeviceService.getDeviceIdStatic();
    final userId = _client.auth.currentUser?.id ?? 'unknown';
    final updatedEvent = event.copyWith(updatedAt: AppDateTime.nowUtc());
    final data = _eventToJson(updatedEvent);

    if (_isar.isReady) {
      final localModel = await _isar.db.eventModels.filter().idEqualTo(updatedEvent.id).findFirst();
      final currentVersion = localModel?.version ?? 0;

      final model = EventModel.fromDomain(updatedEvent)
        ..isarId = localModel?.isarId ?? Isar.autoIncrement
        ..lastSyncedAt = null
        ..version = currentVersion + 1
        ..deviceId = deviceId
        ..createdBy = localModel?.createdBy ?? userId
        ..updatedBy = userId;

      await _isar.db.writeTxn(() async {
        await _isar.db.eventModels.put(model);
      });

      // PHASE 5: SyncOperationModel supprimé → SyncItemModel direct
      await _isar.queueSyncItem(SyncItemModel()
        ..tableName = 'events'
        ..action = 'UPDATE'
        ..jsonData = jsonEncode(data)
        ..createdAt = DateTime.now()
        ..localId = updatedEvent.id
        ..churchId = updatedEvent.churchId
        ..operationId = const Uuid().v4()
        ..deviceId = deviceId
        ..userId = userId);

      return updatedEvent;
    } else {
      await _client.from('events').update(data).eq('id', updatedEvent.id);
      return updatedEvent;
    }
  }

  @override
  Future<void> deleteEvent(String id, {required String churchId}) async {
    final deviceId = await DeviceService.getDeviceIdStatic();
    final userId = _client.auth.currentUser?.id ?? 'unknown';

    if (_isar.isReady) {
      final localModel = await _isar.db.eventModels.filter().idEqualTo(id).findFirst();
      
      if (localModel != null) {
        localModel
          ..isDeleted = true
          ..deletedAt = DateTime.now()
          ..deletedBy = userId
          ..updatedAt = DateTime.now()
          ..updatedBy = userId
          ..version = localModel.version + 1;

        await _isar.db.writeTxn(() async {
          await _isar.db.eventModels.put(localModel);
        });

        // PHASE 5: SyncOperationModel supprimé → SyncItemModel direct
        await _isar.queueSyncItem(SyncItemModel()
          ..tableName = 'events'
          ..action = 'DELETE'
          ..jsonData = jsonEncode({'id': id})
          ..createdAt = DateTime.now()
          ..localId = id
          ..churchId = churchId
          ..operationId = const Uuid().v4()
          ..deviceId = deviceId
          ..userId = userId);
      }
    } else {
      await _client.from('events').update({
        'is_deleted': true,
        'deleted_at': DateTime.now().toIso8601String(),
        'deleted_by': userId,
      }).eq('id', id);
    }
  }

  @override
  Future<void> registerMember(String eventId, String userId) async {
    final event = await getEventById(eventId);
    if (event == null) return;

    if (event.participantsIds.contains(userId)) return;

    final updatedParticipants = List<String>.from(event.participantsIds)..add(userId);
    final updatedEvent = event.copyWith(participantsIds: updatedParticipants);
    
    await updateEvent(updatedEvent);
  }

  @override
  Future<void> unregisterMember(String eventId, String userId) async {
    final event = await getEventById(eventId);
    if (event == null) return;

    if (!event.participantsIds.contains(userId)) return;

    final updatedParticipants = List<String>.from(event.participantsIds)..remove(userId);
    final updatedEvent = event.copyWith(participantsIds: updatedParticipants);
    
    await updateEvent(updatedEvent);
  }

  @override
  Future<List<Event>> searchEvents(String query) async {
    final allEvents = await getEvents();
    final lowerQuery = query.toLowerCase();

    return allEvents.where((e) {
      return e.title.toLowerCase().contains(lowerQuery) ||
          (e.description?.toLowerCase().contains(lowerQuery) ?? false) ||
          (e.location?.toLowerCase().contains(lowerQuery) ?? false) ||
          e.type.label.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  @override
  Future<List<Event>> getUpcomingEvents({String? churchId, int? limit}) async {
    final allEvents = await getEvents(churchId: churchId);
    final now = AppDateTime.nowUtc();

    var upcoming = allEvents.where((e) => e.date.isAfter(now)).toList();
    upcoming.sort((a, b) => a.date.compareTo(b.date));

    if (limit != null && limit > 0) {
      upcoming = upcoming.take(limit).toList();
    }

    return upcoming;
  }

  @override
  Future<List<Event>> getPastEvents({String? churchId, int? limit}) async {
    final allEvents = await getEvents(churchId: churchId);
    final now = AppDateTime.nowUtc();

    var past = allEvents.where((e) => e.date.isBefore(now)).toList();
    past.sort((a, b) => b.date.compareTo(a.date));

    if (limit != null && limit > 0) {
      past = past.take(limit).toList();
    }

    return past;
  }

  @override
  Stream<List<Event>> watchEvents({String? churchId}) async* {
    if (!_isar.isReady) {
      // Fallback pure realtime Supabase
      final streamBuilder = _client.from('events').stream(primaryKey: ['id']);
      final stream = churchId != null
          ? streamBuilder.eq('church_id', churchId)
          : streamBuilder;

      yield* stream.map((records) {
        final list = records.map(_mapRecordToDomain).toList();
        list.sort((a, b) => b.date.compareTo(a.date));
        return list;
      });
      return;
    }

    // START: Real-time Supabase to Isar Sync
    final streamBuilder = _client.from('events').stream(primaryKey: ['id']);
    final stream = churchId != null
        ? streamBuilder.eq('church_id', churchId)
        : streamBuilder;

    stream.listen((records) async {
      await _isar.db.writeTxn(() async {
        for (final record in records) {
          final event = _mapRecordToDomain(record);
          final model = EventModel.fromDomain(event);
          await _isar.saveEvent(model);
        }
      });
      AppLogger.d(
        'Real-time sync: Updated ${records.length} events in Isar',
        'EVENT_REPO',
      );
    });
    // END: Real-time Sync

    final query = _isar.db.eventModels.where();
    final filteredQuery =
        churchId != null ? query.filter().churchIdEqualTo(churchId) : query;

    yield* filteredQuery.watch(fireImmediately: true).map((models) {
      final sorted = models.toList()..sort((a, b) => b.date.compareTo(a.date));
      return sorted.map((e) => e.toDomain()).toList();
    });
  }

  Event _mapRecordToDomain(Map<String, dynamic> record) {
    final data = Map<String, dynamic>.from(record);
    data['createdAt'] = record['created_at'];
    data['updatedAt'] = record['updated_at'];

    if (data['type'] != null) {
      data['type'] = EventType.fromString(data['type']);
    }

    return Event.fromJson(data);
  }

  Map<String, dynamic> _eventToJson(Event event) {
    final json = event.toJson();
    json['type'] = event.type.value;
    return json;
  }

  Future<void> _saveEventsToLocal(List<Event> events) async {
    if (!_isar.isReady) return;
    for (var e in events) {
      final model = EventModel.fromDomain(e)
        ..lastSyncedAt = AppDateTime.nowUtc();
      await _isar.saveEvent(model);
    }
  }
}