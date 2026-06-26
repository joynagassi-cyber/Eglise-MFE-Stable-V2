enum TransactionStatus {
  draft,
  pending,
  validated,
  rejected,
  sealed,
  archived;

  // Transitions autorisées
  static const Map<TransactionStatus, List<TransactionStatus>> _transitions = {
    draft: [pending, rejected],
    pending: [validated, rejected],
    validated: [sealed],
    rejected: [draft], // retour brouillon
    sealed: [archived],
    archived: [], // terminal
  };

  bool canTransitionTo(TransactionStatus next) =>
      _transitions[this]?.contains(next) ?? false;

  // Depuis string DB
  static TransactionStatus fromString(String s) {
    switch (s.toUpperCase()) {
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

  // Vers string DB
  String get toDbValue {
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

  // Helpers UI
  bool get isEditable => this == draft || this == rejected;
  bool get isFinal => this == sealed || this == archived;
}
