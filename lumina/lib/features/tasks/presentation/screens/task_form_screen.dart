// lib/features/tasks/presentation/screens/task_form_screen.dart

import 'dart:async';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/tasks_provider.dart';
import '../../domain/entities/task.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../../../core/providers/auth_provider.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final String? taskId;

  const TaskFormScreen({super.key, this.taskId});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  TaskType _type = TaskType.general;
  TaskStatus _status = TaskStatus.pending;
  TaskPriority _priority = TaskPriority.normal;
  DateTime? _dueDate;
  String? _assignedToId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    if (widget.taskId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final fetchedTask = await ref.read(taskProvider(widget.taskId!).future);
        if (fetchedTask != null && mounted) {
          setState(() {
            _titleController.text = fetchedTask.title;
            _descriptionController.text = fetchedTask.description ?? '';
            _type = fetchedTask.type;
            _status = fetchedTask.status;
            _priority = fetchedTask.priority;
            _dueDate = fetchedTask.dueDate;
            _assignedToId = fetchedTask.assignedToId;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      await HapticHelper.warning();
      return;
    }

    await HapticHelper.medium();
    final churchId = ref.read(activeChurchIdProvider);
    final now = DateTime.now();

    final task = Task(
      id: widget.taskId ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      type: _type,
      status: _status,
      priority: _priority,
      dueDate: _dueDate,
      assignedToId: _assignedToId,
      churchId: churchId,
      createdAt: now,
      updatedAt: now,
    );

    if (widget.taskId == null) {
      await ref.read(tasksControllerProvider.notifier).createTask(task);
    } else {
      await ref.read(tasksControllerProvider.notifier).updateTask(task);
    }

    await HapticHelper.success();
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.taskId == null ? 'Nouvelle Tâche' : 'Modifier la Tâche',
          style: AppTypography.h3.copyWith(fontFamily: 'Outfit'),
        ),
        actions: [
          if (widget.taskId != null)
            Semantics(
              label: 'Supprimer la tâche',
              button: true,
              child: Tooltip(
                message: 'Supprimer',
                child: IconButton(
                  icon: Icon(Icons.delete_outline_rounded,
                      color: context.colors.errorText),
                  onPressed: () async {
                    await HapticHelper.warning();
                    if (!context.mounted) return;
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Supprimer ?'),
                        content: Text(
                            'Voulez-vous vraiment supprimer cette tâche ?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('Annuler')).withTouchTarget(),
                          TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('Supprimer',
                                  style: TextStyle(color: context.colors.errorText))).withTouchTarget(),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await HapticHelper.medium();
                      await ref
                          .read(tasksControllerProvider.notifier)
                          .deleteTask(widget.taskId!);
                      if (!context.mounted) return;
                      context.pop();
                    }
                  },
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _titleController,
                label: 'Titre',
                hintText: 'ex: Préparer le culte',
                icon: Icons.title_rounded,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Champ requis' : null,
              ),
              SizedBox(height: AppSpacing.md),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description_outlined,
                maxLines: 3,
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'PARAMÈTRES',
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: context.colors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown<TaskType>(
                      label: 'Type',
                      value: _type,
                      items: TaskType.values,
                      onChanged: (v) => setState(() => _type = v!),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildDropdown<TaskPriority>(
                      label: 'Priorité',
                      value: _priority,
                      items: TaskPriority.values,
                      onChanged: (v) => setState(() => _priority = v!),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              _buildDropdown<TaskStatus>(
                label: 'Statut',
                value: _status,
                items: TaskStatus.values,
                onChanged: (v) => setState(() => _status = v!),
              ),
              SizedBox(height: AppSpacing.md),
              ListTile(
                title: Text('Date d\'échéance'),
                subtitle: Text(_dueDate == null
                    ? 'Non définie'
                    : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'),
                trailing: Icon(Icons.calendar_today_rounded),
                onTap: () async {
                  await HapticHelper.light();
                  if (!context.mounted) return;
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    locale: const Locale('fr', 'FR'),
                    helpText: 'Sélectionner la date d\'échéance',
                    cancelText: 'Annuler',
                    confirmText: 'Confirmer',
                  );
                  if (picked != null) {
                    await HapticHelper.selection();
                    setState(() => _dueDate = picked);
                  }
                },
              ).withTouchTarget(),
              SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.brandPrimary,
                    foregroundColor: context.colors.textOnBrand,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Enregistrer', 
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ).withTouchTarget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: context.colors.brandPrimary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      validator: validator,
      onTap: () => HapticHelper.light(),
    );
  }

  Widget _buildDropdown<T extends Enum>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
      items: items
          .map((e) => DropdownMenuItem(
              value: e, child: Text(e.name.toUpperCase())))
          .toList(),
      onChanged: (v) async {
        await HapticHelper.selection();
        onChanged(v);
      },
    );
  }
}
