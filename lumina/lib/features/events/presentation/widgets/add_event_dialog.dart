import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/event_type.dart';

class AddEventDialog extends StatefulWidget {
  final Function(Event)? onSave;
  final String churchId;

  const AddEventDialog({super.key, this.onSave, required this.churchId});

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _maxParticipantsController = TextEditingController();
  final _estimatedBudgetController = TextEditingController();
  final _notesController = TextEditingController();

  EventType? _selectedType;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _maxParticipantsController.dispose();
    _estimatedBudgetController.dispose();
    _notesController.dispose();
    super.dispose();
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTypeSelector(context),
                      SizedBox(height: 16),
                      _buildDateField(context),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _titleController,
                        label: 'Titre *',
                        icon: Icons.title,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        maxLines: 3,
                        icon: Icons.description,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildNumberField(
                              controller: _maxParticipantsController,
                              label: 'Participants max',
                              icon: Icons.people,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildNumberField(
                              controller: _estimatedBudgetController,
                              label: 'Budget estimé',
                              icon: Icons.attach_money,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _locationController,
                        label: 'Lieu',
                        icon: Icons.location_on,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _notesController,
                        label: 'Notes',
                        maxLines: 3,
                        icon: Icons.notes,
                      ),
                      SizedBox(height: 24),
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
          Icon(Icons.event, color: context.colors.textOnBrand, size: 28),
          SizedBox(width: 16),
          Text(
            'Ajouter un événement',
            style: TextStyle(
              color: context.colors.textOnBrand,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
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
        Text(
          'Type d\'événement *',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: context.colors.textPrimary),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: EventType.allTypes.map((type) {
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(type.icon, style: const TextStyle(fontSize: 18)),
                  SizedBox(width: 4),
                  Text(type.label),
                ],
              ),
              selected: _selectedType == type,
              onSelected: (selected) {
                setState(() {
                  _selectedType = selected ? type : null;
                });
              },
              selectedColor: context.colors.brandPrimary.withValues(alpha: 0.2),
              checkmarkColor: context.colors.brandPrimary,
              labelStyle: TextStyle(
                color: _selectedType == type ? context.colors.brandPrimary : context.colors.textSecondary,
                fontWeight: _selectedType == type ? FontWeight.bold : null,
              ),
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
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          locale: const Locale('fr', 'FR'),
          helpText: 'Sélectionner la date de l\'événement',
          cancelText: 'Annuler',
          confirmText: 'Confirmer',
        );
        if (date != null) {
          setState(() {
            _selectedDate = date;
          });
        }
      },
      child: IgnorePointer(
        child: TextField(
          controller: TextEditingController(
            text: _selectedDate != null
                ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                : '',
          ),
          decoration: InputDecoration(
            labelText: 'Date *',
            hintText: 'JJ/MM/YYYY',
            prefixIcon: Icon(Icons.calendar_today),
            filled: true,
            fillColor: Theme.of(context).cardTheme.color,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18),
        filled: true,
        fillColor: Theme.of(context).cardTheme.color,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      maxLines: maxLines,
      validator: label.contains('*')
          ? (value) => value?.isEmpty ?? true ? 'Champ requis' : null
          : null,
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18),
        filled: true,
        fillColor: Theme.of(context).cardTheme.color,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annuler'),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.brandPrimary,
              foregroundColor: context.colors.textOnBrand,
            ),
            child: Text('Créer'),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedType != null) {
      final newEvent = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        churchId: widget.churchId,
        type: _selectedType!,
        date: _selectedDate ?? DateTime.now(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        estimatedParticipants: _parseNumber(_maxParticipantsController.text),
        estimatedBudget: _parseNumber(
          _estimatedBudgetController.text,
        )?.toDouble(),
        notes: _notesController.text.trim(),
        status: 'PLANIFIE',
        color: '#0066FF',
        createdAt: DateTime.now(),
      );

      Navigator.of(context).pop(newEvent);

      if (widget.onSave != null) {
        widget.onSave!(newEvent);
      }
    }
  }

  int? _parseNumber(String value) {
    if (value.isEmpty) return null;
    return int.tryParse(value);
  }
}
