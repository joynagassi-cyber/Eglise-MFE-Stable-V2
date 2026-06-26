import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/features/rbac_admin/presentation/providers/rbac_providers.dart';


class UserRoleAssignmentSheet extends ConsumerWidget {
  final String userId;
  final String userName;
  final List<String> currentRoleIds;

  const UserRoleAssignmentSheet({
    required this.userId,
    required this.userName,
    required this.currentRoleIds,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesAsync = ref.watch(allRolesProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rôles pour $userName',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          rolesAsync.when(
            data: (roles) => Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  final role = roles[index];
                  final has = currentRoleIds.contains(role.id);
                  return CheckboxListTile(
                    title: Text(role.label),
                    subtitle: Text(role.code),
                    value: has,
                    onChanged: (val) => _toggleRole(ref, role.id, val!),
                  );
                },
              ),
            ),
            loading: () => const Center(child: LoadingDots()),
            error: (e, _) => const Text('Impossible de charger les rôles'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _toggleRole(WidgetRef ref, String roleId, bool assign) async {
    try {
      await ref.read(rbacRepositoryProvider).toggleUserRole(
            userId: userId,
            roleId: roleId,
            assign: assign,
          );
      // Re-fetch users/roles if needed
    } catch (e) {
      debugPrint('Error toggling role: $e');
    }
  }
}