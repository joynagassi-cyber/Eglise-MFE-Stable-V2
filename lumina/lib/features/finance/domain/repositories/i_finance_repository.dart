import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/finance_transaction.dart';
import '../entities/financial_account.dart';
import '../entities/enums/transaction_type.dart';
import '../entities/recurring_transaction.dart';

abstract class IFinanceRepository {
  // --- Transactions ---
  Future<Either<Failure, List<FinanceTransaction>>> getTransactions({
    bool forceRefresh = false,
    int? page,
    int? perPage,
  });
  Future<Either<Failure, List<FinanceTransaction>>> getAllTransactions();
  Stream<List<FinanceTransaction>> watchTransactions();
  Future<Either<Failure, void>> saveTransaction(FinanceTransaction transaction);
  Future<Either<Failure, void>> deleteTransaction(String id);
  Future<Either<Failure, List<FinanceTransaction>>> getTransactionsByAccount(
      String accountId);
  Future<Either<Failure, List<FinanceTransaction>>> getTransactionsByType(
      TransactionType type);
  Future<Either<Failure, List<Map<String, dynamic>>>> getApprovals(
      String transactionId);

  Future<Either<Failure, List<FinanceTransaction>>> searchTransactions({
    String? query,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    String? category,
    int? page,
    int? perPage,
  });

  // --- Reconciliation ---
  Future<Either<Failure, void>> reconcileTransaction({
    required String transactionId,
    required bool isReconciled,
    String? reconciledBy,
  });

  // --- Recurring Transactions ---
  Future<Either<Failure, List<RecurringTransaction>>> getRecurringTransactions({
    bool forceRefresh = false,
  });
  Stream<List<RecurringTransaction>> watchRecurringTransactions();
  Future<Either<Failure, void>> saveRecurringTransaction(
      RecurringTransaction recurring);
  Future<Either<Failure, void>> deleteRecurringTransaction(String id);

  // --- Accounts (Budgets/Comptes) ---
  Future<Either<Failure, List<FinancialAccount>>> getAccounts(
      {bool forceRefresh = false});
  Stream<List<FinancialAccount>> watchAccounts();
  Future<Either<Failure, void>> saveAccount(FinancialAccount account);
  Future<Either<Failure, void>> deleteAccount(String id);

  // --- Stats ---
  Future<Either<Failure, double>> getBalance(String accountId);
  Future<Either<Failure, double>> getTotalIncome(DateTime start, DateTime end);
  Future<Either<Failure, double>> getTotalExpense(DateTime start, DateTime end);

  // --- Reports & Views ---
  Future<Either<Failure, List<Map<String, dynamic>>>> getRegistreCulte();

  // --- RPC Calls ---
  Future<Either<Failure, void>> transferFunds({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
    String? note,
    required String churchId,
    required String createdBy,
  });
}