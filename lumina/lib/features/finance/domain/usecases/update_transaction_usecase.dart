import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/finance_transaction.dart';
import '../repositories/i_finance_repository.dart';

class UpdateTransactionUseCase {
  final IFinanceRepository repository;

  UpdateTransactionUseCase(this.repository);

  Future<Either<Failure, void>> call(FinanceTransaction transaction) async {
    if (transaction.amount <= 0) {
      return const Left(ValidationFailure('Amount must be greater than 0'));
    }
    return repository.saveTransaction(transaction);
  }
}