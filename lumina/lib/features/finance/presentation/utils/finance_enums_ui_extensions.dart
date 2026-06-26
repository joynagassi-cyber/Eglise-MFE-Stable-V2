import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';
import 'package:lumina/features/finance/domain/entities/enums/validation_status.dart';
import 'package:lumina/features/finance/domain/entities/enums/transaction_status.dart';
import 'package:lumina/features/finance/domain/entities/enums/transaction_type.dart';

extension ValidationStatusUIExtension on ValidationStatus {
  Color getColor(BuildContext context) {
    switch (this) {
      case ValidationStatus.pending:
        return context.colors.warningText;
      case ValidationStatus.validated:
        return context.colors.successText;
      case ValidationStatus.rejected:
        return context.colors.errorText;
    }
  }

  IconData get icon {
    switch (this) {
      case ValidationStatus.pending:
        return Icons.hourglass_empty;
      case ValidationStatus.validated:
        return Icons.verified;
      case ValidationStatus.rejected:
        return Icons.error_outline;
    }
  }
}

extension TransactionStatusUIExtension on TransactionStatus {
  Color getColor(BuildContext context) {
    switch (this) {
      case TransactionStatus.draft:
        return context.colors.textTertiary;
      case TransactionStatus.pending:
        return context.colors.warningText;
      case TransactionStatus.validated:
        return context.colors.successText;
      case TransactionStatus.rejected:
        return context.colors.errorText;
      case TransactionStatus.sealed:
        return context.colors.infoText;
      case TransactionStatus.archived:
        return context.colors.infoText;
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionStatus.draft:
        return Icons.edit_note;
      case TransactionStatus.pending:
        return Icons.hourglass_empty;
      case TransactionStatus.validated:
        return Icons.check_circle;
      case TransactionStatus.rejected:
        return Icons.cancel;
      case TransactionStatus.sealed:
        return Icons.lock;
      case TransactionStatus.archived:
        return Icons.archive;
    }
  }
}

extension TransactionTypeUIExtension on TransactionType {
  Color getColor(BuildContext context) {
    switch (this) {
      case TransactionType.income:
        return context.colors.successText;
      case TransactionType.expense:
        return context.colors.errorText;
      case TransactionType.transfer:
        return context.colors.infoText;
    }
  }
}
