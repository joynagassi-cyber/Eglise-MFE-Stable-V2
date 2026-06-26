import 'package:json_annotation/json_annotation.dart';
import 'event_type.dart';

class EventTypeConverter implements JsonConverter<EventType, String> {
  const EventTypeConverter();

  @override
  EventType fromJson(String json) => EventType.fromString(json);

  @override
  String toJson(EventType object) => object.value;
}