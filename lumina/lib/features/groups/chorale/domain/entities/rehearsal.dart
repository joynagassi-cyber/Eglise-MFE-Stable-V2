import 'package:freezed_annotation/freezed_annotation.dart';

part 'rehearsal.freezed.dart';
part 'rehearsal.g.dart';

@freezed
class Rehearsal with _$Rehearsal {
  const Rehearsal._();

  const factory Rehearsal({
    required String id,
    required DateTime date,
    String? location,
    String? description,
    required String groupId,
    required String churchId,
    String? eventId,
    @Default(0) int attendanceCount,
    DateTime? createdAt,
  }) = _Rehearsal;

  factory Rehearsal.fromJson(Map<String, dynamic> json) =>
      _$RehearsalFromJson(json);

  bool get isPast => DateTime.now().isAfter(date);
}