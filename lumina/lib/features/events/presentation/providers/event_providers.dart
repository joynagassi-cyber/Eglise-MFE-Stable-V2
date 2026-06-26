import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import '../../domain/entities/event.dart';
import 'package:lumina/features/churches/presentation/providers/church_providers.dart';
import '../../../../core/mixins/auditable_mixin.dart';
import '../../../../core/domain/entities/enums/audit_action.dart';
import 'dart:async';

final eventsProvider = StreamProvider<List<Event>>((ref) {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.watchEvents();
});

final allEventsProvider = StreamProvider<List<Event>>((ref) {
  return ref.watch(eventsProvider.stream);
});

final upcomingEventsProvider = FutureProvider<List<Event>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return await repository.getUpcomingEvents(limit: 10);
});

final pastEventsProvider = FutureProvider<List<Event>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return await repository.getPastEvents(limit: 10);
});

final eventSearchProvider = FutureProvider.family<List<Event>, String>((
  ref,
  query,
) async {
  final repository = ref.watch(eventRepositoryProvider);
  return await repository.searchEvents(query);
});

final eventByIdProvider = FutureProvider.family<Event?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(eventRepositoryProvider);
  return await repository.getEventById(id);
});

class EventNotifier extends AsyncNotifier<List<Event>> with AuditableMixin {
  @override
  Future<List<Event>> build() async {
    final repository = ref.read(eventRepositoryProvider);
    return await repository.getEvents();
  }

  Future<void> addEvent(Event event) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(eventRepositoryProvider);
      await repository.createEvent(event);

      // Audit Log: Create Event
      unawaited(logAuditAction(
        ref,
        action: AuditAction.insert,
        entityType: 'events',
        entityId: event.id,
        newData: event.toJson(),
      ));

      return await repository.getEvents();
    });
  }

  /// Alias pour la compatibilité avec les écrans
  Future<void> createEvent(Event event) => addEvent(event);

  Future<void> updateEvent(Event event) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(eventRepositoryProvider);
      await repository.updateEvent(event);

      // Audit Log: Update Event
      unawaited(logAuditAction(
        ref,
        action: AuditAction.update,
        entityType: 'events',
        entityId: event.id,
        newData: event.toJson(),
      ));

      return await repository.getEvents();
    });
  }

  Future<void> deleteEvent(String id) async {
    final church = ref.read(activeChurchProvider).valueOrNull;
    if (church == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(eventRepositoryProvider);
      await repository.deleteEvent(id, churchId: church.id);

      // Audit Log: Delete Event
      unawaited(logAuditAction(
        ref,
        action: AuditAction.delete,
        entityType: 'events',
        entityId: id,
      ));

      return await repository.getEvents();
    });
  }

  Future<void> registerMember(String eventId, String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(eventRepositoryProvider);
      await repository.registerMember(eventId, userId);
      return await repository.getEvents();
    });
  }

  Future<void> unregisterMember(String eventId, String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(eventRepositoryProvider);
      await repository.unregisterMember(eventId, userId);
      return await repository.getEvents();
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(eventRepositoryProvider);
      return await repository.getEvents();
    });
  }
}

final eventNotifierProvider = AsyncNotifierProvider<EventNotifier, List<Event>>(
  EventNotifier.new,
);

final eventActionsProvider = Provider<EventNotifier>((ref) {
  return ref.read(eventNotifierProvider.notifier);
});

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

enum EventFilter { all, upcoming, past }

final eventFilterProvider =
    StateProvider<EventFilter>((ref) => EventFilter.all);

final filteredEventsProvider = Provider<AsyncValue<List<Event>>>((ref) {
  final eventsAsync = ref.watch(allEventsProvider);
  final filter = ref.watch(eventFilterProvider);

  return eventsAsync.whenData((events) {
    switch (filter) {
      case EventFilter.upcoming:
        return events.where((e) => e.date.isAfter(DateTime.now())).toList();
      case EventFilter.past:
        return events.where((e) => e.date.isBefore(DateTime.now())).toList();
      case EventFilter.all:
        return events;
    }
  });
});
