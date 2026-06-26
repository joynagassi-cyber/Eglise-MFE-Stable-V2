import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/widgets/modern_filter_chip.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../domain/entities/enums/transaction_type.dart';
import '../providers/transaction_history_provider.dart';

class TransactionFilterSheet extends StatefulWidget {
  final TransactionFilters initialFilters;
  final Function(TransactionFilters) onApply;

  const TransactionFilterSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
  });

  @override
  State<TransactionFilterSheet> createState() => _TransactionFilterSheetState();
}

class _TransactionFilterSheetState extends State<TransactionFilterSheet> {
  late TransactionType? _selectedType;
  late DateTime? _startDate;
  late DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialFilters.type;
    _startDate = widget.initialFilters.startDate;
    _endDate = widget.initialFilters.endDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle indicator
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: context.colors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filtres', style: theme.textTheme.titleLarge),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedType = null;
                    _startDate = null;
                    _endDate = null;
                  });
                },
                child: const Text('Réinitialiser'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Type section
          Text('Type de transaction', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              ModernFilterChip(
                label: 'Tout',
                selected: _selectedType == null,
                color: context.colors.brandPrimary,
                onSelected: (selected) => setState(() => _selectedType = null),
              ),
              ModernFilterChip(
                label: 'Revenus',
                selected: _selectedType == TransactionType.income,
                color: context.colors.successText,
                onSelected: (selected) =>
                    setState(() => _selectedType = TransactionType.income),
              ),
              ModernFilterChip(
                label: 'Dépenses',
                selected: _selectedType == TransactionType.expense,
                color: context.colors.errorText,
                onSelected: (selected) =>
                    setState(() => _selectedType = TransactionType.expense),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Text('Période', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(
                    _startDate != null
                        ? DateFormat('dd/MM/yy').format(_startDate!)
                        : 'Début',
                  ),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      locale: const Locale('fr', 'FR'),
                      helpText: 'Date de début',
                      cancelText: 'Annuler',
                      confirmText: 'Confirmer',
                    );
                    if (date != null) setState(() => _startDate = date);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(
                    _endDate != null
                        ? DateFormat('dd/MM/yy').format(_endDate!)
                        : 'Fin',
                  ),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _endDate ?? DateTime.now(),
                      firstDate: _startDate ?? DateTime(2020),
                      lastDate: DateTime.now(),
                      locale: const Locale('fr', 'FR'),
                      helpText: 'Date de fin',
                      cancelText: 'Annuler',
                      confirmText: 'Confirmer',
                    );
                    if (date != null) setState(() => _endDate = date);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedType = null;
                      _startDate = null;
                      _endDate = null;
                    });
                  },
                  child: const Text('Réinitialiser'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.brandPrimary,
                    foregroundColor: context.colors.textOnBrand,
                  ),
                  onPressed: () async {
                    await HapticHelper.success();
                    widget.onApply(
                      TransactionFilters(
                        type: _selectedType,
                        startDate: _startDate,
                        endDate: _endDate,
                      ),
                    );
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Appliquer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
