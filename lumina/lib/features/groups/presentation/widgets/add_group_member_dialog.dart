import 'package:lumina/core/extensions/context_extension.dart';
// lib/features/groups/presentation/widgets/add_group_member_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import '../../../membres/presentation/providers/member_list_provider.dart';
import '../providers/group_providers.dart';

class AddGroupMemberDialog extends ConsumerStatefulWidget {
  final String groupId;

  const AddGroupMemberDialog({super.key, required this.groupId});

  @override
  ConsumerState<AddGroupMemberDialog> createState() =>
      _AddGroupMemberDialogState();
}

class _AddGroupMemberDialogState extends ConsumerState<AddGroupMemberDialog> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

    // On observe la recherche
    final membersAsync = ref.watch(paginatedMembersProvider);
    final searchQuery = ref.watch(memberSearchProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
      child: GlassCard(
        padding: AppSpacing.cardPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ajouter un Membre',
                  style: TextStyle(
                    fontFamily: LuminaFont.display,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                Semantics(
                  label: 'Fermer',
                  button: true,
                  child: Tooltip(
                    message: 'Fermer',
                    child: IconButton(
                      icon: Icon(Icons.close_rounded, color: context.colors.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),

            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un nom, téléphone...',
                prefixIcon:
                    Icon(Icons.search_rounded, color: context.colors.brandPrimary),
                filled: true,
                fillColor: context.colors.bgOverlay,
                border: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusMd,
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                ref.read(memberSearchProvider.notifier).state = val;
              },
            ),

            SizedBox(height: AppSpacing.lg),

            // Results List
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: membersAsync.isLoading && membersAsync.members.isEmpty
                  ? Center(child: LoadingState())
                  : membersAsync.members.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            child: Text(
                              searchQuery.isEmpty
                                  ? 'Commencez à taper...'
                                  : 'Aucun membre trouvé',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: context.colors.textSecondary,
                                fontFamily: LuminaFont.body,
                              ),
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: membersAsync.members.length,
                          separatorBuilder: (_, __) => Divider(height: 1),
                          itemBuilder: (context, index) {
                            final member = membersAsync.members[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor:
                                    context.colors.brandPrimary.withValues(alpha: 0.1),
                                child: Text(member.firstName.isNotEmpty ? member.firstName[0] : '?',
                                    style: TextStyle(
                                        color: context.colors.brandPrimary)),
                              ),
                              title: Text(member.fullName,
                                  style: const TextStyle(
                                      fontFamily: LuminaFont.body,
                                      fontWeight: FontWeight.w600)),
                              subtitle: Text(member.primaryRole.name,
                                  style: TextStyle(
                                      fontFamily: LuminaFont.body,
                                      fontSize: 12,
                                      color: context.colors.textSecondary)),
                              trailing: Icon(
                                  Icons.add_circle_outline_rounded,
                                  color: context.colors.brandPrimary),
                              onTap: () async {
                                await HapticHelper.medium();
                                await ref
                                    .read(groupControllerProvider.notifier)
                                    .addMemberToGroup(
                                      groupId: widget.groupId,
                                      memberId: member.id,
                                    );
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${member.fullName} ajouté au groupe')),
                                  );
                                }
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
