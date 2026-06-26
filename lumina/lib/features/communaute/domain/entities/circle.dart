import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle.freezed.dart';
part 'circle.g.dart';

@freezed
class Circle with _$Circle {
  const factory Circle({
    required String id,
    required String churchId,
    required String name,
    String? description,
    @Default('group') String iconName,
    @Default('#7C4DFF') String colorHex,
    @Default(0) int memberCount,
    @Default(false) bool isPrivate,
    @Default(true) bool isSynced,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Circle;

  factory Circle.fromJson(Map<String, dynamic> json) => _$CircleFromJson(json);
}

@freezed
class CircleMember with _$CircleMember {
  const factory CircleMember({
    required String circleId,
    required String memberId,
    @Default('member') String role,
    DateTime? joinedAt,
    // Denormalized fields for display
    String? memberName,
    String? memberPhotoUrl,
  }) = _CircleMember;

  factory CircleMember.fromJson(Map<String, dynamic> json) =>
      _$CircleMemberFromJson(json);
}