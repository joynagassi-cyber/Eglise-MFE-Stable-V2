// lib/features/finance/presentation/widgets/budget_form_dialog.dart
// Formulaire de création de budget

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumina/features/rubriques/presentation/providers/category_providers.dart';
import 'package:lumina/features/rubriques/domain/entities/enums/category_type.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../domain/entities/budget.dart';
import '../../domain/entities/enums/budget_period.dart';
import '../providers/budget_providers.dart';

class BudgetFormDialog extends ConsumerStatefulWidget {
  final int year;
  final BudgetPeriod period;

  const BudgetFormDialog({super.key, required this.year, required this.period});

  @override
  ConsumerState<BudgetFormDialog> createState() => _BudgetFormDialogState();
}

class _BudgetFormDialogState extends ConsumerState<BudgetFormDialog> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedCategoryId;
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  int? _selectedMonth;
  int? _selectedQuarter;

  ProviderListenable<dynamic>? get categoryListProvider =>
      rootCategoriesProvider(CategoryType.expense);

  @override
  void initState() {
    super.initState();
    // Default values
    if (widget.period == BudgetPeriod.monthly) {
      _selectedMonth = DateTime.now().month;
    } else if (widget.period == BudgetPeriod.quarterly) {
      _selectedQuarter = (DateTime.now().month / 3).ceil();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListProvider!);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusCard),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.colors.brandPrimary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.account_balance_wallet_rounded,
                          color: context.colors.brandPrimary, size: 20),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Nouveau Budget',
                      style: AppTypography.h4.copyWith(fontFamily: 'Outfit'),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.lg),

                // Période (Info only)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: context.colors.bgCardLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.colors.borderSubtle.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          size: 16, color: context.colors.brandPrimary),
                      SizedBox(width: 12),
                      Text(
                        'Période: ${widget.period.label} ${widget.year}',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.lg),

                // Sélecteur Catégorie
                categoriesAsync.when(
                  data: (categories) => DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Catégorie *',
                      prefixIcon: Icon(Icons.category_outlined),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
                    value: _selectedCategoryId,
                    items: categories
                        .where((c) => c.type == 'expense')
                        .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                        .toList(),
                    onChanged: (value) async {
                      await HapticHelper.selection();
                      setState(() => _selectedCategoryId = value);
                    },
                    validator: (value) => value == null
                        ? 'Veuillez sélectionner une catégorie'
                        : null,
                  ),
                  loading: () => Center(child: LoadingDots()),
                  error: (e, s) => Text('Erreur catégories: $e',
                      style: TextStyle(color: context.colors.errorText)),
                ),
                SizedBox(height: AppSpacing.md),

                // Sélecteur Mois/Trimestre si nécessaire
                if (widget.period == BudgetPeriod.monthly)
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Mois *',
                      prefixIcon: Icon(Icons.calendar_month_outlined),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
                    value: _selectedMonth,
                    items: List.generate(12, (index) {
                      final month = index + 1;
                      return DropdownMenuItem(
                        value: month,
                        child: Text(_getMonthName(month)),
                      );
                    }),
                    onChanged: (value) async {
                      await HapticHelper.selection();
                      setState(() => _selectedMonth = value);
                    },
                  ),

                if (widget.period == BudgetPeriod.quarterly)
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Trimestre *',
                      prefixIcon: Icon(Icons.view_quilt_outlined),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
                    value: _selectedQuarter,
                    items: List.generate(4, (index) {
                      final quarter = index + 1;
                      return DropdownMenuItem(
                        value: quarter,
                        child: Text('Trimestre $quarter'),
                      );
                    }),
                    onChanged: (value) async {
                      await HapticHelper.selection();
                      setState(() => _selectedQuarter = value);
                    },
                  ),

                if (widget.period != BudgetPeriod.annual)
                  SizedBox(height: AppSpacing.md),

                // Montant Prévu
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Montant Prévu (FCFA) *',
                    prefixIcon: Icon(Icons.payments_outlined),
                    suffixText: 'FCFA',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  ),
                  style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Montant requis';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Montant invalide';
                    }
                    return null;
                  },
                  onTap: () => HapticHelper.light(),
                ),
                SizedBox(height: AppSpacing.md),

                // Notes
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (Optionnel)',
                    prefixIcon: Icon(Icons.description_outlined),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  ),
                  style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
                  maxLines: 2,
                  onTap: () => HapticHelper.light(),
                ),
                SizedBox(height: AppSpacing.xl),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          minimumSize: const Size(0, 56),
                        ),
                        child: Text('Annuler'),
                      ).withTouchTarget(),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.brandPrimary,
                          foregroundColor: context.colors.textOnBrand,
                          minimumSize: const Size(0, 56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('Enregistrer'),
                      ).withTouchTarget(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
    ];
    return months[month - 1];
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await HapticHelper.medium();
      final churchId = ref.read(activeChurchIdProvider);

      final budget = Budget.create(
        churchId: churchId,
        categoryId: _selectedCategoryId!,
        period: widget.period,
        year: widget.year,
        month: widget.period == BudgetPeriod.monthly ? _selectedMonth : null,
        quarter:
            widget.period == BudgetPeriod.quarterly ? _selectedQuarter : null,
        plannedAmount: double.parse(_amountController.text),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      await ref.read(budgetActionsProvider.notifier).saveBudget(budget);

      await HapticHelper.success();
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Budget créé avec succès'),
            backgroundColor: context.colors.successText,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      await HapticHelper.warning();
    }
  }
}
