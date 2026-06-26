import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../../../core/widgets/skeletons/fire_skeleton_system.dart';
import '../../domain/entities/annonce.dart';
import '../../domain/entities/annonce_type.dart';
import '../providers/annonce_providers.dart';
import '../../../../core/providers/auth_provider.dart';

class AddAnnonceDialog extends ConsumerStatefulWidget {
  const AddAnnonceDialog({super.key});

  @override
  ConsumerState<AddAnnonceDialog> createState() => _AddAnnonceDialogState();
}

class _AddAnnonceDialogState extends ConsumerState<AddAnnonceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  final _notesController = TextEditingController();

  AnnonceType? _selectedType;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _isPinned = false;

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedType == null) {
      await HapticHelper.warning();
      return;
    }

    await HapticHelper.medium();
    setState(() => _isLoading = true);

    try {
      final annonce = Annonce(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        churchId: ref.read(activeChurchIdProvider),
        type: _selectedType!.value,
        title: _titleController.text.trim(),
        summary: _summaryController.text.isEmpty
            ? null
            : _summaryController.text.trim(),
        content: _contentController.text.isEmpty
            ? null
            : _contentController.text.trim(),
        date: _selectedDate,
        tags: _tagsController.text.isEmpty ? null : _tagsController.text.trim(),
        isPinned: _isPinned,
        notes:
            _notesController.text.isEmpty ? null : _notesController.text.trim(),
        createdAt: DateTime.now(),
      );

      await ref.read(annonceNotifierProvider.notifier).addAnnonce(annonce);

      if (mounted) {
        await HapticHelper.success();
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Annonce ajoutée avec succès')),
          );
        }
      }
    } catch (e) {
      await HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Impossible d\'enregistrer l\'annonce')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 900),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTypeSelector(context),
                      const SizedBox(height: 16),
                      _buildTitleField(context),
                      const SizedBox(height: 16),
                      _buildSummaryField(context),
                      const SizedBox(height: 16),
                      _buildContentField(context),
                      const SizedBox(height: 16),
                      _buildDateField(context),
                      const SizedBox(height: 16),
                      _buildTagsField(context),
                      const SizedBox(height: 16),
                      _buildPinnedSwitch(context),
                      const SizedBox(height: 24),
                      _buildActions(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(gradient: context.colors.fireFusionGradient),
      child: Row(
        children: [
          const Icon(Icons.campaign, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          const Text(
            'Nouvelle Annonce',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Semantics(
            label: 'Fermer',
            button: true,
            child: IconButton(
              onPressed: () async {
                await HapticHelper.light();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type d\'annonce',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AnnonceType.allTypes.map((type) {
            final isSelected = _selectedType == type;
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(type.icon),
                  const SizedBox(width: 4),
                  Text(type.label),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) async {
                await HapticHelper.selection();
                setState(() => _selectedType = selected ? type : null);
              },
              selectedColor: context.colors.brandPrimary.withValues(alpha: 0.2),
              checkmarkColor: context.colors.brandPrimary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTitleField(BuildContext context) {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Titre *',
        hintText: 'Titre de l\'annonce',
        border: OutlineInputBorder(),
      ),
      validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
    );
  }

  Widget _buildSummaryField(BuildContext context) {
    return TextFormField(
      controller: _summaryController,
      decoration: const InputDecoration(
        labelText: 'Résumé',
        hintText: 'Bref résumé pour l\'affichage en liste',
        border: OutlineInputBorder(),
      ),
      maxLines: 2,
    );
  }

  Widget _buildContentField(BuildContext context) {
    return TextFormField(
      controller: _contentController,
      decoration: const InputDecoration(
        labelText: 'Contenu complet',
        hintText: 'Contenu détaillé de l\'annonce',
        border: OutlineInputBorder(),
      ),
      maxLines: 5,
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Semantics(
      label:
          'Sélectionner une date: ${DateFormat('dd MMMM yyyy').format(_selectedDate)}',
      button: true,
      child: GestureDetector(
        onTap: () async {
          await HapticHelper.light();
          if (!context.mounted) return;
          final date = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(1900),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            locale: const Locale('fr', 'FR'),
            helpText: 'Sélectionner la date de l\'annonce',
            cancelText: 'Annuler',
            confirmText: 'Confirmer',
          );
          if (date != null) {
            await HapticHelper.selection();
            if (mounted) {
              setState(() => _selectedDate = date);
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, size: AppSpacing.iconMd),
              const SizedBox(width: AppSpacing.smd),
              Text(
                DateFormat('dd MMMM yyyy').format(_selectedDate),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagsField(BuildContext context) {
    return TextFormField(
      controller: _tagsController,
      decoration: const InputDecoration(
        labelText: 'Tags',
        hintText: 'Séparés par des virgules',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPinnedSwitch(BuildContext context) {
    return Semantics(
      label: 'Épingler cette annonce',
      toggled: _isPinned,
      child: Row(
        children: [
          const Icon(Icons.push_pin, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.smd),
          const Text('Épingler cette annonce'),
          const Spacer(),
          Switch(
            value: _isPinned,
            onChanged: (value) async {
              await HapticHelper.selection();
              setState(() => _isPinned = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            label: 'Annuler',
            button: true,
            child: OutlinedButton(
              onPressed: () async {
                await HapticHelper.light();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Annuler'),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Semantics(
            label: 'Enregistrer l\'annonce',
            button: true,
            enabled: !_isLoading,
            child: _isLoading
                ? FireShimmer(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.colors.brandPrimary.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.brandPrimary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Enregistrer'),
                  ),
          ),
        ),
      ],
    );
  }
}
