import 'package:freezed_annotation/freezed_annotation.dart';
import 'event_type.dart';
import 'event_type_converter.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
class Event with _$Event {
  const Event._();

  const factory Event({
    required String id,
    required String churchId,
    @EventTypeConverter() required EventType type,
    required String title,
    String? description,
    required DateTime date,
    DateTime? endDate,
    String? location,
    String? managerId,
    String? officiantName,
    int? estimatedParticipants,
    int? actualParticipants,
    int? maxSeats,
    double? estimatedBudget,
    double? actualBudget,
    String? budgetAccountId,
    @Default([]) List<String> participantsIds,
    @Default('') String status,
    @Default('') String color,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  String get displayName => title;
  bool get isPast => DateTime.now().isAfter(date);
  bool get isUpcoming => DateTime.now().isBefore(date);
  bool get hasEnded => endDate != null && DateTime.now().isAfter(endDate!);
}