// lib/features/bergers/presentation/screens/shepherd_form_screen.dart
// Formulaire Berger - Deep Purple Theme

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/features/bergers/domain/entities/shepherd.dart';
import 'package:lumina/features/bergers/presentation/providers/shepherd_providers.dart';
import 'package:lumina/features/membres/presentation/providers/member_detail_provider.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';

class ShepherdFormScreen extends ConsumerStatefulWidget {
  final Shepherd? shepherd;
  final String? memberId;

  const ShepherdFormScreen({super.key, this.shepherd, this.memberId});

  @override
  ConsumerState<ShepherdFormScreen> createState() => _ShepherdFormScreenState();
}

class _ShepherdFormScreenState extends ConsumerState<ShepherdFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _levelController;
  late TextEditingController _bioController;
  late TextEditingController _specialtiesController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _levelController = TextEditingController(
      text: widget.shepherd?.level ?? 'DEBUTANT',
    );
    _bioController = TextEditingController(text: widget.shepherd?.bio ?? '');
    _specialtiesController = TextEditingController(
      text: widget.shepherd?.specialties.join(', ') ?? '',
    );
  }

  @override
  void dispose() {
    _levelController.dispose();
    _bioController.dispose();
    _specialtiesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    await HapticHelper.light();
    setState(() => _isLoading = true);

    try {
      final specialties = _specialtiesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (widget.shepherd != null) {
        final updated = widget.shepherd!.copyWith(
          level: _levelController.text,
          bio: _bioController.text,
          specialties: specialties,
          updatedAt: DateTime.now(),
        );
        await ref.read(shepherdRepositoryProvider).updateShepherd(updated);
      } else {
        if (widget.memberId == null) {
          throw Exception('ID Membre requis pour créer un berger');
        }

        final memberAsync = ref.read(memberDetailProvider(widget.memberId!));
        final member = memberAsync.value;
        if (member == null) {
          throw Exception('Données membre non disponibles pour la création');
        }

        final newShepherd = Shepherd(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          churchId: member.churchId,
          memberId: widget.memberId!,
          firstName: member.firstName,
          lastName: member.lastName,
          photoUrl: member.photoUrl,
          level: _levelController.text,
          bio: _bioController.text,
          specialties: specialties,
          supervisedGroupIds: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await ref.read(shepherdRepositoryProvider).createShepherd(newShepherd);
      }

      ref.invalidate(shepherdListProvider);
      await HapticHelper.success();

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Berger enregistré avec succès',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
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
            content: Text(
              'Impossible d\'enregistrer le berger',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
            backgroundColor: context.colors.errorText,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const levels = ['DEBUTANT', 'CONFIRME', 'ANCIEN', 'RESPONSABLE'];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: widget.shepherd != null ? 'Modifier Berger' : 'Nouveau Berger',
          child: Text(
            widget.shepherd != null ? 'Modifier Berger' : 'Nouveau Berger',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: LoadingState(),
            )
          : SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedEntrance.fromBottom(
                      delay: const Duration(milliseconds: 100),
                      child: Text(
                        'Informations Pastorales',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AnimatedEntrance.fromBottom(
                      delay: const Duration(milliseconds: 200),
                      child: _buildDropdown(levels, isDark, theme),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AnimatedEntrance.fromBottom(
                      delay: const Duration(milliseconds: 300),
                      child: _buildTextField(
                        controller: _bioController,
                        label: 'Biographie / Note',
                        icon: Icons.notes_rounded,
                        maxLines: 4,
                        isDark: isDark,
                        theme: theme,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AnimatedEntrance.fromBottom(
                      delay: const Duration(milliseconds: 400),
                      child: _buildTextField(
                        controller: _specialtiesController,
                        label: 'Spécialités (séparées par des virgules)',
                        hint: 'Ex: Jeunesse, Musique, Couple',
                        icon: Icons.star_rounded,
                        isDark: isDark,
                        theme: theme,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AnimatedEntrance.fromBottom(
                      delay: const Duration(milliseconds: 500),
                      child: Semantics(
                        label: 'Enregistrer berger',
                        button: true,
                        enabled: !_isLoading,
                        child: GradientButton(
                          text: 'ENREGISTRER',
                          icon: Icons.save_rounded,
                          onPressed: _save,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDropdown(List<String> levels, bool isDark, ThemeData theme) {
    return Semantics(
      label: 'Niveau pastoral, sélection actuelle: ${_levelController.text}',
      child: DropdownButtonFormField<String>(
        value: _levelController.text,
        dropdownColor: context.colors.bgCard,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: 'Niveau',
          labelStyle: theme.textTheme.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
          prefixIcon: Icon(Icons.layers_rounded,
            color: context.colors.brandPrimary,
            size: AppSpacing.iconMd,
          ),
          filled: true,
          fillColor: context.colors.bgCard,
          border: OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide(
              color: context.colors.borderSubtle,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide(color: context.colors.brandPrimary, width: 2),
          ),
        ),
        items: levels
            .map((l) => DropdownMenuItem(value: l, child: Text(l)))
            .toList(),
        onChanged: (val) async {
          if (val != null) {
            await HapticHelper.selection();
            setState(() => _levelController.text = val);
          }
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isDark,
    required ThemeData theme,
    String? hint,
    IconData? icon,
    int maxLines = 1,
  }) {
    return Semantics(
      label: label,
      textField: true,
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: theme.textTheme.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
          prefixIcon: icon != null
              ? Icon(icon, color: context.colors.brandPrimary, size: AppSpacing.iconMd)
              : null,
          alignLabelWithHint: maxLines > 1,
          filled: true,
          fillColor: context.colors.bgCard,
          border: OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide(
              color: context.colors.borderSubtle,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide(color: context.colors.brandPrimary, width: 2),
          ),
        ),
      ),
    );
  }
}
