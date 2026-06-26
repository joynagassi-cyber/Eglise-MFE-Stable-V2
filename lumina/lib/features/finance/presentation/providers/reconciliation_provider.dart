import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/reconciliation_service.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';
import '../../domain/entities/finance_transaction.dart';
import '../../domain/entities/enums/payment_method.dart';
import '../../domain/entities/enums/transaction_status.dart';

class ReconciliationState {
  final List<ImportedTransaction> imported;
  final bool isLoading;
  final String? error;

  ReconciliationState({
    this.imported = const [],
    this.isLoading = false,
    this.error,
  });

  ReconciliationState copyWith({
    List<ImportedTransaction>? imported,
    bool? isLoading,
    String? error,
  }) {
    return ReconciliationState(
      imported: imported ?? this.imported,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ReconciliationNotifier extends StateNotifier<ReconciliationState> {
  final ReconciliationService _service;
  final Ref _ref;

  ReconciliationNotifier(this._service, this._ref)
      : super(ReconciliationState());

  void importCsv(String content) {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final transactions = _service.parseCsv(content);
      state = state.copyWith(imported: transactions, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Erreur lors de l\'importation: $e',
        isLoading: false,
      );
    }
  }

  Future<void> confirmImport(List<ImportedTransaction> transactions) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = _ref.read(financeRepositoryProvider);

      for (final imp in transactions) {
        if (imp.isMatched) continue;

        // Créer une nouvelle transaction à partir de l'import
        final transaction = FinanceTransaction(
          id: '', // Sera généré
          description: imp.description,
          amount: imp.amount,
          type: imp.type,
          date: imp.date,
          paymentMethod:
              PaymentMethod.bankTransfer, // Défaut pour import relevé
          status: TransactionStatus.validated,
          validatedAt: DateTime.now(),
        );

        await repository.saveTransaction(transaction);
      }

      state = state.copyWith(imported: [], isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Erreur lors de la confirmation: $e',
        isLoading: false,
      );
    }
  }
}

final reconciliationServiceProvider = Provider(
  (ref) => ReconciliationService(),
);

final reconciliationActionsProvider =
    StateNotifierProvider<ReconciliationNotifier, ReconciliationState>((ref) {
  final service = ref.watch(reconciliationServiceProvider);
  return ReconciliationNotifier(service, ref);
});
