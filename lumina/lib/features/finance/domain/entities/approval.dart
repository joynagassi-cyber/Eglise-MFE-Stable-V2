// lib/features/finance/domain/entities/approval.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'approval.freezed.dart';
part 'approval.g.dart';

/// Représente une approbation dans le workflow hiérarchique IMAGIR
/// Journal immuable des décisions d'approbation/rejet
@freezed
class Approval with _$Approval {
  const factory Approval({
    required String id,
    required String transactionId,
    required String approverId,
    required String roleUsed,
    required ApprovalDecision decision,
    String? approverName,
    String? comment,
    required DateTime decidedAt,
    required DateTime createdAt,
  }) = _Approval;

  factory Approval.fromJson(Map<String, dynamic> json) =>
      _$ApprovalFromJson(json);
}

/// Décision d'approbation
enum ApprovalDecision {
  approved,
  rejected;

  String get label {
    switch (this) {
      case ApprovalDecision.approved:
        return 'Approuvé';
      case ApprovalDecision.rejected:
        return 'Rejeté';
    }
  }

  String toSupabase() => name;

  static ApprovalDecision fromSupabase(String value) {
    return ApprovalDecision.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ApprovalDecision.rejected,
    );
  }
}