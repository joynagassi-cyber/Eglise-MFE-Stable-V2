import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/providers/supabase_provider.dart';
import 'package:lumina/core/services/encryption_service.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';
import 'package:lumina/features/approvals/data/repositories/approval_repository.dart';
import 'package:lumina/features/approvals/domain/repositories/i_approval_repository.dart';
import 'package:lumina/features/bilan/data/repositories/bilan_repository.dart';
import 'package:lumina/features/bilan/domain/repositories/i_bilan_repository.dart';
import 'package:lumina/features/donors/data/repositories/donor_repository.dart';
import 'package:lumina/features/donors/domain/repositories/i_donor_repository.dart';
import 'package:lumina/features/finance/data/repositories/budget_repository_impl.dart';
import 'package:lumina/features/finance/data/repositories/finance_repository_impl.dart';
import 'package:lumina/features/finance/domain/repositories/i_budget_repository.dart';
import 'package:lumina/features/finance/domain/repositories/i_finance_repository.dart';

part 'repository_providers_finance.g.dart';

@Riverpod(keepAlive: true)
EncryptionService encryptionService(EncryptionServiceRef ref) {
  return EncryptionService();
}

@Riverpod(keepAlive: true)
IApprovalRepository approvalRepository(ApprovalRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  return ApprovalRepository(supabase);
}

@Riverpod(keepAlive: true)
IFinanceRepository financeRepository(FinanceRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  final syncManager = ref.watch(offlineSyncManagerProvider);
  final encryption = ref.watch(encryptionServiceProvider);

  return FinanceRepositoryImpl(supabase, isar, syncManager, encryption, ref);
}

@Riverpod(keepAlive: true)
IBudgetRepository budgetRepository(BudgetRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  final financeRepo = ref.watch(financeRepositoryProvider);

  return BudgetRepositoryImpl(supabase, isar, financeRepo, ref);
}

@Riverpod(keepAlive: true)
IDonorRepository donorRepository(DonorRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  return DonorRepository(supabase, ref);
}

@Riverpod(keepAlive: true)
IBilanRepository bilanRepository(BilanRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  return BilanRepository(supabase);
}
