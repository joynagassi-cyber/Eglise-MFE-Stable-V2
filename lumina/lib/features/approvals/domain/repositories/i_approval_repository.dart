import '../../data/models/approval_request.dart';

abstract class IApprovalRepository {
  Future<String?> createRequest({
    required String entityType,
    required String entityId,
    required String entityLabel,
    required double entityAmount,
    Map<String, dynamic>? entityData,
  });

  Future<void> submitDecision({
    required String requestId,
    required String decision,
    String? comment,
  });

  Future<List<ApprovalRequest>> getMyPendingApprovals();
}