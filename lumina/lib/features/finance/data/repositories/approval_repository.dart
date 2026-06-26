// lib/features/finance/data/repositories/approval_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/approval.dart';
import '../../../../core/utils/app_date_time.dart';

/// Repository pour gérer les approbations IMAGIR
/// Append-only : les approbations ne peuvent pas être modifiées ou supprimées
class ApprovalRepository {
  final SupabaseClient _supabase;

  ApprovalRepository(this._supabase);

  /// Créer une nouvelle approbation
  Future<Approval> createApproval({
    required String transactionId,
    required String roleUsed,
    required ApprovalDecision decision,
    String? approverName,
    String? comment,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Utilisateur non authentifié');
    }

    final data = {
      'transaction_id': transactionId,
      'approver_id': userId,
      'approver_name': approverName,
      'role_used': roleUsed,
      'decision': decision.toSupabase(),
      'comment': comment,
      'decided_at': AppDateTime.nowIso(),
    };

    final response =
        await _supabase.from('approvals').insert(data).select().single();

    return _mapToApproval(response);
  }

  /// Récupérer les approbations d'une transaction
  Future<List<Approval>> getApprovalsForTransaction(
    String transactionId,
  ) async {
    final response = await _supabase
        .from('approvals')
        .select()
        .eq('transaction_id', transactionId)
        .order('decided_at', ascending: true);

    return (response as List).map((e) => _mapToApproval(e)).toList();
  }

  /// Récupérer les approbations faites par un utilisateur
  Future<List<Approval>> getApprovalsByUser(String userId) async {
    final response = await _supabase
        .from('approvals')
        .select()
        .eq('approver_id', userId)
        .order('decided_at', ascending: false)
        .limit(100);

    return (response as List).map((e) => _mapToApproval(e)).toList();
  }

  /// Vérifier si une transaction a été approuvée
  Future<bool> isTransactionApproved(String transactionId) async {
    final approvals = await getApprovalsForTransaction(transactionId);

    // Une transaction est approuvée si la dernière décision est 'approved'
    if (approvals.isEmpty) return false;
    return approvals.last.decision == ApprovalDecision.approved;
  }

  /// Compter les approbations en attente pour un rôle
  Future<int> getPendingCountForRole(String roleCode, String churchId) async {
    // Transactions pending_review sans approbation récente
    final response = await _supabase.rpc(
      'count_pending_approvals',
      params: {'p_role_code': roleCode, 'p_church_id': churchId},
    );

    return response as int? ?? 0;
  }

  Approval _mapToApproval(Map<String, dynamic> data) {
    return Approval(
      id: data['id'] as String,
      transactionId: data['transaction_id'] as String,
      approverId: data['approver_id'] as String,
      approverName: data['approver_name'] as String?,
      roleUsed: data['role_used'] as String,
      decision: ApprovalDecision.fromSupabase(data['decision'] as String),
      comment: data['comment'] as String?,
      decidedAt: DateTime.parse(data['decided_at'] as String),
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}