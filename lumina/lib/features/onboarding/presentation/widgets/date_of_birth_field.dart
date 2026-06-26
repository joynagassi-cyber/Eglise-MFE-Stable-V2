import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for entering a date of birth.
/// Supports manual input (DD/MM/YYYY) and native calendar picker.
class DateOfBirthField extends ConsumerStatefulWidget {
  final void Function(DateTime) onDateSelected;
  final DateTime? initialDate;

  const DateOfBirthField({
    super.key,
    required this.onDateSelected,
    this.initialDate,
  });

  @override
  ConsumerState<DateOfBirthField> createState() => _DateOfBirthFieldState();
}

class _DateOfBirthFieldState extends ConsumerState<DateOfBirthField> {
  late final TextEditingController _controller;
  DateTime? _selectedDate;
  String? _errorText;

  // Minimum age 5 years, maximum 120 years.
  final DateTime _firstDate = DateTime(DateTime.now().year - 120);
  final DateTime _lastDate = DateTime(
    DateTime.now().year - 5,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController(
      text: widget.initialDate != null ? _formatDate(widget.initialDate!) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Format displayed as DD/MM/YYYY.
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // Parse manual input, accepting only DD/MM/YYYY.
  DateTime? _parseManualInput(String input) {
    final clean = input.replaceAll(RegExp(r'[^0-9/]'), '');
    final parts = clean.split('/');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    if (day < 1 || day > 31) return null;
    if (month < 1 || month > 12) return null;
    if (year < 1900 || year > DateTime.now().year) return null;
    try {
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  String? _validateDate(DateTime? date) {
    if (date == null) return 'Veuillez entrer votre date de naissance';
    if (date.isAfter(_lastDate)) return 'Vous devez avoir au moins 5 ans';
    if (date.isBefore(_firstDate)) return 'Date de naissance invalide';
    return null;
  }

  // Open native date picker – never leads to a blank page.
  Future<void> _openCalendarPicker() async {
    if (!mounted) return; // Protection du contexte
    FocusScope.of(context).unfocus();
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime(DateTime.now().year - 25),
        firstDate: _firstDate,
        lastDate: _lastDate,
        locale: const Locale('fr', 'FR'),
        helpText: 'Sélectionner votre date de naissance',
        cancelText: 'Annuler',
        confirmText: 'Confirmer',
        fieldLabelText: 'Date de naissance',
        fieldHintText: 'JJ/MM/AAAA',
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black87,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null && mounted) {
        setState(() {
          _selectedDate = picked;
          _controller.text = _formatDate(picked);
          _errorText = null;
        });
        widget.onDateSelected(picked);
      }
    } catch (e, stack) {
      debugPrint('❌ Erreur date picker : $e\n$stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d’ouvrir le sélecteur de date.')),
        );
      }
    }
  }

  // Handle manual keyboard input with auto‑insertion of '/' and validation.
  // Algorithme déterministe : toujours reconstruire depuis les chiffres bruts.
  void _onManualInput(String value) {
    setState(() => _errorText = null);

    // 1. Extraire uniquement les chiffres (max 8 : JJMMAAAA)
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 8) return; // Protection : max 8 chiffres

    // 2. Reconstruire le format JJ/MM/AAAA de façon déterministe
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();

    // 3. Mettre à jour le controller seulement si le texte a changé
    if (formatted != value) {
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    // 4. Valider une fois le format complet (DD/MM/YYYY = 10 caractères)
    if (formatted.length == 10) {
      final parsed = _parseManualInput(formatted);
      if (parsed != null) {
        final error = _validateDate(parsed);
        if (error == null) {
          setState(() => _selectedDate = parsed);
          widget.onDateSelected(parsed);
        } else {
          setState(() => _errorText = error);
        }
      } else {
        setState(() => _errorText = 'Format invalide. Utilisez JJ/MM/AAAA');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
        FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
      ],
      decoration: InputDecoration(
        labelText: 'Date de naissance',
        hintText: 'JJ/MM/AAAA',
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_month_outlined),
          tooltip: 'Choisir dans le calendrier',
          onPressed: _openCalendarPicker,
        ),
        errorText: _errorText,
      ),
      onChanged: _onManualInput,
      validator: (_) => _validateDate(_selectedDate),
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
    );
  }
}