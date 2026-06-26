import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/features/groups/domain/entities/group.dart';
import 'package:lumina/features/groups/domain/entities/group_membership.dart';
import 'package:lumina/features/groups/presentation/providers/group_providers.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/features/membres/domain/entities/member.dart';
import 'package:lumina/features/membres/presentation/providers/member_list_provider.dart';

class GroupAssignmentDialog extends ConsumerStatefulWidget {
  final Group? initialGroup;
  final Member? initialMember;

  const GroupAssignmentDialog({
    super.key,
    this.initialGroup,
    this.initialMember,
  });

  @override
  ConsumerState<GroupAssignmentDialog> createState() =>
      _GroupAssignmentDialogState();
}

class _GroupAssignmentDialogState extends ConsumerState<GroupAssignmentDialog> {
  final _formKey = GlobalKey<FormState>();

  Group? _selectedGroup;
  Member? _selectedMember;
  GroupRole _selectedRole = GroupRole.member;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedGroup = widget.initialGroup;
    _selectedMember = widget.initialMember;
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(groupsProvider);
    final membersAsync = ref.watch(memberListProvider);

    return AlertDialog(
      title: Text(
        widget.initialGroup != null
            ? 'Ajouter un membre au groupe'
            : (widget.initialMember != null
                ? 'Affecter à un groupe'
                : 'Nouvelle affectation'),
        style: TextStyle(
          fontFamily: LuminaFont.display,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: context.colors.textPrimary,
        ),
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Sélection du Groupe
              if (widget.initialGroup != null)
                ListTile(
                  leading: Icon(Icons.group, color: context.colors.brandPrimary),
                  title: Text(_selectedGroup!.name, style: const TextStyle(fontFamily: LuminaFont.display, fontWeight: FontWeight.bold)),
                  subtitle: Text(_selectedGroup!.type.name, style: TextStyle(fontFamily: LuminaFont.body, color: context.colors.textSecondary)),
                  contentPadding: EdgeInsets.zero,
                )
              else
                groupsAsync.when(
                  data: (groups) => DropdownButtonFormField<Group>(
                    initialValue: _selectedGroup,
                    decoration: const InputDecoration(
                      labelText: 'Groupe / Cellule',
                      prefixIcon: Icon(Icons.group_outlined),
                    ),
                    items: groups.map((g) {
                      return DropdownMenuItem(
                        value: g,
                        child: Text('${g.name} (${g.type.name})'),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedGroup = value),
                    validator: (v) =>
                        v == null ? 'Veuillez sélectionner un groupe' : null,
                  ),
                  loading: () => const AppProgressBar(),
                  error: (_, __) =>
                      Text('Erreur de chargement des groupes'),
                ),

              SizedBox(height: 16),

              // 2. Sélection du Membre
              if (widget.initialMember != null)
                ListTile(
                  leading: AvatarWidget(
                    imageUrl: _selectedMember!.photoUrl,
                    fallbackName: _selectedMember!.fullName,
                    size: LuminaIcon.xxl,
                  ),
                  title: Text(_selectedMember!.fullName),
                  subtitle: Text(_selectedMember!.status.label),
                  contentPadding: EdgeInsets.zero,
                )
              else
                membersAsync.when(
                  data: (members) => DropdownButtonFormField<Member>(
                    initialValue: _selectedMember,
                    decoration: InputDecoration(
                      labelText: 'Membre à affecter',
                      labelStyle: TextStyle(fontFamily: LuminaFont.body, fontSize: 13, color: context.colors.textSecondary),
                      prefixIcon: Icon(Icons.person_outline, size: LuminaIcon.sm),
                    ),
                    items: members.map((m) {
                      return DropdownMenuItem(
                        value: m,
                        child: Text(m.fullName),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedMember = value),
                    validator: (v) =>
                        v == null ? 'Veuillez sélectionner un membre' : null,
                    isExpanded: true, // Pour éviter l'overflow si noms longs
                  ),
                  loading: () => const AppProgressBar(),
                  error: (_, __) =>
                      Text('Erreur de chargement des membres'),
                ),

              SizedBox(height: 16),

              // 3. Sélection du Rôle
              DropdownButtonFormField<GroupRole>(
                initialValue: _selectedRole,
                decoration: InputDecoration(
                  labelText: 'Rôle dans le groupe',
                  labelStyle: TextStyle(fontFamily: LuminaFont.body, fontSize: 13, color: context.colors.textSecondary),
                  prefixIcon: Icon(Icons.badge_outlined, size: LuminaIcon.sm),
                ),
                items: GroupRole.values.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(_getRoleLabel(role)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedRole = value);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Annuler'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _submit,
          style: FilledButton.styleFrom(
            backgroundColor: context.colors.brandPrimary,
            foregroundColor: context.colors.textInverse,
          ),
          child: _isLoading
              ? SizedBox(
                  width: LuminaIcon.sm,
                  height: LuminaIcon.sm,
                  child: LoadingDots(size: LuminaIcon.sm),
                )
              : Text('Affecter'),
        ),
      ],
    );
  }

  String _getRoleLabel(GroupRole role) {
    switch (role) {
      case GroupRole.member:
        return 'Membre';
      case GroupRole.leader:
        return 'Leader / Responsable';
      case GroupRole.coLeader:
        return 'Co-Leader / Adjoint';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGroup == null || _selectedMember == null) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(groupControllerProvider.notifier).addMemberToGroup(
            groupId: _selectedGroup!.id,
            memberId: _selectedMember!.id,
            role: _selectedRole,
          );

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_selectedMember!.shortName} ajouté(e) au groupe ${_selectedGroup!.name}',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Impossible d\'affecter le membre'),
            backgroundColor: context.colors.errorBg,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
