import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/l10n/app_localizations.dart';
import '../../dashboard/presentation/widgets/premium_dashboard_scaffold.dart';
import 'providers/rbac_providers.dart';

class RbacDashboardScreen extends ConsumerWidget {
  const RbacDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesAsync = ref.watch(allRolesProvider);

    return PremiumDashboardScaffold(
      title: AppLocalizations.of(context)!.rbacAdmin,
      subtitle: AppLocalizations.of(context)!.rolesPermissions,
      headerAction: IconButton(
        icon: Icon(Icons.grid_view),
        tooltip: AppLocalizations.of(context)!.permissionsMatrix,
        onPressed: () => context.push(AppRoutes.adminRolesMatrix),
      ),
      onRefresh: () => ref.refresh(allRolesProvider),
      body: rolesAsync.when(
        data: (roles) => ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: roles.length,
          itemBuilder: (context, index) {
            final role = roles[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      role.isSuper ? context.colors.brandSecondary : context.colors.infoText,
                  child: Text(
                    role.priorityLevel.toString(),
                    style: TextStyle(color: context.colors.textOnBrand,
                      fontSize: 12,
                    ),
                  ),
                ),
                title: Text(role.label),
                subtitle: Text(role.code),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to role details
                },
              ),
            );
          },
        ),
        loading: () => const ShimmerCardList(
          itemCount: 4,
          itemHeight: 70,
        ),
        error: (e, _) => Center(
          child: Text('${AppLocalizations.of(context)!.errorOccurred}: $e'),
        ),
      ),
    );
  }
}
