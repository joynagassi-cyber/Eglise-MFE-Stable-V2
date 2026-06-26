// lib/features/events/presentation/screens/event_form_screen.dart
// Formulaire Événement - Deep Purple Theme - MIGRATED TO DESIGN SYSTEM

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/features/events/presentation/providers/event_providers.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/features/churches/presentation/providers/church_providers.dart';
import 'package:lumina/features/events/domain/entities/event_type.dart';
import 'package:lumina/features/events/domain/entities/event.dart';

class EventFormScreen extends ConsumerStatefulWidget {
  final String? eventId;

  const EventFormScreen({super.key, this.eventId});

  @override
  ConsumerState<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends ConsumerState<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  EventType _selectedType = EventType.mass;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();

    _selectedDate = DateTime.now();
    _startTime = const TimeOfDay(hour: 10, minute: 0);
    _endTime = const TimeOfDay(hour: 12, minute: 0);

    if (widget.eventId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadEventData());
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final preSelectedDate = ref.read(selectedDateProvider);
        setState(() => _selectedDate = preSelectedDate);
      });
    }
  }

  Future<void> _loadEventData() async {
    final repository = ref.read(eventRepositoryProvider);
    final event = await repository.getEventById(widget.eventId!);
    if (event != null) {
      setState(() {
        _titleController.text = event.title;
        _descriptionController.text = event.description ?? '';
        _locationController.text = event.location ?? '';
        _selectedType = event.type;
        _selectedDate = event.date;
        _startTime = TimeOfDay.fromDateTime(event.date);
        _endTime = event.endDate != null
            ? TimeOfDay.fromDateTime(event.endDate!)
            : TimeOfDay(hour: _startTime.hour + 2, minute: _startTime.minute);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.eventId == null ? 'Nouvel Événement' : 'Modifier Événement',
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 100),
              child: _buildTextField(
                controller: _titleController,
                label: 'Titre *',
                icon: Icons.event_rounded,
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
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDatePicker(context, isDark, theme),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildTimePicker(
                      context,
                      'Début',
                      _startTime,
                      (picked) => setState(() => _startTime = picked),
                      isDark,
                      theme,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildTimePicker(
                      context,
                      'Fin',
                      _endTime,
                      (picked) => setState(() => _endTime = picked),
                      isDark,
                      theme,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 400),
              child: _buildTextField(
                controller: _locationController,
                label: 'Lieu',
                icon: Icons.location_on_rounded,
                isDark: isDark,
                theme: theme,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 500),
              child: _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description_rounded,
                maxLines: 4,
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
                    : 'Enregistrer l\'événement',
                button: true,
                enabled: !_isLoading,
                child: GradientButton(
                  text: _isLoading ? 'Enregistrement...' : 'Enregistrer',
                  icon: Icons.save_rounded,
                  gradient: LinearGradient(
                    colors: [
                      context.colors.brandPrimaryFire,
                      context.colors.brandPrimaryFire.withValues(alpha: 0.8),
                    ],
                  ),
                  onPressed: _isLoading ? null : _saveEvent,
                ),
              ),
            ),
          ],
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
          labelStyle: AppTypography.bodyMedium.copyWith(
            color: context.colors.textTertiary,
          ),
          prefixIcon: icon != null
              ? Icon(icon,
                  color: context.colors.brandPrimaryFire, size: AppSpacing.iconMd)
              : null,
          alignLabelWithHint: maxLines > 1,
          filled: true,
          fillColor: context.colors.bgCard,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 18, // Pour assurer une hauteur tactile proche de 56px
          ),
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
            borderSide:
                BorderSide(color: context.colors.brandPrimaryFire, width: 2),
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
          'Type d\'événement',
          style: AppTypography.labelMedium.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: EventType.allTypes.map((type) {
              final isSelected = _selectedType == type;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Semantics(
                  label: 'Type: ${type.label}',
                  button: true,
                  selected: isSelected,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        await HapticHelper.selection();
                        setState(() => _selectedType = type);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: AppSpacing.animationFast,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient:
                              isSelected ? context.colors.fireFusionGradient : null,
                          color: isSelected
                              ? null
                              : context.colors.glassDark.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? context.colors.brandPrimaryFire
                                : context.colors.borderSubtle,
                          ),
                        ),
                        child: Text(
                          type.label,
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? context.colors.textOnBrand
                                : context.colors.textSecondary,
                          ),
                        ),
                      ),
                    ).withTouchTarget(),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, bool isDark, ThemeData theme) {
    return Semantics(
      label:
          'Sélectionner la date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await HapticHelper.light();
            if (!context.mounted) return;
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              locale: const Locale('fr', 'FR'),
              helpText: 'Sélectionner la date',
              cancelText: 'Annuler',
              confirmText: 'Confirmer',
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: context.colors.brandPrimaryFire,
                      onPrimary: context.colors.textOnBrand,
                      surface: context.colors.bgCard,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (mounted && picked != null) {
              await HapticHelper.medium();
              if (mounted) {
                setState(() => _selectedDate = picked);
              }
            }
          },
          borderRadius: AppSpacing.borderRadiusMd,
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded,
                  color: context.colors.brandPrimaryFire,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: AppTypography.labelSmall.copyWith(
                        color: context.colors.textTertiary,
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(_selectedDate),
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).withTouchTarget(),
      ),
    );
  }

  Widget _buildTimePicker(
    BuildContext context,
    String label,
    TimeOfDay time,
    ValueChanged<TimeOfDay> onPicked,
    bool isDark,
    ThemeData theme,
  ) {
    return Semantics(
      label: 'Sélectionner l\'heure de $label: ${time.format(context)}',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await HapticHelper.light();
            if (!context.mounted) return;
            final picked = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (mounted && picked != null) {
              await HapticHelper.medium();
              if (mounted) {
                onPicked(picked);
              }
            }
          },
          borderRadius: AppSpacing.borderRadiusMd,
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              children: [
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    color: context.colors.textTertiary,
                  ),
                ),
                Text(
                  time.format(context),
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ).withTouchTarget(),
      ),
    );
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) {
      await HapticHelper.warning();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final startDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _startTime.hour,
        _startTime.minute,
      );

      final endDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _endTime.hour,
        _endTime.minute,
      );

      final actions = ref.read(eventActionsProvider);

      if (widget.eventId == null) {
        final newEvent = Event(
          id: '', // Will be generated by repository
          churchId: ref.read(activeChurchProvider).value?.id ?? '',
          title: _titleController.text,
          date: startDateTime,
          endDate: endDateTime,
          type: _selectedType,
          location: _locationController.text.isNotEmpty
              ? _locationController.text
              : null,
          description: _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await actions.createEvent(newEvent);
      } else {
        final repo = ref.read(eventRepositoryProvider);
        final original = await repo.getEventById(widget.eventId!);
        if (original != null) {
          await actions.updateEvent(
            original.copyWith(
              churchId: original.churchId,
              title: _titleController.text,
              date: startDateTime,
              endDate: endDateTime,
              type: _selectedType,
              location: _locationController.text.isNotEmpty
                  ? _locationController.text
                  : null,
              description: _descriptionController.text.isNotEmpty
                  ? _descriptionController.text
                  : null,
              updatedAt: DateTime.now(),
            ),
          );
        }
      }

      await HapticHelper.success();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: context.colors.textOnBrand),
                const SizedBox(width: 8),
                Text(
                  widget.eventId == null
                      ? 'Événement créé'
                      : 'Événement mis à jour',
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
        context.pop();
      }
    } catch (e) {
      await HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Impossible d\'enregistrer l\'événement'),
            backgroundColor: context.colors.errorText,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
