import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/providers/repository_providers_auth.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../data/models/approval_request.dart';

/// Provider for pending approvals
final pendingApprovalsProvider = FutureProvider<List<ApprovalRequest>>((
  ref,
) async {
  final repo = ref.watch(approvalRepositoryProvider);
  return repo.getMyPendingApprovals();
});

/// Provider for all roles (needed for RBAC/Approvals)
final allRolesProvider = FutureProvider((ref) async {
  final repo = ref.watch(roleRepositoryProvider);
  final churchId = ref.watch(activeChurchIdProvider);
  return repo.getAllRoles(churchId: churchId);
});
