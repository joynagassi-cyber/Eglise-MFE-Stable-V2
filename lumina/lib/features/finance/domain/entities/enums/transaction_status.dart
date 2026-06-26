// lib/features/finance/domain/entities/enums/transaction_status.dart

/// Statut du flux de validation d'une transaction financière (IMAGIR)
enum TransactionStatus {
  draft, // Brouillon - non soumis
  pending, // En attente de validation (DB: PENDING_VALIDATION)
  validated, // Validé par le responsable (DB: VALIDATED)
  rejected, // Rejeté
  sealed, // Scellé (DB: SEALED)
  archived; // Archivé

  String get label {
    switch (this) {
      case TransactionStatus.draft:
        return 'Brouillon';
      case TransactionStatus.pending:
        return 'En attente';
      case TransactionStatus.validated:
        return 'Validé';
      case TransactionStatus.rejected:
        return 'Rejeté';
      case TransactionStatus.sealed:
        return 'Scellé';
      case TransactionStatus.archived:
        return 'Archivé';
    }
  }


  /// Conversion depuis la valeur Supabase (String uppercase)
  static TransactionStatus fromSupabase(String? value) {
    if (value == null) return TransactionStatus.draft;
    switch (value.toUpperCase()) {
      case 'DRAFT':
        return TransactionStatus.draft;
      case 'PENDING_VALIDATION':
        return TransactionStatus.pending;
      case 'VALIDATED':
        return TransactionStatus.validated;
      case 'REJECTED':
        return TransactionStatus.rejected;
      case 'SEALED':
        return TransactionStatus.sealed;
      case 'ARCHIVED':
        return TransactionStatus.archived;
      default:
        return TransactionStatus.draft;
    }
  }

  /// Conversion vers la valeur Supabase (String uppercase)
  String toSupabase() {
    switch (this) {
      case TransactionStatus.draft:
        return 'DRAFT';
      case TransactionStatus.pending:
        return 'PENDING_VALIDATION';
      case TransactionStatus.validated:
        return 'VALIDATED';
      case TransactionStatus.rejected:
        return 'REJECTED';
      case TransactionStatus.sealed:
        return 'SEALED';
      case TransactionStatus.archived:
        return 'ARCHIVED';
    }
  }
}
