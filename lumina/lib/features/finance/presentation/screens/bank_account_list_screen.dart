// lib/features/finance/presentation/screens/bank_account_list_screen.dart
import 'dart:async';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';
import '../providers/finance_providers.dart';
import '../../domain/entities/financial_account.dart';
import '../../domain/services/currency_service.dart';
import '../widgets/transfer_funds_dialog.dart';
import '../../presentation/widgets/bank_account_form_dialog.dart';

class BankAccountListScreen extends ConsumerWidget {
  const BankAccountListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gestion Bancaire',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Transférer des fonds',
            onPressed: () {
              final accounts = accountsAsync.value ?? [];
              if (accounts.length < 2) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Il faut au moins 2 comptes pour un transfert')),
                );
                return;
              }
              _showTransferDialog(context, ref, accounts);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Nouveau compte',
            onPressed: () => _showForm(context, ref),
          ),
        ],
      ),
      body: accountsAsync.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return EmptyState(
              icon: Icons.account_balance_outlined,
              title: 'Aucun compte bancaire',
              subtitle: 'Ajoutez votre premier compte pour commencer',
              actionLabel: 'Ajouter un compte',
              onAction: () => _showForm(context, ref),
            );
          }

          final bankTotal = accounts
              .where((a) => a.type == FinancialAccountType.bank)
              .fold(0.0, (sum, a) => sum + a.balance);
          final cashTotal = accounts
              .where((a) => a.type == FinancialAccountType.cash)
              .fold(0.0, (sum, a) => sum + a.balance);
          final momoTotal = accounts
              .where((a) => a.type == FinancialAccountType.mobileMoney)
              .fold(0.0, (sum, a) => sum + a.balance);

          final totalBalance = accounts.fold<double>(
            0.0,
            (sum, a) => sum + a.balance,
          );

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    gradient: context.colors.fireFusionGradient,
                    borderRadius: AppSpacing.borderRadiusCard,
                    boxShadow: AppSpacing.shadowMd,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Disponibilité Totale',
                        style: AppTypography.labelSmall.copyWith(
                          color: context.colors.textOnBrand.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        CurrencyService.format(totalBalance, 'XAF'),
                        style: AppTypography.headingLarge.copyWith(
                          color: context.colors.textOnBrand,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Divider(color: context.colors.textOnBrand.withOpacity(0.2)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _TotalMiniCard(
                            label: 'En Banque',
                            amount: bankTotal,
                            icon: Icons.account_balance_outlined,
                          ),
                          _TotalMiniCard(
                            label: 'En Caisse',
                            amount: cashTotal,
                            icon: Icons.payments_outlined,
                          ),
                          _TotalMiniCard(
                            label: 'MoMo',
                            amount: momoTotal,
                            icon: Icons.phone_android,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _AccountCard(
                        account: accounts[index],
                        isDark: isDark,
                        onTap: () =>
                            _showForm(context, ref, account: accounts[index]),
                        onDelete: () =>
                            _deleteAccount(context, ref, accounts[index]),
                      ),
                    ),
                    childCount: accounts.length,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const SliverToBoxAdapter(
          child: ShimmerCardList(
            itemCount: 4,
            itemHeight: 180,
          ),
        ),
        error: (e, s) => SliverToBoxAdapter(
          child: EmptyState(
            icon: Icons.error_outline,
            title: 'Erreur',
            subtitle: e.toString(),
            actionLabel: 'Réessayer',
            onAction: () => ref.invalidate(accountsProvider),
          ),
        ),
      ),
    );
  }

  Future<void> _showTransferDialog(BuildContext context, WidgetRef ref,
      List<FinancialAccount> accounts) async {
    unawaited(HapticHelper.selection());
    await showDialog(
      context: context,
      builder: (_) => const TransferFundsDialog(),
    );
    ref.invalidate(accountsProvider);
  }

  Future<void> _showForm(BuildContext context, WidgetRef ref,
      {FinancialAccount? account}) async {
    unawaited(HapticHelper.selection());
    await showDialog(
      context: context,
      builder: (_) => BankAccountFormDialog(account: account),
    );
    ref.invalidate(accountsProvider);
  }

  void _deleteAccount(
    BuildContext context,
    WidgetRef ref,
    FinancialAccount account,
  ) {
    HapticHelper.warning();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce compte ?'),
        content: Text('Le compte "${account.name}" sera désactivé.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: context.colors.errorText),
            onPressed: () async {
              final repo = ref.read(financeRepositoryProvider);
              await repo.deleteAccount(account
                  .id); // Renamed to deleteAccount or similar in finance repo if needed
              ref.invalidate(accountsProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text('Supprimer',
                style: TextStyle(color: context.colors.textOnBrand)),
          ),
        ],
      ),
    );
  }
}

