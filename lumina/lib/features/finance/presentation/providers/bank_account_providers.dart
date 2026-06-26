// lib/features/finance/presentation/providers/bank_account_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/bank_account_repository_impl.dart';
import '../../domain/entities/bank_account.dart';
import '../../domain/repositories/i_bank_account_repository.dart';
import 'package:lumina/core/providers/user_context_provider.dart';

part 'bank_account_providers.g.dart';

/// Repository provider
@riverpod
IBankAccountRepository bankAccountRepository(Ref ref) {
  return SupabaseBankAccountRepository(Supabase.instance.client);
}

/// Liste des comptes bancaires pour l'église courante
@riverpod
Future<List<BankAccount>> bankAccountList(Ref ref) async {
  final repo = ref.watch(bankAccountRepositoryProvider);
  final userContext = ref.watch(userContextNotifierProvider).value;
  final churchId = userContext?.activeChurchId ?? '';
  if (churchId.isEmpty) return [];
  return repo.getByChurchId(churchId);
}

/// Stream des comptes bancaires (temps réel)
@riverpod
Stream<List<BankAccount>> bankAccountStream(Ref ref) {
  final repo = ref.watch(bankAccountRepositoryProvider);
  final userContext = ref.watch(userContextNotifierProvider).value;
  final churchId = userContext?.activeChurchId ?? '';
  if (churchId.isEmpty) return Stream.value([]);
  return repo.watchByChurchId(churchId);
}

/// Compte par défaut
@riverpod
Future<BankAccount?> defaultBankAccount(Ref ref) async {
  final repo = ref.watch(bankAccountRepositoryProvider);
  final userContext = ref.watch(userContextNotifierProvider).value;
  final churchId = userContext?.activeChurchId ?? '';
  if (churchId.isEmpty) return null;
  return repo.getDefaultAccount(churchId);
}