// lib/features/finance/domain/repositories/i_bank_account_repository.dart
import '../entities/bank_account.dart';

abstract class IBankAccountRepository {
  Future<List<BankAccount>> getByChurchId(String churchId);
  Future<BankAccount?> getById(String id);
  Future<BankAccount?> getDefaultAccount(String churchId);
  Future<void> save(BankAccount account);
  Future<void> delete(String id);
  Future<void> updateBalance(String id, double newBalance);
  Stream<List<BankAccount>> watchByChurchId(String churchId);
}