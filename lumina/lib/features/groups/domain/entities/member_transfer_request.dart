import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_transfer_request.freezed.dart';
part 'member_transfer_request.g.dart';
// ignore_for_file: invalid_annotation_target

enum TransferStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('APPROVED')
  approved,
  @JsonValue('REJECTED')
  rejected,
  @JsonValue('CANCELLED')
  cancelled,
}

@freezed
class MemberTransferRequest with _$MemberTransferRequest {
  const factory MemberTransferRequest({
    required String id,
    @JsonKey(name: 'church_id') required String churchId,
    @JsonKey(name: 'member_id') required String memberId,
    @JsonKey(name: 'from_group_id') required String fromGroupId,
    @JsonKey(name: 'to_group_id') String? toGroupId,
    @JsonKey(name: 'requester_id') required String requesterId,
    String? reason,
    @Default(TransferStatus.pending)
    @JsonKey(unknownEnumValue: TransferStatus.pending)
    TransferStatus status,
    String? notes,
    @JsonKey(name: 'approved_by') String? approvedBy,
    @JsonKey(name: 'approved_at') DateTime? approvedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _MemberTransferRequest;

  factory MemberTransferRequest.fromJson(Map<String, dynamic> json) =>
      _$MemberTransferRequestFromJson(json);
}