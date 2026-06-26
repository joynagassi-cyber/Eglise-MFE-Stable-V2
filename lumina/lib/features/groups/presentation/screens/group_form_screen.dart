// lib/features/groups/presentation/screens/group_form_screen.dart
// Formulaire Groupe - Deep Purple Theme - MIGRATED TO DESIGN SYSTEM

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/features/groups/domain/entities/group.dart';
import 'package:lumina/features/groups/presentation/providers/group_providers.dart';

class GroupFormScreen extends ConsumerStatefulWidget {
  final String? groupId;
  final Group? initialGroup;

  const GroupFormScreen({super.key, this.groupId, this.initialGroup});

  @override
  ConsumerState<GroupFormScreen> createState() => _GroupFormScreenState();
}

class _GroupFormScreenState extends ConsumerState<GroupFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _scheduleController;
  GroupType _selectedType = GroupType.cellule;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialGroup?.name ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialGroup?.description ?? '',
    );
    _locationController = TextEditingController(
      text: widget.initialGroup?.location ?? '',
    );
    _scheduleController = TextEditingController(
      text: widget.initialGroup?.scheduleDescription ?? '',
    );
    if (widget.initialGroup != null) {
      _selectedType = widget.initialGroup!.type;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _scheduleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      await HapticHelper.warning();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final notifier = ref.read(groupControllerProvider.notifier);

      if (widget.groupId != null && widget.initialGroup != null) {
        final updatedGroup = Group(
          id: widget.initialGroup!.id,
          churchId: widget.initialGroup!.churchId,
          name: _nameController.text,
          description: _descriptionController.text,
          location: _locationController.text,
          scheduleDescription: _scheduleController.text,
          type: _selectedType,
          leaderId: widget.initialGroup!.leaderId,
          createdAt: widget.initialGroup!.createdAt,
          updatedAt: DateTime.now(),
          isActive: widget.initialGroup!.isActive,
        );
        await notifier.updateGroup(updatedGroup);
      } else {
        await notifier.createGroup(
          name: _nameController.text,
          type: _selectedType,
          description: _descriptionController.text,
          location: _locationController.text,
          schedule: _scheduleController.text,
        );
      }

      await HapticHelper.success();
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: context.colors.bgCard),
                const SizedBox(width: 8),
                Text(
                  widget.groupId != null ? 'Groupe mis à jour' : 'Groupe créé',
                ),
              ],
            ),
            backgroundColor: context.colors.successText,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusMd,
            ),
          ),
        );
      }
    } catch (e) {
      await HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Impossible d\'enregistrer le groupe'),
            backgroundColor: context.colors.errorText,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupId != null ? 'Modifier Groupe' : 'Nouveau Groupe',
          style: AppTypography.h3.copyWith(fontFamily: 'Outfit'),
        ),
        leading: Semantics(
          label: 'Retour',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () async {
              await HapticHelper.light();
              if (context.mounted) context.pop();
            },
          ).withTouchTarget(),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedEntrance.fromBottom(
                delay: const Duration(milliseconds: 100),
                child: _buildTextField(
                  controller: _nameController,
                  label: 'Nom du groupe *',
                  icon: Icons.group_rounded,
                  isDark: isDark,
                  theme: theme,
                  validator: (v) => v?.isEmpty == true ? 'Requis' : null,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AnimatedEntrance.fromBottom(
                delay: const Duration(milliseconds: 200),
                child: _buildTypeSelector(context, isDark, theme),
              ),
              const SizedBox(height: AppSpacing.md),
              AnimatedEntrance.fromBottom(
                delay: const Duration(milliseconds: 300),
                child: _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  icon: Icons.description_rounded,
                  maxLines: 3,
                  isDark: isDark,
                  theme: theme,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AnimatedEntrance.fromBottom(
                delay: const Duration(milliseconds: 400),
                child: _buildTextField(
                  controller: _locationController,
                  label: 'Lieu (Adresse, Salle...)',
                  icon: Icons.location_on_rounded,
                  isDark: isDark,
                  theme: theme,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AnimatedEntrance.fromBottom(
                delay: const Duration(milliseconds: 500),
                child: _buildTextField(
                  controller: _scheduleController,
                  label: 'Horaires (ex: Vendredi 19h)',
                  icon: Icons.schedule_rounded,
                  isDark: isDark,
                  theme: theme,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AnimatedEntrance.fromBottom(
                delay: const Duration(milliseconds: 600),
                child: Semantics(
                  label: _isLoading
                      ? 'Enregistrement en cours'
                      : 'Enregistrer le groupe',
                  button: true,
                  enabled: !_isLoading,
                  child: GradientButton(
                    text: _isLoading ? 'Enregistrement...' : 'Enregistrer',
                    icon: Icons.save_rounded,
                    onPressed: _isLoading ? null : _save,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isDark,
    required ThemeData theme,
    IconData? icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Semantics(
      label: label,
      textField: true,
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: AppTypography.bodyMedium.copyWith(
          color: context.colors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTypography.bodySmall.copyWith(
            color: context.colors.textSecondary,
          ),
          prefixIcon: icon != null
              ? Icon(icon, color: context.colors.brandPrimary, size: LuminaIcon.md)
              : null,
          filled: true,
          fillColor: context.colors.bgCard,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide(color: context.colors.borderSubtle),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide(color: context.colors.brandPrimary, width: 2),
          ),
        ),
        validator: validator,
        onTap: () => HapticHelper.light(),
      ),
    );
  }

  Widget _buildTypeSelector(
    BuildContext context,
    bool isDark,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type de groupe',
          style: AppTypography.labelSmall.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: GroupType.values.map((type) {
            final isSelected = _selectedType == type;
            return Semantics(
              label: 'Type: ${_getLabelForType(type)}',
              button: true,
              selected: isSelected,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    await HapticHelper.selection();
                    setState(() => _selectedType = type);
                  },
                  borderRadius: AppSpacing.borderRadiusMd,
                  child: AnimatedContainer(
                    duration: AppSpacing.animationFast,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected ? context.colors.brandPrimaryGradient : null,
                      color: isSelected ? null : context.colors.bgCard,
                      borderRadius: AppSpacing.borderRadiusMd,
                      border: Border.all(
                        color: isSelected
                            ? context.colors.brandPrimary
                            : context.colors.borderSubtle,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getIconForType(type),
                          size: LuminaIcon.sm,
                          color: isSelected
                              ? context.colors.textOnBrand
                              : context.colors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getLabelForType(type),
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? context.colors.textOnBrand : context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).withTouchTarget(),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _getIconForType(GroupType type) {
    switch (type) {
      case GroupType.cellule:
        return Icons.home_work_rounded;
      case GroupType.ministere:
        return Icons.account_balance_rounded;
      case GroupType.equipe:
        return Icons.flag_rounded;
      default:
        return Icons.group_rounded;
    }
  }

  String _getLabelForType(GroupType type) {
    switch (type) {
      case GroupType.cellule:
        return 'Cellule';
      case GroupType.ministere:
        return 'Département';
      case GroupType.equipe:
        return 'Équipe';
      default:
        return 'Autre';
    }
  }
}