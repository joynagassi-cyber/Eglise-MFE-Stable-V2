import 'package:freezed_annotation/freezed_annotation.dart';

part 'approval_request.freezed.dart';
part 'approval_request.g.dart';

@freezed
class ApprovalRequest with _$ApprovalRequest {
  const factory ApprovalRequest({
    required String id,
    required String entityType,
    required String entityId,
    String? entityLabel,
    double? entityAmount,
    required String status, // pending, approved, etc.
    required int currentStepOrder,
    required int totalSteps,
    required DateTime requestedAt,
  }) = _ApprovalRequest;

  factory ApprovalRequest.fromJson(Map<String, dynamic> json) =>
      _$ApprovalRequestFromJson(json);
}