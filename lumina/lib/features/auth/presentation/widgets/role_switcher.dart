import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/available_roles_provider.dart';
import 'package:lumina/core/providers/user_context_provider.dart';

class RoleSwitcher extends ConsumerWidget {
  const RoleSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableRolesAsync = ref.watch(availableRolesProvider);
    final currentContextAsync = ref.watch(userContextNotifierProvider);

    return currentContextAsync.when(
      data: (userContext) {
        if (userContext == null) return const SizedBox.shrink();

        return availableRolesAsync.when(
          data: (roles) {
            // S'il n'y a qu'un rôle, pas besoin de switcher (sauf si superadmin)
            if (roles.length <= 1 && !userContext.role.isSuper) {
              return ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(userContext.role.label),
                subtitle: const Text('Rôle unique'),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.swap_horiz,
                        size: LuminaIcon.md,
                        color: context.colors.iconSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'CHANGER DE RÔLE',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                              color: context.colors.textTertiary,
                            ),
                      ),
                    ],
                  ),
                ),
                ...roles.map((role) {
                  final isSelected = role.roleCode == userContext.role.code;
                  return ListTile(
                    leading: Icon(
                      isSelected ? Icons.check_circle : Icons.radio_button_off,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : context.colors.iconSecondary,
                    ),
                    title: Text(
                      role.roleLabel,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      if (!isSelected) {
                        ref
                            .read(roleControllerProvider.notifier)
                            .switchRole(role);
                      }
                    },
                  );
                }),
              ],
            );
          },
          loading: () => const Center(child: LoadingState()),
          error: (e, _) =>
              const ListTile(title: Text('Erreur de chargement des rôles')),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: LoadingDots()),
      ),
      error: (e, _) => ListTile(
        leading: Icon(Icons.warning_amber_rounded, color: context.colors.warningIcon),
        title: const Text('Impossible de charger le contexte'),
      ),
    );
  }
}

/// Affiche le switcher dans une BottomSheet
void showRoleSwitcher(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) => const SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: RoleSwitcher(),
      ),
    ),
  );
}
