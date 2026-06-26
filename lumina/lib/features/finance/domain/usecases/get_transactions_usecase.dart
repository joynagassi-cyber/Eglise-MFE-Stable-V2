import 'package:dartz/dartz.dart';
import 'package:lumina/core/error/failures.dart';
import 'package:lumina/features/finance/domain/entities/finance_transaction.dart';
import 'package:lumina/features/finance/domain/repositories/i_finance_repository.dart';

class GetTransactionsParams {
  final bool forceRefresh;

  const GetTransactionsParams({this.forceRefresh = false});
}

class GetTransactionsUseCase {
  final IFinanceRepository repository;

  GetTransactionsUseCase(this.repository);

  Future<Either<Failure, List<FinanceTransaction>>> call(
      GetTransactionsParams params) async {
    return repository.getTransactions(forceRefresh: params.forceRefresh);
  }
}