import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/finance_transaction.dart';
import '../../domain/entities/enums/transaction_type.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';

part 'transaction_history_provider.g.dart';

class TransactionFilters {
  final TransactionType? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? category;
  final String? searchQuery;

  const TransactionFilters({
    this.type,
    this.startDate,
    this.endDate,
    this.category,
    this.searchQuery,
  });
}

@riverpod
class TransactionHistory extends _$TransactionHistory {
  @override
  TransactionHistoryState build() {
    // Initial fetch
    Future.microtask(() => fetchNextPage());
    return const TransactionHistoryState();
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(financeRepositoryProvider);

      final result = await repository.searchTransactions(
        query: state.filters.searchQuery,
        startDate: state.filters.startDate,
        endDate: state.filters.endDate,
        type: state.filters.type,
        category: state.filters.category,
        page: state.page,
        perPage: 25,
      );

      result.fold(
        (failure) {
          state = state.copyWith(isLoading: false);
          // could throw here if we want to show error state
        },
        (newTransactions) {
          state = state.copyWith(
            transactions: [...state.transactions, ...newTransactions],
            isLoading: false,
            hasMore: newTransactions.length >= 25,
            page: state.page + 1,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> applyFilters(TransactionFilters filters) async {
    state = TransactionHistoryState(filters: filters);
    await fetchNextPage();
  }

  Future<void> refresh() async {
    state = TransactionHistoryState(filters: state.filters);
    await fetchNextPage();
  }
}

class TransactionHistoryState {
  final List<FinanceTransaction> transactions;
  final bool isLoading;
  final bool hasMore;
  final int page;
  final TransactionFilters filters;

  const TransactionHistoryState({
    this.transactions = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.page = 1,
    this.filters = const TransactionFilters(),
  });

  TransactionHistoryState copyWith({
    List<FinanceTransaction>? transactions,
    bool? isLoading,
    bool? hasMore,
    int? page,
    TransactionFilters? filters,
  }) {
    return TransactionHistoryState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      filters: filters ?? this.filters,
    );
  }
}

final totalTransactionStatsProvider =
    FutureProvider<TransactionStats>((ref) async {
  final repository = ref.watch(financeRepositoryProvider);

  final now = DateTime.now();
  final startOfYear = DateTime(now.year, 1, 1);
  final endOfYear = DateTime(now.year, 12, 31, 23, 59, 59);

  final incomeResult = await repository.getTotalIncome(startOfYear, endOfYear);
  final expenseResult =
      await repository.getTotalExpense(startOfYear, endOfYear);

  final income = incomeResult.fold((_) => 0.0, (val) => val);
  final expense = expenseResult.fold((_) => 0.0, (val) => val);

  return TransactionStats(
    totalIncome: income,
    totalExpense: expense,
    balance: income - expense,
  );
});

class TransactionStats {
  final double totalIncome;
  final double totalExpense;
  final double balance;

  const TransactionStats({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });
}