class _TotalMiniCard extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;

  const _TotalMiniCard({
    required this.label,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: context.colors.iconOnBrand.withOpacity(0.9), size: 18),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: context.colors.textOnBrand.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          CurrencyService.format(amount, 'XAF').replaceAll(' FCFA', ''),
          style: AppTypography.labelMedium.copyWith(
            color: context.colors.textOnBrand,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _AccountCard extends StatelessWidget {
  final FinancialAccount account;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _AccountCard({
    required this.account,
    required this.isDark,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final styles = _getAccountStyle(context, account.type);

    return Dismissible(
      key: Key(account.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: context.colors.errorText,
          borderRadius: AppSpacing.borderRadiusCard,
        ),
        child: Icon(Icons.delete, color: context.colors.iconOnBrand),
      ),
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: AppSpacing.borderRadiusCard,
          gradient: styles.gradient,
          boxShadow: [
            BoxShadow(
              color: styles.color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppSpacing.borderRadiusCard,
            child: Stack(
              children: [
                // Fond décoratif (Waves/Circle)
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    styles.icon,
                    size: 100,
                    color: context.colors.iconOnBrand.withOpacity(0.1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: context.colors.textOnBrand.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  styles.icon,
                                  color: context.colors.iconOnBrand,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              getColumn(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    account.name,
                                    style: AppTypography.labelLarge.copyWith(
                                      color: context.colors.textOnBrand,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    account.type.name.toUpperCase(),
                                    style: AppTypography.labelSmall.copyWith(
                                      color:
                                          context.colors.textOnBrand.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (account.isManual) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.textOnBrand.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.radiusXl),
                              ),
                              child: Text(
                                'Manuel',
                                style: AppTypography.labelSmall.copyWith(
                                  color: context.colors.textOnBrand,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          if (account.isLocked) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: context.colors.errorText,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.lock,
                                color: context.colors.iconOnBrand,
                                size: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            account.accountNumber ?? '****',
                            style: TextStyle(
                              color: context.colors.textOnBrand.withOpacity(0.6),
                              letterSpacing: 2,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${account.balance.toStringAsFixed(0)} F',
                            style: AppTypography.h3.copyWith(
                              color: context.colors.textOnBrand,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getColumn({
    required CrossAxisAlignment crossAxisAlignment,
    required List<Widget> children,
  }) {
    return Column(crossAxisAlignment: crossAxisAlignment, children: children);
  }

  _AccountStyle _getAccountStyle(BuildContext context, FinancialAccountType type) {
    switch (type) {
      case FinancialAccountType.bank:
        return _AccountStyle(
          gradient: context.colors.premiumFusionGradient,
          icon: Icons.account_balance_rounded,
          color: context.colors.brandSecondary,
        );
      case FinancialAccountType.cash:
        return _AccountStyle(
          gradient: context.colors.fireFusionGradient,
          icon: Icons.payments_rounded,
          color: context.colors.brandPrimary,
        );
      case FinancialAccountType.mobileMoney:
        return _AccountStyle(
          gradient: context.colors.premiumFusionGradient,
          icon: Icons.phone_android_rounded,
          color: context.colors.brandPrimary,
        );
    }
  }
}

class _AccountStyle {
  final LinearGradient gradient;
  final IconData icon;
  final Color color;

  _AccountStyle({
    required this.gradient,
    required this.icon,
    required this.color,
  });
}
