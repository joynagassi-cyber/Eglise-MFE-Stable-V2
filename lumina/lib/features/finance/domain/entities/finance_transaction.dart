// lib/features/finance/domain/entities/finance_transaction.dart
// Modèle Transaction Financière - Compatible IMAGIR

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lumina/features/finance/domain/entities/enums/transaction_type.dart';
import 'package:lumina/features/finance/domain/entities/enums/payment_method.dart';
import 'package:lumina/features/finance/domain/entities/enums/transaction_status.dart';

part 'finance_transaction.freezed.dart';
part 'finance_transaction.g.dart';

@freezed
class FinanceTransaction with _$FinanceTransaction {
  const FinanceTransaction._();

  const factory FinanceTransaction({
    required String id,
    required double amount,
    @Default('XAF') String currency,
    @Default(1.0) double exchangeRate,
    double? amountBaseCurrency,
    required TransactionType type,
    required DateTime date,
    required String description,
    String? category, // Ex: 'Dîme', 'Offrande', 'Loyer', 'Électricité'
    String? categoryId,
    required PaymentMethod paymentMethod,

    // Relations (IDs)
    String? accountId, // Compte débité/crédité
    String? relatedMemberId, // Membre lié (pour dîmes/dons)
    String? createdByUserId, // Utilisateur (Secrétaire/Trésorier) qui a saisi
    // Pour les transferts
    String? toAccountId,

    // Métadonnées
    String? referenceNumber, // N° Reçu
    String? notes,
    @Default([]) List<String> tags,
    @Default([]) List<Map<String, dynamic>> attachments,
    @Default([])
    List<String> proofImages, // URLs photos reçus/factures (legacy)
    // ==========================================
    // IMAGIR: Workflow & Compliance
    // ==========================================
    @Default(TransactionStatus.draft) TransactionStatus status,
    String? groupId,
    String? missionId,
    @Default([]) List<String> complianceTags,
    @Default(false) bool complianceChecked,

    // Validation & Approbation
    DateTime? validatedAt,
    String? validatedBy,
    String? approvedBy,
    DateTime? approvedAt,

    // Timestamps
    DateTime? createdAt,
    DateTime? updatedAt,

    // Audit Trail
    String? lastModifiedBy,
    DateTime? lastModifiedAt,
    String? lastModifiedByName,
    String? lastModifiedByRole,

    // Reconciliation
    @Default(false) bool isReconciled,
    DateTime? reconciledAt,
    String? reconciledBy,
  }) = _FinanceTransaction;

  factory FinanceTransaction.fromJson(Map<String, dynamic> json) =>
      _$FinanceTransactionFromJson(json);

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  /// Transaction validée et approuvée (IMAGIR)
  bool get isValidated =>
      status == TransactionStatus.validated || validatedAt != null;

  /// Transaction validée (alias pour compatibilité)
  bool get isFinalized =>
      status == TransactionStatus.validated ||
      status == TransactionStatus.sealed ||
      status == TransactionStatus.archived;

  /// Transaction en attente de validation
  bool get isPending => status == TransactionStatus.pending;

  /// A des tags de conformité nécessitant attention
  bool get hasComplianceIssues => complianceTags.isNotEmpty;

  /// Vérifie si la transaction peut encore être modifiée (limite de 30 jours)
  bool get canBeModified {
    final limitDate = DateTime.now().subtract(const Duration(days: 30));
    return date.isAfter(limitDate);
  }
}