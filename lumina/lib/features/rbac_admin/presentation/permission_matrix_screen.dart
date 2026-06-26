import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'providers/rbac_providers.dart';
import '../data/models/rbac_models.dart';

class PermissionMatrixScreen extends ConsumerStatefulWidget {
  const PermissionMatrixScreen({super.key});

  @override
  ConsumerState<PermissionMatrixScreen> createState() =>
      _PermissionMatrixScreenState();
}

class _PermissionMatrixScreenState
    extends ConsumerState<PermissionMatrixScreen> {
  String? _selectedModule;

  @override
  Widget build(BuildContext context) {
    final permissionsAsync = ref.watch(allPermissionsProvider);
    final rolesAsync = ref.watch(allRolesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Matrice des Permissions'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Filtrer par module : '),
                DropdownButton<String>(
                  value: _selectedModule,
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Tous')),
                    DropdownMenuItem(
                      value: 'finance',
                      child: Text('Finance'),
                    ),
                    DropdownMenuItem(
                      value: 'admin',
                      child: Text('Admin'),
                    ),
                    DropdownMenuItem(
                      value: 'donors',
                      child: Text('Donateurs'),
                    ),
                  ],
                  onChanged: (val) => setState(() => _selectedModule = val),
                ),
              ],
            ),
          ),
        ),
      ),
      body: permissionsAsync.when(
        data: (perms) => rolesAsync.when(
          data: (roles) => _buildMatrix(perms, roles),
          loading: () => Center(child: LoadingState()),
          error: (e, _) => Center(child: Text('Erreur rôles: $e')),
        ),
        loading: () => Center(child: LoadingState()),
        error: (e, _) => Center(child: Text('Erreur permissions: $e')),
      ),
    );
  }

  Widget _buildMatrix(List<Permission> perms, List<Role> roles) {
    final filteredPerms = _selectedModule == null
        ? perms
        : perms.where((p) => p.module == _selectedModule).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            const DataColumn(label: Text('Permission')),
            ...roles.map(
              (r) => DataColumn(
                label: Text(r.code, style: const TextStyle(fontSize: 10)),
              ),
            ),
          ],
          rows: filteredPerms
              .map(
                (p) => DataRow(
                  cells: [
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            p.label,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            p.code,
                            style: TextStyle(
                              fontSize: 10,
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...roles.map(
                      (r) => DataCell(
                        _PermissionToggle(
                          roleId: r.id,
                          permissionId: p.id,
                          permissionCode: p.code,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _PermissionToggle extends ConsumerWidget {
  final String roleId;
  final String permissionId;
  final String permissionCode;

  const _PermissionToggle({
    required this.roleId,
    required this.permissionId,
    required this.permissionCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This requires a provider that tracks role_permissions state
    // For now, let's assume we have a rolePermissionsProvider(roleId)
    final rolePermsAsync = ref.watch(rolePermissionsProvider(roleId));

    return rolePermsAsync.when(
      data: (perms) {
        final has = perms.contains(permissionCode);
        return IconButton(
          icon: Icon(
            has ? Icons.check_circle : Icons.cancel,
            color: has ? context.colors.successText : context.colors.errorText,
          ),
          onPressed: () => _toggle(ref, has),
        );
      },
      loading: () => SizedBox(
        width: 20,
        height: 20,
        child: LoadingDots(),
      ),
      error: (_, __) => Icon(Icons.error, color: context.colors.warningText),
    );
  }

  Future<void> _toggle(WidgetRef ref, bool currentlyHas) async {
    final repo = ref.read(rbacRepositoryProvider);
    if (currentlyHas) {
      await repo.revokePermission(roleId, permissionId);
    } else {
      await repo.grantPermission(roleId, permissionId);
    }
    // Refresh the specific role permissions
    ref.invalidate(rolePermissionsProvider(roleId));
  }
}
