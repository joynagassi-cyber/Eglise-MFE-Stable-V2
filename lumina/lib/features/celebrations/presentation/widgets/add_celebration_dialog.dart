import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/church_service.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import '../../../churches/presentation/providers/church_providers.dart';

class AddCelebrationDialog extends ConsumerStatefulWidget {
  const AddCelebrationDialog({super.key});

  @override
  ConsumerState<AddCelebrationDialog> createState() =>
      _AddCelebrationDialogState();
}

class _AddCelebrationDialogState extends ConsumerState<AddCelebrationDialog> {
  final _formKey = GlobalKey<FormState>();
  late ServiceType _selectedType;
  late DateTime _selectedDate;
  final _timeController = TextEditingController();
  final _titleController = TextEditingController();
  final _themeController = TextEditingController();
  final _preacherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedType = ServiceType.sundayService;
    _selectedDate = DateTime.now();
    _timeController.text = DateFormat('HH:mm').format(DateTime.now());
  }

  @override
  void dispose() {
    _timeController.dispose();
    _titleController.dispose();
    _themeController.dispose();
    _preacherController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('fr', 'FR'),
      helpText: 'Sélectionner la date du culte',
      cancelText: 'Annuler',
      confirmText: 'Confirmer',
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (picked != null) {
      setState(() {
        final newDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          picked.hour,
          picked.minute,
        );
        _selectedDate = newDate;
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final activeChurch = await ref.read(activeChurchProvider.future);
      if (activeChurch == null) return;
      final newService = ChurchService(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID
        churchId: activeChurch.id,
        type: _selectedType,
        date: _selectedDate,
        title: _titleController.text.isEmpty ? null : _titleController.text,
        theme: _themeController.text.isEmpty ? null : _themeController.text,
        preacherName:
            _preacherController.text.isEmpty ? null : _preacherController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        await ref.read(celebrationRepositoryProvider).createService(newService);
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Culte créé avec succès')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Impossible d\'enregistrer la célébration')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nouveau Culte'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<ServiceType>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Type de culte'),
                items: ServiceType.values.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type.label));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedType = val);
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(_selectedDate),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Heure',
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        child: Text(DateFormat('HH:mm').format(_selectedDate)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titre (Optionnel)',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _themeController,
                decoration: const InputDecoration(labelText: 'Thème'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _preacherController,
                decoration: const InputDecoration(labelText: 'Orateur'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.brandPrimary,
            foregroundColor: Colors.white,
          ),
          child: Text('Créer'),
        ),
      ],
    );
  }
}
