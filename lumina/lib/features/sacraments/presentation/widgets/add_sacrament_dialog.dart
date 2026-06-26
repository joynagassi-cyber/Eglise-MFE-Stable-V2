import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/sacrament.dart';
import '../../domain/entities/sacrament_type.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/sacrament_providers.dart';
import 'package:lumina/core/providers/auth_provider.dart';

class AddSacramentDialog extends ConsumerStatefulWidget {
  const AddSacramentDialog({super.key});

  @override
  ConsumerState<AddSacramentDialog> createState() => _AddSacramentDialogState();
}

class _AddSacramentDialogState extends ConsumerState<AddSacramentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _memberNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _celebrantController = TextEditingController();
  final _notesController = TextEditingController();

  SacramentType? _selectedType;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _memberNameController.dispose();
    _locationController.dispose();
    _celebrantController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedType == null) return;

    setState(() => _isLoading = true);

    try {
      final nameParts = _memberNameController.text.trim().split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final sacrament = Sacrament(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        churchId: ref.read(activeChurchIdProvider),
        type: _selectedType!,
        date: _selectedDate,
        memberId: 'temp_member_id',
        memberFirstName: firstName.isEmpty ? null : firstName,
        memberLastName: lastName.isEmpty ? null : lastName,
        location:
            _locationController.text.isEmpty ? null : _locationController.text,
        celebrant: _celebrantController.text.isEmpty
            ? null
            : _celebrantController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        createdAt: DateTime.now(),
      );

      await ref
          .read(sacramentNotifierProvider.notifier)
          .addSacrament(sacrament);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sacrement ajouté avec succès')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Une erreur est survenue lors de l\'ajout du sacrement')));
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
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
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
                      _buildDateField(context),
                      const SizedBox(height: 16),
                      _buildMemberField(context),
                      const SizedBox(height: 16),
                      _buildDetailsField(context),
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
          Icon(Icons.church, color: context.colors.textOnBrand, size: 28),
          const SizedBox(width: 16),
          Text('Ajouter un Sacrement',
            style: TextStyle(
              color: context.colors.textOnBrand,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: context.colors.textOnBrand),
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
          'Type de sacrement',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: SacramentTypeX.allTypes.map((type) {
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
              onSelected: (selected) {
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

  Widget _buildDateField(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(1900),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          locale: const Locale('fr', 'FR'),
          helpText: 'Sélectionner la date du sacrement',
          cancelText: 'Annuler',
          confirmText: 'Confirmer',
        );
        if (date != null) {
          setState(() => _selectedDate = date);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: context.colors.borderSubtle),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: context.colors.brandPrimary),
            const SizedBox(width: 12),
            Text(
              DateFormat('dd MMMM yyyy').format(_selectedDate),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberField(BuildContext context) {
    return TextFormField(
      controller: _memberNameController,
      decoration: const InputDecoration(
        labelText: 'Nom complet du membre',
        hintText: 'Jean Dupont',
        border: OutlineInputBorder(),
      ),
      validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
    );
  }

  Widget _buildDetailsField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Détails', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _locationController,
          decoration: const InputDecoration(
            labelText: 'Lieu',
            hintText: 'Église Saint-Pierre',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _celebrantController,
          decoration: const InputDecoration(
            labelText: 'Célébrant',
            hintText: 'Père Michel',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Notes',
            hintText: 'Notes supplémentaires',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.brandPrimary,
              foregroundColor: context.colors.textOnBrand,
            ),
            child: _isLoading
                ? LoadingDots(color: context.colors.textOnBrand, size: 24)
                : const Text('Enregistrer'),
          ),
        ),
      ],
    );
  }
}
