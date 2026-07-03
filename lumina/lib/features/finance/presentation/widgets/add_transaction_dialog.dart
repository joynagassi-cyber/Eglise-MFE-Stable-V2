// lib/features/finance/presentation/widgets/add_transaction_dialog.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/services/ocr_service.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';
import 'package:uuid/uuid.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import '../../domain/entities/enums/transaction_type.dart';
import '../../domain/entities/enums/transaction_status.dart';
import '../../domain/entities/finance_transaction.dart';
import '../../domain/entities/enums/payment_method.dart';
import '../providers/finance_providers.dart';
import '../../../invoice_capture/presentation/providers/invoice_capture_providers.dart';
import '../../../../core/providers/auth_provider.dart';
import 'package:lumina/core/providers/user_context_provider.dart';
import '../../../../core/domain/entities/enums/audit_action.dart';
import '../../domain/entities/financial_account.dart';
import 'package:lumina/core/theme/app_spacing.dart';

class AddTransactionDialog extends ConsumerStatefulWidget {
  const AddTransactionDialog({super.key});

  @override
  ConsumerState<AddTransactionDialog> createState() =>
      _AddTransactionDialogState();
}

class _AddTransactionDialogState extends ConsumerState<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionType _selectedType = TransactionType.income;
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  String? _selectedAccountId;
  final PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  File? _proofImage;
  bool _isUploading = false;

  final List<String> _incomeCategories = [
    'Dîme', 'Offrande', 'Don', 'Vente', 'Autre',
  ];
  final List<String> _expenseCategories = [
    'Loyer', 'Électricité', 'Eau', 'Salaire', 'Social', 'Mission', 'Transport', 'Entretien', 'Achat', 'Autre',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);
    final categories = _selectedType == TransactionType.income
        ? _incomeCategories
        : _expenseCategories;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: GlassCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Nouvelle Transaction',
                    style: AppTypography.h3.copyWith(fontFamily: 'Outfit'),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),

                  // --- Type Toggle ---
                  SegmentedButton<TransactionType>(
                    segments: const [
                      ButtonSegment(
                        value: TransactionType.income,
                        label: Text('Entrée'),
                        icon: Icon(Icons.add_circle_outline_rounded),
                      ),
                      ButtonSegment(
                        value: TransactionType.expense,
                        label: Text('Sortie'),
                        icon: Icon(Icons.remove_circle_outline_rounded),
                      ),
                    ],
                    selected: {_selectedType},
                    onSelectionChanged: (Set<TransactionType> newSelection) async {
                      if (newSelection.isNotEmpty) {
                        await HapticHelper.selection();
                        setState(() {
                          _selectedType = newSelection.first;
                          _selectedCategory = null;
                        });
                      }
                    },
                    style: SegmentedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  SizedBox(height: 24),

                  // --- Amount ---
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: AppTypography.h1.copyWith(
                      color: _selectedType == TransactionType.income 
                          ? context.colors.successText 
                          : context.colors.errorText,
                      fontFamily: 'Outfit',
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '0 FCFA',
                      hintStyle: TextStyle(color: context.colors.textTertiary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Requis';
                      final parsed = double.tryParse(value);
                      if (parsed == null) return 'Nombre invalide';
                      if (parsed <= 0) return 'Le montant doit être supérieur à 0';
                      return null;
                    },
                    onTap: () => HapticHelper.light(),
                  ),
                  SizedBox(height: 12),
                  Divider(),
                  SizedBox(height: 20),

                  // --- Description ---
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    icon: Icons.description_outlined,
                    validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
                  ),
                  SizedBox(height: 16),

                  // --- Date Picker ---
                  ListTile(
                    leading: Icon(Icons.calendar_today_rounded, color: context.colors.brandPrimary),
                    title: Text(
                      'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: AppTypography.bodyMedium,
                    ),
                    trailing: Icon(Icons.edit_rounded, size: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onTap: () async {
                      await HapticHelper.light();
                      if (!context.mounted) return;
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        locale: const Locale('fr', 'FR'),
                        helpText: 'Sélectionner la date',
                        cancelText: 'Annuler',
                        confirmText: 'Confirmer',
                      );
                      if (picked != null) {
                        await HapticHelper.selection();
                        setState(() => _selectedDate = picked);
                      }
                    },
                  ).withTouchTarget(),
                  SizedBox(height: 16),

                  // --- Category Dropdown ---
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Catégorie',
                      prefixIcon: Icon(Icons.category_outlined),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
                    items: categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) async {
                      await HapticHelper.selection();
                      setState(() => _selectedCategory = val);
                    },
                    validator: (value) =>
                        value == null ? 'Sélectionnez une catégorie' : null,
                  ),
                  SizedBox(height: 16),

                  // --- Account Dropdown ---
                  accountsAsync.when(
                    data: (accounts) {
                      final availableAccounts = accounts.where((a) => !a.isLocked).toList();
                      
                      if (_selectedAccountId == null && availableAccounts.isNotEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted && _selectedAccountId == null) {
                            final defaultAcc = availableAccounts.firstWhere(
                              (a) => a.id.contains('cash') || a.type == FinancialAccountType.cash,
                              orElse: () => availableAccounts.first,
                            );
                            setState(() => _selectedAccountId = defaultAcc.id);
                          }
                        });
                      }

                      return DropdownButtonFormField<String>(
                        value: _selectedAccountId,
                        decoration: const InputDecoration(
                          labelText: 'Compte / Caisse',
                          prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
                        items: availableAccounts
                            .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                            .toList(),
                        onChanged: (val) async {
                          await HapticHelper.selection();
                          setState(() => _selectedAccountId = val);
                        },
                        validator: (value) => value == null ? 'Sélectionnez un compte' : null,
                      );
                    },
                    loading: () => Center(child: LoadingDots()),
                    error: (_, __) => Text('Erreur comptes', style: TextStyle(color: context.colors.errorText)),
                  ),
                  SizedBox(height: 24),

                  // --- Proof Button ---
                  if (_proofImage != null)
                    Stack(
                      children: [
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: FileImage(_proofImage!),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(color: context.colors.borderSubtle),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            backgroundColor: context.colors.errorText,
                            radius: 18,
                            child: IconButton(
                              icon: Icon(Icons.close_rounded, size: 16, color: Colors.white),
                              tooltip: 'Supprimer la preuve',
                              onPressed: () async {
                                await HapticHelper.light();
                                setState(() => _proofImage = null);
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: () async {
                        await HapticHelper.light();
                        if (context.mounted) _showCaptureScreen(context);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: Icon(Icons.camera_alt_outlined),
                      label: Text('Ajouter une preuve / reçu'),
                    ).withTouchTarget(),
                  SizedBox(height: 32),

                  if (_isUploading)
                    Center(child: LoadingDots())
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(minimumSize: const Size(0, 56)),
                            child: Text('Annuler'),
                          ).withTouchTarget(),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: GradientButton(
                            onPressed: _submit,
                            text: 'Enregistrer',
                          ),
                        ),
                      ],
                    ),
                ],
              ),
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: context.colors.brandPrimary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
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

    setState(() => _isUploading = true);

    try {
      final transactionId = const Uuid().v4();
      final List<String> proofUrls = [];

      if (_proofImage != null) {
        final imageService = ref.read(imageCaptureServiceProvider);
        final session = await ref.read(authProvider.future);
        final userId = session.userId;
        final churchId = ref.read(activeChurchIdProvider);
        final authToken = session.accessToken ?? '';

        if (userId != null) {
          final proof = await imageService.uploadAndSave(
            file: _proofImage!,
            transactionId: transactionId,
            userId: userId,
            churchId: churchId,
            authToken: authToken,
          );
          proofUrls.add(proof.originalUrl);
        }
      }

      final transaction = FinanceTransaction(
        id: transactionId,
        amount: double.parse(_amountController.text),
        type: _selectedType,
        date: _selectedDate,
        description: _descriptionController.text,
        category: _selectedCategory,
        paymentMethod: _selectedPaymentMethod,
        accountId: _selectedAccountId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        proofImages: proofUrls,
        status: _selectedType == TransactionType.income
            ? TransactionStatus.validated
            : TransactionStatus.pending,
      );
      final repository = ref.read(financeRepositoryProvider);
      await repository.saveTransaction(transaction);

      ref.invalidate(transactionsProvider);

      final userContext = ref.read(userContextNotifierProvider).valueOrNull;
      if (userContext != null) {
        await ref.read(auditRepositoryProvider).logAction(
          action: AuditAction.insert,
          entityType: 'finance_transaction',
          entityId: transactionId,
          newData: transaction.toJson(),
          actorId: userContext.user.id,
          metadata: {
            'actor_name': userContext.user.email,
            'role_used': userContext.role.label,
            'church_id': userContext.churchId,
          },
        );
      }

      await HapticHelper.success();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      await HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Impossible de créer la transaction'),
            backgroundColor: context.colors.errorText,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showCaptureScreen(BuildContext context) {
    context.push(
      AppRoutes.financeInvoiceCapture,
      extra: (File? file, InvoiceData? extractedData) {
        if (!mounted) return;
        setState(() {
          _proofImage = file;
          if (extractedData != null) {
            _amountController.text = extractedData.total.toString();
            _descriptionController.text = extractedData.vendor;
            _selectedType = TransactionType.expense;
            
            final vendorLower = extractedData.vendor.toLowerCase();
            if (vendorLower.contains('électricité') || vendorLower.contains('electricity')) {
              _selectedCategory = 'Électricité';
            } else if (vendorLower.contains('eau') || vendorLower.contains('water')) {
              _selectedCategory = 'Eau';
            } else if (vendorLower.contains('loyer') || vendorLower.contains('rent')) {
              _selectedCategory = 'Loyer';
            } else {
              _selectedCategory = 'Achat';
            }
          }
        });
        Navigator.pop(context);
      },
    );
  }
}
