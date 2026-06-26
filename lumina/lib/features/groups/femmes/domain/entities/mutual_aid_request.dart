import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutual_aid_request.freezed.dart';
part 'mutual_aid_request.g.dart';
// ignore_for_file: invalid_annotation_target

@freezed
class MutualAidRequest with _$MutualAidRequest {
  const factory MutualAidRequest({
    required String id,
    @JsonKey(name: 'church_id') required String churchId,
    @JsonKey(name: 'group_id') required String groupId,
    @JsonKey(name: 'requester_id') required String requesterId,
    required String type, // financial, material, emotional, practical
    String? description,
    @Default('active') String status, // active, fulfilled, closed
    @JsonKey(name: 'responses_count') @Default(0) int responsesCount,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _MutualAidRequest;

  factory MutualAidRequest.fromJson(Map<String, dynamic> json) =>
      _$MutualAidRequestFromJson(json);
}