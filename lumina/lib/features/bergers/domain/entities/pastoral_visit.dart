import 'package:freezed_annotation/freezed_annotation.dart';

part 'pastoral_visit.freezed.dart';
part 'pastoral_visit.g.dart';

@freezed
class PastoralVisit with _$PastoralVisit {
  const factory PastoralVisit({
    required String id,
    required String churchId,
    required String shepherdId,
    required String memberId,
    required DateTime date,
    required String notes,
    @Default('NORMAL') String status, // NORMAL, URGENT, SUIVI
    DateTime? nextVisitDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PastoralVisit;

  factory PastoralVisit.fromJson(Map<String, dynamic> json) =>
      _$PastoralVisitFromJson(json);
}