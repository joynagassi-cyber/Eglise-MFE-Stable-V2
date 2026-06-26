import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/features/approvals/domain/repositories/i_approval_repository.dart';
import 'package:lumina/features/approvals/data/models/approval_request.dart';

class ApprovalRepository implements IApprovalRepository {
  final SupabaseClient _supabase;

  ApprovalRepository(this._supabase);

  @override
  Future<String?> createRequest({
    required String entityType,
    required String entityId,
    required String entityLabel,
    required double entityAmount,
    Map<String, dynamic>? entityData,
  }) async {
    final res = await _supabase.rpc(
      'create_approval_request',
      params: {
        'p_entity_type': entityType,
        'p_entity_id': entityId,
        'p_entity_label': entityLabel,
        'p_entity_amount': entityAmount,
        'p_entity_data': entityData ?? {},
      },
    );
    return res as String?;
  }

  @override
  Future<void> submitDecision({
    required String requestId,
    required String decision, // 'approved' | 'rejected'
    String? comment,
  }) async {
    await _supabase.rpc(
      'submit_approval_decision',
      params: {
        'p_request_id': requestId,
        'p_decision': decision,
        'p_comment': comment,
      },
    );
  }

  @override
  Future<List<ApprovalRequest>> getMyPendingApprovals() async {
    final List<dynamic> response = await _supabase.rpc(
      'get_my_pending_approvals',
    );
    // Note: RPC returns custom shape, might need specific DTO or manual map
    // For now assuming we map whatever fields match or use a specific model
    // This part depends on RPC return type.
    // Let's adjust model or RPC to match.
    // The RPC returns {request_id, entity_label...} which is a subset.
    // We'll map manually to a lightweight object or existing model with nulls.
    return response
        .map(
          (json) => ApprovalRequest(
            id: json['request_id'],
            entityType: json['entity_type'] ?? 'unknown',
            entityId: json['entity_id'] ?? 'unknown',
            entityLabel: json['entity_label'],
            entityAmount: (json['entity_amount'] as num?)?.toDouble(),
            status: json['status'] ?? 'pending',
            currentStepOrder: json['current_step_order'] ?? 0,
            totalSteps: json['total_steps'] ?? 0,
            requestedAt: DateTime.parse(json['requested_at']),
          ),
        )
        .toList();
  }
}