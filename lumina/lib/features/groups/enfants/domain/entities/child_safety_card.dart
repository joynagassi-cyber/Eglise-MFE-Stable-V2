import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_safety_card.freezed.dart';
part 'child_safety_card.g.dart';
// ignore_for_file: invalid_annotation_target

@freezed
class ChildSafetyCard with _$ChildSafetyCard {
  const factory ChildSafetyCard({
    required String id,
    @JsonKey(name: 'church_id') required String churchId,
    required String memberId,
    @Default({}) Map<String, dynamic> medicalInfo,
    String? emergencyContact,
    @Default([]) List<String> allergies,
    String? bloodType,
    DateTime? lastCheckIn,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ChildSafetyCard;

  factory ChildSafetyCard.fromJson(Map<String, dynamic> json) =>
      _$ChildSafetyCardFromJson(json);
}