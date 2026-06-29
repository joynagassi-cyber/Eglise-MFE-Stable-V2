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
        label: const const const Text('Transaction'),
        const icon: const Icon(Icons.add_card),
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
                    loading: () => const _HeroHeaderSkeleton(),
                    error: (e, _) => Text("Erreur : $e"),
                  ),
                  const SizedBox(height: LuminaDesign.paddingLg),
                  _buildAccountBreakdown(context, ref),
const                   const const SizedBox(height: LuminaDesign.paddingLg),
                  _buildQuickActions(conteconst xt),
                  const SizedBox(height: LuminaDesign.paddingLg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("TRANSACTIONS RÉCENTES", style: LuminaDesign.labelOf(context)),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.financeHistory),
 const                        child: const Text("Voir tout"),
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
       const      ),
            loading: () => const SliverToBoxAdapter(child: _TransactionListSkeleton()),
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
            onPressed: () => _showTransferFunds(conconst text),
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

/// Skeleton du hero header (stats finance)
class _HeroHeaderSkeleton extends StatelessWidget {
  const _HeroHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return FireShimmer(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FireSkeletonAtom.textLine(
              context: context,
              widthFactor: 0.3,
              height: 12,
              margin: const EdgeInsets.only(bottom: 6),
            ),
            FireSkeletonAtom.textLine(
              context: context,
              widthFactor: 0.5,
              height: 28,
              margin: const EdgeInsets.only(bottom: 24),
            ),
            FireSkeletonAtom.rect(context: context, height: 48, radius: 12),
            const SizedBox(height: 12),
            FireSkeletonAtom.chip(context: context, width: 140, height: 24),
          ],
        ),
      ),
    );
  }
}

/// Skeleton de la liste des transactions récentes
class _TransactionListSkeleton extends StatelessWidget {
  const _TransactionListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(4, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _TransactionItemSkeleton(),
        )),
      ),
    );
  }
}

class _TransactionItemSkeleton extends StatelessWidget {
  const _TransactionItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return FireShimmer(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            FireSkeletonAtom.circle(context: context, diameter: 48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FireSkeletonAtom.textLine(
                    context: context,
                    widthFactor: 0.6,
                    height: 14,
                    margin: const EdgeInsets.only(bottom: 4),
                  ),
                  FireSkeletonAtom.textLine(
                    context: context,
                    widthFactor: 0.35,
                    height: 10,
                    margin: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            FireSkeletonAtom.textLine(
              context: context,
              widthFactor: 0.2,
              height: 16,
              margin: EdgeInsets.zero,
            ),
          ],
        ),
      ),
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
     const    Icon(icon, color: color, size: 20),
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
            child: Icon(isIncome ? Icons.add : Icons.remove, color: isIncome ? Colors.grconst een : LuminaDesign.primary),
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
