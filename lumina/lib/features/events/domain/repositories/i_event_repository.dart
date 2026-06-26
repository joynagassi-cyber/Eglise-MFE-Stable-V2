import '../../domain/entities/event.dart';
import '../../domain/entities/event_type.dart';

abstract class IEventRepository {
  Future<List<Event>> getEvents({
    String? churchId,
    EventType? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Event?> getEventById(String id);

  Future<Event> createEvent(Event event);

  Future<Event> updateEvent(Event event);

  Future<void> deleteEvent(String id, {required String churchId});

  Future<List<Event>> searchEvents(String query);

  Future<List<Event>> getUpcomingEvents({String? churchId, int? limit});

  Future<List<Event>> getPastEvents({String? churchId, int? limit});

  Future<void> registerMember(String eventId, String userId);
  Future<void> unregisterMember(String eventId, String userId);

  Stream<List<Event>> watchEvents({String? churchId});
}