import 'package:freezed_annotation/freezed_annotation.dart';

part 'shepherd.freezed.dart';
part 'shepherd.g.dart';

@freezed
class Shepherd with _$Shepherd {
  const factory Shepherd({
    required String id,
    required String churchId,
    required String memberId,

    // Member details (denormalized for easy listing)
    String? firstName,
    String? lastName,
    String? photoUrl,
    @Default('DEBUTANT') String level, // DEBUTANT, CONFIRME, ANCIEN
    @Default([])
    List<String> specialties, // JEUNESSE, COUPLES, DELIVRANCE, etc.
    @Default([]) List<String> supervisedGroupIds,
    String? bio,
    DateTime? ordainedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Shepherd;

  factory Shepherd.fromJson(Map<String, dynamic> json) =>
      _$ShepherdFromJson(json);
}