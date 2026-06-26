// lib/features/membres/presentation/screens/member_form_screen.dart
// Écran de formulaire (Wizard) pour ajouter/modifier un membre

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../../core/utils/haptic_helper.dart';

import '../providers/member_form_provider.dart';
import '../../domain/entities/enums/enums.dart';
import '../widgets/photo_picker.dart';

/// Écran de formulaire pour membre
class MemberFormScreen extends ConsumerStatefulWidget {
  final String? memberId;

  const MemberFormScreen({super.key, this.memberId});

  @override
  ConsumerState<MemberFormScreen> createState() => _MemberFormScreenState();
}

class _MemberFormScreenState extends ConsumerState<MemberFormScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.memberId != null;
    final theme = Theme.of(context);

    final formState = ref.watch(memberFormProvider(widget.memberId));

    return formState.when(
      loading: () =>
          const Scaffold(body: Center(child: LoadingDots())),
      error: (e, _) => Scaffold(
        body: Center(
          child: Text(
            'Impossible de charger le formulaire',
            style: theme.textTheme.bodyMedium?.copyWith(color: context.colors.errorText),
          ),
        ),
      ),
      data: (stateData) {
        return Scaffold(
          backgroundColor: context.colors.bgPage,
          appBar: AppBar(
            title: Semantics(
              label: isEditing ? 'Modifier Brebis' : 'Nouvelle Brebis',
              header: true,
              child: Text(
                isEditing ? 'Modifier Brebis' : 'Nouvelle Brebis',
                style: AppTypography.h3.copyWith(fontFamily: 'Outfit'),
              ),
            ),
            leading: Semantics(
              label: 'Fermer',
              button: true,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, size: AppSpacing.iconMd),
                onPressed: () async {
                  await HapticHelper.light();
                  if (context.mounted) {
                    context.pop();
                  }
                },
              ).withTouchTarget(),
            ),
          ),
          body: Column(
            children: [
              _buildProgressIndicator(context),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      _buildIdentityStep(context, stateData),
                      _buildContactStep(context, stateData),
                      _buildSpiritualStep(context, stateData),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colors.bgCard,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, -4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _prevStep,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 56),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Précédent'),
                        ).withTouchTarget(),
                      )
                    else
                      const Spacer(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GradientButton(
                        text: _currentStep == 2 ? 'Enregistrer' : 'Suivant',
                        isLoading: stateData.isLoading,
                        onPressed: _currentStep == 2 ? _submitForm : _nextStep,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        border: Border(bottom: BorderSide(color: context.colors.borderSubtle.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          _buildStepIcon(0, 'Identité'),
          _buildStepLine(0),
          _buildStepIcon(1, 'Contact'),
          _buildStepLine(1),
          _buildStepIcon(2, 'Spirituel'),
        ],
      ),
    );
  }

  Widget _buildStepIcon(int index, String label) {
    final isActive = index == _currentStep;
    final isCompleted = index < _currentStep;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive
                ? context.colors.brandPrimary
                : (isCompleted ? context.colors.successText : context.colors.borderSubtle),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    '${index + 1}',
                    style: TextStyle(
                      color:
                          isActive ? Colors.white : context.colors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            fontSize: 10,
            color: isActive ? context.colors.brandPrimary : context.colors.textSecondary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int index) {
    final isCompleted = index < _currentStep;
    return Expanded(
      child: Container(
        height: 2,
        color: isCompleted ? context.colors.successText : context.colors.borderSubtle.withValues(alpha: 0.3),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      ),
    );
  }

  // Étape 1: Identité
  Widget _buildIdentityStep(BuildContext context, MemberFormState stateData) {
    final member = stateData.member;
    final controller = ref.read(memberFormProvider(widget.memberId).notifier);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Center(
          child: PhotoPicker(
            currentLocalPhoto: stateData.selectedPhoto,
            onPhotoPicked: (photo) async {
              await HapticHelper.medium();
              controller.setPhoto(photo);
            },
            size: 120,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                initialValue: member.firstName,
                label: 'Prénom *',
                icon: Icons.person_outline_rounded,
                onChanged: (v) =>
                    controller.updateMember((m) => m.copyWith(firstName: v)),
                validator: (v) => v?.isEmpty == true ? 'Requis' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                initialValue: member.lastName,
                label: 'Nom *',
                onChanged: (v) =>
                    controller.updateMember((m) => m.copyWith(lastName: v)),
                validator: (v) => v?.isEmpty == true ? 'Requis' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _buildDropdown<Gender>(
          label: 'Genre',
          value: member.gender,
          icon: Icons.wc_rounded,
          items: Gender.values.map((g) => DropdownMenuItem(value: g, child: Text(g.label))).toList(),
          onChanged: (v) {
            if (v != null) controller.updateMember((m) => m.copyWith(gender: v));
          },
        ),
        const SizedBox(height: AppSpacing.md),
        InkWell(
          onTap: () async {
            await HapticHelper.light();
            if (!context.mounted) return;
            final date = await showDatePicker(
              context: context,
              initialDate: member.birthDate ?? DateTime(2000),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              locale: const Locale('fr', 'FR'),
              helpText: 'Sélectionner la date de naissance',
              cancelText: 'Annuler',
              confirmText: 'Confirmer',
            );
            if (date != null) {
              await HapticHelper.selection();
              controller.updateMember((m) => m.copyWith(birthDate: date));
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Date de naissance',
              prefixIcon: Icon(Icons.cake_outlined, color: context.colors.brandPrimary),
              suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            child: Text(
              member.birthDate != null
                  ? '${member.birthDate!.day}/${member.birthDate!.month}/${member.birthDate!.year}'
                  : 'Sélectionner',
              style: AppTypography.bodyMedium,
            ),
          ),
        ).withTouchTarget(),
      ],
    );
  }

  // Étape 2: Contact
  Widget _buildContactStep(BuildContext context, MemberFormState stateData) {
    final member = stateData.member;
    final controller = ref.read(memberFormProvider(widget.memberId).notifier);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _buildTextField(
          initialValue: member.phone,
          label: 'Téléphone',
          icon: Icons.phone_rounded,
          keyboardType: TextInputType.phone,
          onChanged: (v) =>
              controller.updateMember((m) => m.copyWith(phone: v)),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTextField(
          initialValue: member.email,
          label: 'Email',
          icon: Icons.email_rounded,
          keyboardType: TextInputType.emailAddress,
          onChanged: (v) =>
              controller.updateMember((m) => m.copyWith(email: v)),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTextField(
          initialValue: member.addressLine1,
          label: 'Adresse domicile',
          icon: Icons.home_rounded,
          maxLines: 2,
          onChanged: (v) =>
              controller.updateMember((m) => m.copyWith(addressLine1: v)),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTextField(
          initialValue: member.city,
          label: 'Ville / Quartier',
          icon: Icons.location_city_rounded,
          onChanged: (v) => controller.updateMember((m) => m.copyWith(city: v)),
        ),
      ],
    );
  }

  // Étape 3: Spirituel
  Widget _buildSpiritualStep(BuildContext context, MemberFormState stateData) {
    final member = stateData.member;
    final controller = ref.read(memberFormProvider(widget.memberId).notifier);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _buildDropdown<MemberStatus>(
          label: 'Statut du membre',
          value: member.status,
          icon: Icons.shield_rounded,
          items: MemberStatus.values
              .map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: Color(s.colorValue), size: 12),
                      const SizedBox(width: 12),
                      Text(s.label),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) controller.updateMember((m) => m.copyWith(status: v));
          },
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: context.colors.bgCardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.borderSubtle.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Est baptisé(e) ?', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Baptême par immersion'),
                value: member.isBaptized,
                onChanged: (v) async {
                  await HapticHelper.light();
                  controller.updateMember((m) => m.copyWith(isBaptized: v));
                },
                activeThumbColor: context.colors.brandPrimary,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ).withTouchTarget(),
              if (member.isBaptized) ...[
                const Divider(height: 1),
                InkWell(
                  onTap: () async {
                    await HapticHelper.light();
                    if (!context.mounted) return;
                    final date = await showDatePicker(
                      context: context,
                      initialDate: member.baptismDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      locale: const Locale('fr', 'FR'),
                      helpText: 'Sélectionner la date de baptême',
                      cancelText: 'Annuler',
                      confirmText: 'Confirmer',
                    );
                    if (date != null) {
                      await HapticHelper.selection();
                      controller.updateMember((m) => m.copyWith(baptismDate: date));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 18, color: context.colors.brandPrimary),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date de baptême', style: AppTypography.labelSmall.copyWith(color: context.colors.textSecondary)),
                            Text(
                              member.baptismDate != null
                                  ? '${member.baptismDate!.day}/${member.baptismDate!.month}/${member.baptismDate!.year}'
                                  : 'Sélectionner une date',
                              style: AppTypography.bodyMedium,
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.edit_rounded, size: 16),
                      ],
                    ),
                  ),
                ).withTouchTarget(),
              ],
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'FORMATION ET PARCOURS',
          style: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: context.colors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: context.colors.bgCardLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              CheckboxListTile(
                title: const Text('Classe de membre terminée'),
                value: member.hasCompletedMembershipClass,
                onChanged: (v) async {
                  await HapticHelper.light();
                  controller.updateMember(
                    (m) => m.copyWith(hasCompletedMembershipClass: v ?? false),
                  );
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ).withTouchTarget(),
              const Divider(height: 1),
              CheckboxListTile(
                title: const Text('Classe de maturité terminée'),
                value: member.hasCompletedMaturityClass,
                onChanged: (v) async {
                  await HapticHelper.light();
                  controller.updateMember(
                    (m) => m.copyWith(hasCompletedMaturityClass: v ?? false),
                  );
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ).withTouchTarget(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required ValueChanged<String> onChanged,
    String? initialValue,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: context.colors.brandPrimary) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
      onChanged: onChanged,
      validator: validator,
      onTap: () => HapticHelper.light(),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    IconData? icon,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: context.colors.brandPrimary) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
      items: items,
      onChanged: (v) async {
        await HapticHelper.selection();
        onChanged(v);
      },
    );
  }

  void _nextStep() async {
    if (_currentStep < 2) {
      await HapticHelper.medium();
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() async {
    if (_currentStep > 0) {
      await HapticHelper.light();
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      await HapticHelper.medium();
      final success =
          await ref.read(memberFormProvider(widget.memberId).notifier).submit();

      if (success && mounted) {
        await HapticHelper.success();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Brebis enregistrée avec succès'),
              backgroundColor: context.colors.successText,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop();
        }
      } else if (mounted) {
        await HapticHelper.error();
        if (!mounted) return;
        final stateData = ref.read(memberFormProvider(widget.memberId));
        final error = stateData.value?.error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Une erreur est survenue lors de l\'enregistrement'),
            backgroundColor: context.colors.errorText,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      await HapticHelper.warning();
    }
  }
}
