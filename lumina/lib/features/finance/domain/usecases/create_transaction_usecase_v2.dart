import 'package:dartz/dartz.dart';
import 'package:lumina/core/error/failures.dart';
import 'package:lumina/features/finance/domain/entities/finance_transaction.dart';
import 'package:lumina/features/finance/domain/repositories/i_finance_repository.dart';

class CreateTransactionUseCase {
  final IFinanceRepository repository;

  CreateTransactionUseCase(this.repository);

  Future<Either<Failure, void>> call(FinanceTransaction transaction) async {
    if (transaction.amount <= 0) {
      return const Left(ValidationFailure('Amount must be greater than 0'));
    }

    try {
      return await repository.saveTransaction(transaction);
    } catch (e) {
      return Left(ServerFailure('Failed to create transaction: $e'));
    }
  }
}