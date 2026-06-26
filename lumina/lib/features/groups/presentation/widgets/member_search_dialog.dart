import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../membres/presentation/providers/member_list_provider.dart';
import '../providers/group_providers.dart';

class MemberSearchDialog extends ConsumerStatefulWidget {
  final String groupId;

  const MemberSearchDialog({super.key, required this.groupId});

  @override
  ConsumerState<MemberSearchDialog> createState() => _MemberSearchDialogState();
}

class _MemberSearchDialogState extends ConsumerState<MemberSearchDialog> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(memberListProvider);

    return AlertDialog(
      title: Text(
        'Ajouter un membre',
        style: AppTypography.h3.copyWith(
          color: context.colors.textPrimary,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher par nom...',
                hintStyle: AppTypography.bodySmall.copyWith(
                  color: context.colors.textTertiary,
                ),
                prefixIcon: Icon(Icons.search, size: LuminaIcon.sm, color: context.colors.brandPrimary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.colors.borderSubtle.withValues(alpha: 0.3)),
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            SizedBox(height: AppSpacing.md),
            Flexible(
              child: membersAsync.when(
                data: (members) {
                  final filtered = members
                      .where(
                        (m) =>
                            m.fullName.toLowerCase().contains(
                                  _searchQuery.toLowerCase(),
                                ) ||
                            m.memberNumber?.contains(_searchQuery) == true,
                      )
                      .toList();

                  if (filtered.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Text('Aucun résultat.'),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final member = filtered[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: context.colors.brandPrimary.withValues(alpha: 0.1),
                          child: Text(member.initials, style: TextStyle(color: context.colors.brandPrimary, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(member.fullName, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          member.memberNumber ?? 'Sans numéro',
                          style: AppTypography.labelSmall.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                        onTap: () => _addMember(member.id),
                      );
                    },
                  );
                },
                loading: () => Center(child: LoadingState()),
                error: (e, st) => Text('Impossible de charger les membres'),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Fermer'),
        ),
      ],
    );
  }

  Future<void> _addMember(String memberId) async {
    try {
      await ref
          .read(groupControllerProvider.notifier)
          .addMemberToGroup(groupId: widget.groupId, memberId: memberId);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Membre ajouté au groupe !')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Impossible d\'ajouter le membre')));
      }
    }
  }
}
