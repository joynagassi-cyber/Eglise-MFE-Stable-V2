// lib/features/finance/presentation/providers/approval_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/approval_repository.dart';
import '../../domain/entities/approval.dart';

/// Provider pour le repository d'approbation
final financeApprovalRepoProvider = Provider<ApprovalRepository>((ref) {
  return ApprovalRepository(Supabase.instance.client);
});

/// Provider pour les approbations d'une transaction
final transactionApprovalsProvider =
    FutureProvider.family<List<Approval>, String>((ref, transactionId) async {
  final repository = ref.watch(financeApprovalRepoProvider);
  return repository.getApprovalsForTransaction(transactionId);
});

/// Provider pour vérifier si une transaction est approuvée
final isTransactionApprovedProvider = FutureProvider.family<bool, String>((
  ref,
  transactionId,
) async {
  final repository = ref.watch(financeApprovalRepoProvider);
  return repository.isTransactionApproved(transactionId);
});

/// Provider pour les approbations de l'utilisateur connecté
final myApprovalsProvider = FutureProvider<List<Approval>>((ref) async {
  final repository = ref.watch(financeApprovalRepoProvider);
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return [];
  return repository.getApprovalsByUser(userId);
});