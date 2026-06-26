// lib/features/finance/presentation/widgets/bank_account_form_dialog.dart
import 'dart:async';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../domain/entities/financial_account.dart';
import '../../domain/services/currency_service.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import '../providers/finance_providers.dart';

class BankAccountFormDialog extends ConsumerStatefulWidget {
  final FinancialAccount? account;
  const BankAccountFormDialog({super.key, this.account});

  @override
  ConsumerState<BankAccountFormDialog> createState() =>
      _BankAccountFormDialogState();
}

class _BankAccountFormDialogState extends ConsumerState<BankAccountFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _bankNameCtrl;
  late TextEditingController _accountNumberCtrl;
  late TextEditingController _balanceCtrl;
  late TextEditingController _descCtrl;
  FinancialAccountType _type = FinancialAccountType.cash;
  String _currency = 'XAF';
  bool _isManual = false;
  bool _isLocked = false;
  bool _isSaving = false;

  bool get _isEditing => widget.account != null;

  @override
  void initState() {
    super.initState();
    final a = widget.account;
    _nameCtrl = TextEditingController(text: a?.name ?? '');
    _bankNameCtrl = TextEditingController(text: a?.bankName ?? '');
    _accountNumberCtrl = TextEditingController(text: a?.accountNumber ?? '');
    _balanceCtrl = TextEditingController(
      text: a?.balance.toStringAsFixed(0) ?? '0',
    );
    _descCtrl = TextEditingController(text: a?.description ?? '');
    _type = a?.type ?? FinancialAccountType.cash;
    _currency = a?.currency ?? 'XAF';
    _isManual = a?.isManual ?? false;
    _isLocked = a?.isLocked ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bankNameCtrl.dispose();
    _accountNumberCtrl.dispose();
    _balanceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusCard),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.colors.brandPrimary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isEditing ? Icons.edit_rounded : Icons.add_business_rounded,
                        color: context.colors.brandPrimary,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      _isEditing ? 'Modifier le compte' : 'Nouveau compte',
                      style: AppTypography.h4.copyWith(fontFamily: 'Outfit'),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.lg),

                // Nom
                _buildTextField(
                  controller: _nameCtrl,
                  label: 'Nom du compte *',
                  icon: Icons.label_outline_rounded,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Champ requis' : null,
                ),
                SizedBox(height: AppSpacing.md),

                // Type Selection
                Text(
                  'TYPE DE COMPTE',
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                DropdownButtonFormField<FinancialAccountType>(
                  value: _type,
                  style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.category_outlined, color: context.colors.brandPrimary),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: FinancialAccountType.cash,
                        child: Text('Caisse / Espèces')),
                    DropdownMenuItem(
                        value: FinancialAccountType.bank,
                        child: Text('Compte Bancaire')),
                    DropdownMenuItem(
                        value: FinancialAccountType.mobileMoney,
                        child: Text('Mobile Money')),
                  ],
                  onChanged: (v) async {
                    await HapticHelper.selection();
                    setState(() => _type = v!);
                  },
                ),
                SizedBox(height: AppSpacing.lg),

                // Mode Manuel/Auto
                Container(
                  decoration: BoxDecoration(
                    color: _isManual
                        ? context.colors.infoText.withValues(alpha: 0.05)
                        : context.colors.successText.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: (_isManual ? context.colors.infoText : context.colors.successText).withOpacity(0.2)),
                  ),
                  child: SwitchListTile(
                    value: _isManual,
                    onChanged: (v) async {
                      await HapticHelper.light();
                      setState(() => _isManual = v);
                    },
                    title: Text(
                      _isManual ? 'Compte Manuel' : 'Caisse Automatique',
                      style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _isManual
                          ? 'Le solde est géré manuellement'
                          : 'Le solde est mis à jour par les transactions',
                      style: AppTypography.bodySmall,
                    ),
                    activeColor: context.colors.infoText,
                    inactiveThumbColor: context.colors.successText,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ).withTouchTarget(),
                ),
                SizedBox(height: AppSpacing.md),

                // Verrouillage
                Container(
                  decoration: BoxDecoration(
                    color: _isLocked
                        ? context.colors.errorText.withValues(alpha: 0.05)
                        : context.colors.brandSecondary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: (_isLocked ? context.colors.errorText : context.colors.brandSecondary).withOpacity(0.2)),
                  ),
                  child: SwitchListTile(
                    value: _isLocked,
                    onChanged: (v) async {
                      await HapticHelper.warning();
                      setState(() => _isLocked = v);
                    },
                    title: Text(
                      _isLocked ? 'Compte Verrouillé' : 'Compte Ouvert',
                      style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _isLocked
                          ? 'Aucune transaction possible'
                          : 'Prêt pour les transactions',
                      style: AppTypography.bodySmall,
                    ),
                    activeColor: context.colors.errorText,
                    inactiveThumbColor: context.colors.brandSecondary,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ).withTouchTarget(),
                ),
                SizedBox(height: AppSpacing.lg),

                // Devise
                DropdownButtonFormField<String>(
                  value: _currency,
                  style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Devise',
                    prefixIcon: Icon(Icons.monetization_on_outlined, color: context.colors.brandPrimary),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  items: CurrencyService.supportedCurrencies
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) async {
                    await HapticHelper.selection();
                    setState(() => _currency = v!);
                  },
                ),
                SizedBox(height: AppSpacing.md),

                // Solde (Initial ou Actuel)
                _buildTextField(
                  controller: _balanceCtrl,
                  label: _isEditing ? 'Solde actuel' : 'Solde initial',
                  icon: Icons.account_balance_wallet_outlined,
                  keyboardType: TextInputType.number,
                  enabled: !_isEditing || _isManual,
                  helperText: _isManual
                      ? 'Édition directe autorisée'
                      : 'Mise à jour automatique',
                ),
                SizedBox(height: AppSpacing.md),

                // Bank-specific fields
                if (_type == FinancialAccountType.bank) ...[
                  _buildTextField(
                    controller: _bankNameCtrl,
                    label: 'Nom de la banque',
                    icon: Icons.account_balance_rounded,
                  ),
                  SizedBox(height: AppSpacing.md),
                  _buildTextField(
                    controller: _accountNumberCtrl,
                    label: 'N° de compte',
                    icon: Icons.numbers_rounded,
                  ),
                  SizedBox(height: AppSpacing.md),
                ],

                // Description
                _buildTextField(
                  controller: _descCtrl,
                  label: 'Description',
                  icon: Icons.notes_rounded,
                  maxLines: 2,
                ),
                SizedBox(height: AppSpacing.xl),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSaving ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('Annuler'),
                      ).withTouchTarget(),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _isSaving
                          ? Center(child: LoadingDots())
                          : FilledButton.icon(
                              onPressed: _submit,
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(0, 56),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                backgroundColor: context.colors.brandPrimary,
                              ),
                              icon: Icon(Icons.save_rounded),
                              label: Text(_isEditing ? 'Enregistrer' : 'Créer'),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool enabled = true,
    String? helperText,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      enabled: enabled,
      style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: Icon(icon, color: context.colors.brandPrimary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      validator: validator,
      onTap: () => HapticHelper.light(),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      await HapticHelper.warning();
      return;
    }
    await HapticHelper.medium();

    setState(() => _isSaving = true);
    try {
      final balance = double.tryParse(_balanceCtrl.text) ?? 0.0;

      final account = FinancialAccount(
        id: widget.account?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameCtrl.text.trim(),
        type: _type,
        currency: _currency,
        balance: balance,
        bankName:
            _bankNameCtrl.text.isNotEmpty ? _bankNameCtrl.text.trim() : null,
        accountNumber: _accountNumberCtrl.text.isNotEmpty
            ? _accountNumberCtrl.text.trim()
            : null,
        description: _descCtrl.text.isNotEmpty ? _descCtrl.text.trim() : null,
        isActive: true,
        isManual: _isManual,
        isLocked: _isLocked,
      );

      final repo = ref.read(financeRepositoryProvider);
      await repo.saveAccount(account);

      ref.invalidate(accountsProvider);

      await HapticHelper.success();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      await HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Impossible d\'enregistrer le compte bancaire'),
            backgroundColor: context.colors.errorText,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
