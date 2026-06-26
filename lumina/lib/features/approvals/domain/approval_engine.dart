import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/approval_request.dart';
import '../../../core/auth/domain/entities/enums/role_level.dart';

// Simple provider for engine
final approvalEngineProvider = Provider((ref) => ApprovalEngine());

class ApprovalEngine {
  /// Determines if the current user can approve the given request
  bool canUserApprove(
    ApprovalRequest request,
    String? userId,
    RoleLevel? userRole,
  ) {
    // 1. Basic status check
    if (request.status != 'pending') return false;

    // 2. Role based check (Simplified)
    // Superadmins can approve everything
    if (userRole == RoleLevel.superadmin) return true;

    // Admins can approve most things
    if (userRole == RoleLevel.admin) {
      // Example: Restricted entities for superadmins only
      const superOnly = ['role_change', 'church_delete'];
      return !superOnly.contains(request.entityType);
    }

    // Standard users or specific roles see only what RPC gives them
    // This engine adds a client-side safety layer.
    return userRole != null && userRole != RoleLevel.membre;
  }
}