// ============================================================
// FICHIER : lib/core/providers/role_data_scope_provider.dart
// DESCRIPTION : Riverpod provider exposant le RoleDataScope
//               reconstruit automatiquement lorsque le contexte
//               auth/église/groupe change.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/domain/role_data_scope.dart';
import 'package:lumina/core/providers/auth_state_leaf.dart';
import 'package:lumina/features/profile/presentation/providers/profile_provider.dart';

/// Provider qui expose le [RoleDataScope] de l'utilisateur connecté.
///
/// Se reconstruit automatiquement quand :
/// - Le profil change (rôle, groupId)
/// - L'église active change
/// - L'utilisateur se déconnecte/reconnecte
final roleDataScopeProvider = Provider<RoleDataScope>((ref) {
  final profile = ref.watch(profileStateProvider).valueOrNull;
  final churchId = ref.watch(activeChurchIdProvider);
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null || profile == null) {
    return RoleDataScope.empty;
  }

  return RoleDataScope.fromContext(
    userId: user.id,
    role: profile.roleLevel,
    churchId: churchId,
    groupId: profile.groupId,
  );
});
