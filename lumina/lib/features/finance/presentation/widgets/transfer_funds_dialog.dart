// lib/features/finance/presentation/widgets/transfer_funds_dialog.dart
import 'dart:async';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import '../../domain/entities/financial_account.dart';
import '../providers/finance_providers.dart';
import '../../../../core/providers/user_context_provider.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';

class TransferFundsDialog extends ConsumerStatefulWidget {
  const TransferFundsDialog({super.key});

  @override
  ConsumerState<TransferFundsDialog> createState() =>
      _TransferFundsDialogState();
}

class _TransferFundsDialogState extends ConsumerState<TransferFundsDialog> {
  final _formKey = GlobalKey<FormState>();
  FinancialAccount? _fromAccount;
  FinancialAccount? _toAccount;
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusCard),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.swap_horiz, color: context.colors.brandPrimary),
                  const SizedBox(width: 8),
                  Text(
                    'Transfert de fonds',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              accountsAsync.when(
                data: (accounts) {
                  final autoAccounts = accounts
                      .where((a) => !a.isManual && !a.isLocked)
                      .toList();
                  return Column(
                    children: [
                      DropdownButtonFormField<FinancialAccount>(
                        value: _fromAccount,
                        decoration: const InputDecoration(
                          labelText: 'Source (Débiter)',
                          prefixIcon: Icon(Icons.outbox),
                        ),
                        items: autoAccounts
                            .map((a) => DropdownMenuItem(
                                  value: a,
                                  child: Text(
                                      '${a.name} (${a.balance.toStringAsFixed(0)})'),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _fromAccount = v),
                        validator: (v) => v == null ? 'Champ requis' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Icon(Icons.arrow_downward,
                          color: context.colors.textTertiary),
                      const SizedBox(height: AppSpacing.md),
                      DropdownButtonFormField<FinancialAccount>(
                        value: _toAccount,
                        decoration: const InputDecoration(
                          labelText: 'Destination (Créditer)',
                          prefixIcon: Icon(Icons.inbox),
                        ),
                        items: autoAccounts
                            .map((a) => DropdownMenuItem(
                                  value: a,
                                  child: Text(
                                      '${a.name} (${a.balance.toStringAsFixed(0)})'),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _toAccount = v),
                        validator: (v) {
                          if (v == null) return 'Champ requis';
                          if (v.id == _fromAccount?.id) {
                            return 'Source et destination identiques';
                          }
                          return null;
                        },
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: LoadingState()),
                error: (e, s) => const Text('Impossible de charger les comptes'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _amountCtrl,
                decoration: const InputDecoration(
                  labelText: 'Montant',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Champ requis';
                  final amount = double.tryParse(v);
                  if (amount == null || amount <= 0) return 'Montant invalide';
                  if (_fromAccount != null && amount > _fromAccount!.balance) {
                    return 'Solde insuffisant';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Motif / Description',
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _isSaving ? null : _submit,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: LoadingDots(size: 24),
                          )
                        : const Icon(Icons.send),
                    label: const Text('Effectuer'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    unawaited(HapticHelper.success());

    setState(() => _isSaving = true);
    try {
      final userContext = ref.read(userContextNotifierProvider).value;
      final churchId = userContext?.activeChurchId ?? '';
      final userId = userContext?.user.id ?? '';

      final repo = ref.read(financeRepositoryProvider);
      final result = await repo.transferFunds(
        fromAccountId: _fromAccount!.id,
        toAccountId: _toAccount!.id,
        amount: double.parse(_amountCtrl.text),
        note: _descCtrl.text.trim(),
        churchId: churchId,
        createdBy: userId,
      );

      result.fold(
        (failure) => throw Exception(failure.message),
        (_) {
          ref.invalidate(accountsProvider);
          ref.invalidate(transactionsProvider);
          if (mounted) Navigator.pop(context);
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Impossible d\'effectuer le virement'),
            backgroundColor: context.colors.errorText,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
