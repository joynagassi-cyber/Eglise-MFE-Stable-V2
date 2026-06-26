import "package:lumina/core/widgets/widgets.dart";
import 'package:flutter/material.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import '../providers/finance_providers.dart';
import '../widgets/add_transaction_dialog.dart';
import '../../domain/entities/finance_transaction.dart';
import '../../domain/entities/enums/transaction_type.dart';
import '../../../dashboard/presentation/widgets/main_drawer.dart';
import '../widgets/v2/finance_glass_hero_header.dart';
import '../widgets/transfer_funds_dialog.dart';
import '../../presentation/widgets/bank_account_form_dialog.dart';
import '../../domain/entities/financial_account.dart';
import '../../../../core/providers/auth_provider.dart';

class FinanceDashboardScreen extends ConsumerWidget {
  const FinanceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(financeStatsProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final userSession = ref.watch(authProvider).valueOrNull;
    final firstName = userSession?.name?.split(' ').first ?? 'Économe';

    return LuminaPage(
      title: 'Finances • $firstName',
      drawer: const MainDrawer(),
      onRefresh: () async {
        ref.invalidate(financeStatsProvider);
        ref.invalidate(transactionsProvider);
        ref.invalidate(accountsProvider);
      },
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTransaction(context),
        label: const Text('Transaction'),
        icon: const Icon(Icons.add_card),
        backgroundColor: LuminaDesign.primary,
        foregroundColor: Colors.white,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(LuminaDesign.paddingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  statsAsync.when(
                    data: (stats) => FinanceGlassHeroHeader(stats: stats),
                    loading: () => const LoadingState(),
                    error: (e, _) => Text("Erreur : $e"),
                  ),
                  const SizedBox(height: LuminaDesign.paddingLg),
                  _buildAccountBreakdown(context, ref),
                  const SizedBox(height: LuminaDesign.paddingLg),
                  _buildQuickActions(context),
                  const SizedBox(height: LuminaDesign.paddingLg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("TRANSACTIONS RÉCENTES", style: LuminaDesign.labelOf(context)),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.financeHistory),
                        child: const Text("Voir tout"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          transactionsAsync.when(
            data: (transactions) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: LuminaDesign.paddingMd),
                  child: _TransactionCard(transaction: transactions[index]),
                ),
                childCount: transactions.length,
              ),
            ),
            loading: () => const SliverToBoxAdapter(child: LoadingState()),
            error: (e, _) => SliverToBoxAdapter(child: Center(child: Text("Erreur : $e"))),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  void _showAddTransaction(BuildContext context) {
    showDialog(context: context, builder: (context) => const AddTransactionDialog());
  }

  void _showAddAccount(BuildContext context) {
    showDialog(context: context, builder: (context) => const BankAccountFormDialog());
  }

  void _showTransferFunds(BuildContext context) {
    showDialog(context: context, builder: (context) => const TransferFundsDialog());
  }

  Widget _buildAccountBreakdown(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);
    return accountsAsync.when(
      data: (accounts) {
        if (accounts.isEmpty) return const SizedBox.shrink();
        final bankTotal = accounts.where((a) => a.type == FinancialAccountType.bank).fold(0.0, (sum, a) => sum + a.balance);
        final cashTotal = accounts.where((a) => a.type == FinancialAccountType.cash).fold(0.0, (sum, a) => sum + a.balance);
        return LuminaCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AccountStat(label: "Banque", amount: bankTotal, icon: Icons.account_balance, color: LuminaDesign.accent),
              _AccountStat(label: "Caisse", amount: cashTotal, icon: Icons.payments, color: Colors.green),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LuminaButton(
            label: "Transfert",
            icon: Icons.swap_horiz,
            onPressed: () => _showTransferFunds(context),
          ),
        ),
        const SizedBox(width: LuminaDesign.paddingMd),
        Expanded(
          child: LuminaButton(
            label: "Comptes",
            icon: Icons.account_balance_wallet,
            onPressed: () => _showAddAccount(context),
          ),
        ),
      ],
    );
  }
}

class _AccountStat extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;

  const _AccountStat({required this.label, required this.amount, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(label, style: LuminaDesign.labelOf(context)),
        Text("${amount.toInt()} F", style: LuminaDesign.h2Of(context).copyWith(fontSize: 16)),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final FinanceTransaction transaction;
  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    return LuminaCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: (isIncome ? Colors.green : LuminaDesign.primary).withOpacity(0.1),
            child: Icon(isIncome ? Icons.add : Icons.remove, color: isIncome ? Colors.green : LuminaDesign.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.description, style: LuminaDesign.bodyLargeOf(context).copyWith(fontWeight: FontWeight.bold)),
                Text(DateFormat('dd MMM yyyy').format(transaction.date), style: LuminaDesign.labelOf(context)),
              ],
            ),
          ),
          Text(
            "${isIncome ? '+' : '-'} ${transaction.amount.toInt()} F",
            style: LuminaDesign.h2Of(context).copyWith(fontSize: 16, color: isIncome ? Colors.green : LuminaDesign.primary),
          ),
        ],
      ),
    );
  }
}
