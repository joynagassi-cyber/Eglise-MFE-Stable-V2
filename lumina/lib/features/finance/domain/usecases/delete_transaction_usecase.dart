import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/i_finance_repository.dart';

class DeleteTransactionUseCase {
  final IFinanceRepository repository;

  DeleteTransactionUseCase(this.repository);

  Future<Either<Failure, void>> call(String transactionId) async {
    if (transactionId.isEmpty) {
      return const Left(ValidationFailure('Transaction ID cannot be empty'));
    }
    return repository.deleteTransaction(transactionId);
  }
}