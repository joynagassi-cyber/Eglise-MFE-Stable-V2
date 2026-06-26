// lib/features/finance/domain/services/validation_workflow_service.dart
import '../entities/finance_transaction.dart';
import '../entities/enums/transaction_status.dart';

/// Service de workflow de validation hiérarchique (IMAGIR)
/// Gère la chaîne d'approbation : Staff -> Trésorier -> Président
class ValidationWorkflowService {
  // Seuil à partir duquel l'approbation du Président est requise
  static const int presidentApprovalThreshold = 500000; // 500k FCFA

  /// Rôles autorisés à soumettre une transaction pour review
  static const List<String> submitRoles = ['secretary', 'accountant', 'staff'];

  /// Rôles autorisés à approuver une transaction
  static const List<String> approverRoles = ['treasurer', 'president', 'admin'];

  /// Vérifie si un utilisateur peut soumettre une transaction pour review
  bool canSubmitForReview(String userRole, FinanceTransaction transaction) {
    if (transaction.status != TransactionStatus.draft) return false;
    return submitRoles.contains(userRole.toLowerCase()) ||
        approverRoles.contains(userRole.toLowerCase());
  }

  /// Vérifie si un utilisateur peut approuver une transaction
  bool canApprove(String userRole, FinanceTransaction transaction) {
    if (transaction.status != TransactionStatus.pending) return false;

    final role = userRole.toLowerCase();

    // Le trésorier peut approuver les montants < 500k
    if (role == 'treasurer' &&
        transaction.amount < presidentApprovalThreshold) {
      return true;
    }

    // Le président peut tout approuver
    if (role == 'president' || role == 'admin') {
      return true;
    }

    return false;
  }

  /// Vérifie si un utilisateur peut rejeter une transaction
  bool canReject(String userRole, FinanceTransaction transaction) {
    return canApprove(userRole, transaction);
  }

  /// Détermine le prochain approbateur requis
  String? getNextApprover(FinanceTransaction transaction) {
    if (transaction.status != TransactionStatus.pending) return null;

    if (transaction.amount >= presidentApprovalThreshold) {
      return 'president';
    }
    return 'treasurer';
  }

  /// Génère les actions disponibles pour un utilisateur sur une transaction
  List<WorkflowAction> getAvailableActions(
    String userRole,
    FinanceTransaction transaction,
  ) {
    final actions = <WorkflowAction>[];

    if (canSubmitForReview(userRole, transaction)) {
      actions.add(WorkflowAction.submitForReview);
    }

    if (canApprove(userRole, transaction)) {
      actions.add(WorkflowAction.approve);
    }

    if (canReject(userRole, transaction)) {
      actions.add(WorkflowAction.reject);
    }

    // Le créateur peut toujours annuler un brouillon
    if (transaction.status == TransactionStatus.draft) {
      actions.add(WorkflowAction.delete);
    }

    return actions;
  }

  /// Valide une transition de statut
  bool isValidTransition(
    TransactionStatus from,
    TransactionStatus to,
    String userRole,
  ) {
    final validTransitions = {
      TransactionStatus.draft: [TransactionStatus.pending],
      TransactionStatus.pending: [
        TransactionStatus.validated,
        TransactionStatus.rejected,
      ],
      TransactionStatus.rejected: [
        TransactionStatus.draft, // Peut être réédité
      ],
      TransactionStatus.validated: [
        TransactionStatus.sealed,
        TransactionStatus.archived,
      ],
      TransactionStatus.sealed: [TransactionStatus.archived],
    };

    return validTransitions[from]?.contains(to) ?? false;
  }
}

/// Actions disponibles dans le workflow
enum WorkflowAction {
  submitForReview,
  approve,
  reject,
  delete,
  archive;

  String get label {
    switch (this) {
      case WorkflowAction.submitForReview:
        return 'Soumettre pour validation';
      case WorkflowAction.approve:
        return 'Approuver';
      case WorkflowAction.reject:
        return 'Rejeter';
      case WorkflowAction.delete:
        return 'Supprimer';
      case WorkflowAction.archive:
        return 'Archiver';
    }
  }
}