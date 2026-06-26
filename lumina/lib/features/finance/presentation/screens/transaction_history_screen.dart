import 'dart:async';
import 'package:lumina/core/extensions/context_extension.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../providers/transaction_history_provider.dart';
import '../widgets/transaction_list_item.dart';
import '../widgets/transaction_stats_cards.dart';
import '../widgets/transaction_filter_sheet.dart';
import '../../domain/entities/finance_transaction.dart';
import '../../../../core/logging/app_logger.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  TransactionFilters _filters = const TransactionFilters();
  Timer? _debounce;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(transactionHistoryProvider.notifier).fetchNextPage();
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final newFilters = TransactionFilters(
        type: _filters.type,
        startDate: _filters.startDate,
        endDate: _filters.endDate,
        category: _filters.category,
        searchQuery: query.isEmpty ? null : query,
      );
      setState(() => _filters = newFilters);
      ref.read(transactionHistoryProvider.notifier).applyFilters(newFilters);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final historyState = ref.watch(transactionHistoryProvider);
    final stats = ref.watch(totalTransactionStatsProvider);

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text('Historique', style: AppTypography.h3),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppSpacing.sm),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colors.brandPrimary,
                  context.colors.brandPrimary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: context.colors.brandPrimary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.filter_list, color: context.colors.textOnBrand),
              onPressed: _showFilterSheet,
              tooltip: 'Filtres',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.colors.brandPrimary.withValues(alpha: 0.05),
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.2, 1.0],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await HapticHelper.light();
            await ref.read(transactionHistoryProvider.notifier).refresh();
          },
          child: CustomScrollView(
            controller: _scrollController,
            key: const PageStorageKey('transaction_history_scroll'),
            slivers: [
              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    0,
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher (montant, description...)',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: theme.cardColor.withValues(alpha: 0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
              ),

              // Stats Cards
              SliverToBoxAdapter(
                child: AnimatedEntrance.fromBottom(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: stats.when(
                      data: (s) => TransactionStatsCards(stats: s),
                      loading: () => const ShimmerBox(height: 120),
                      error: (e, stack) {
                        AppLogger.e('Erreur chargement stats transactions', 'TransactionHistory', e, stack);
                        return AppErrorWidget(
                          message: 'Impossible de charger les statistiques',
                          onRetry: () => ref.invalidate(totalTransactionStatsProvider),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Transactions List
              _buildTransactionsList(historyState, theme),

              // Loading indicator for next page
              if (historyState.isLoading &&
                  historyState.transactions.isNotEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: LoadingState(
                      message: 'Chargement des transactions supplémentaires...',
                      useShimmer: true,
                    ),
                  ),
                ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsList(
    TransactionHistoryState historyState,
    ThemeData theme,
  ) {
    final transactions = historyState.transactions;

    if (transactions.isEmpty) {
      if (historyState.isLoading) {
        return const SliverFillRemaining(
          child: LoadingState(
            message: 'Chargement des transactions...',
            useShimmer: true,
          ),
        );
      }
      return const SliverFillRemaining(
        child: EmptyState(
          icon: Icons.receipt_long,
          title: 'Aucune transaction',
          subtitle: 'Aucune transaction trouvée pour cette période',
        ),
      );
    }

    final groupedTransactions = _groupByMonth(transactions);

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final entries = groupedTransactions.entries.toList();
        final entry = entries[index];
        final monthYear = entry.key;
        final monthTransactions = entry.value;
        final shouldAnimate = index < 5;

        return shouldAnimate
            ? AnimatedEntrance.fromBottom(
                delay: Duration(milliseconds: 100 + (index * 50)),
                child: _buildMonthSection(monthYear, monthTransactions, theme),
              )
            : _buildMonthSection(monthYear, monthTransactions, theme);
      }, childCount: groupedTransactions.length),
    );
  }

  Widget _buildMonthSection(
    String monthYear,
    List<FinanceTransaction> transactions,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sticky header with glassmorphism
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: ClipRRect(
            borderRadius: AppSpacing.borderRadiusLg,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.colors.brandPrimary.withValues(alpha: 0.1),
                      context.colors.brandPrimary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppSpacing.borderRadiusLg,
                  border: Border.all(
                    color: context.colors.brandPrimary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  monthYear.toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.brandPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Transaction items
        ...transactions.map(
          (transaction) => TransactionListItem(
            transaction: transaction,
            onTap: () => _showTransactionDetails(transaction),
          ),
        ),
      ],
    );
  }

  Map<String, List<FinanceTransaction>> _groupByMonth(
    List<FinanceTransaction> transactions,
  ) {
    final grouped = <String, List<FinanceTransaction>>{};
    for (final transaction in transactions) {
      final monthYear = DateFormat(
        'MMMM yyyy',
        'fr_FR',
      ).format(transaction.date);
      grouped
          .putIfAbsent(monthYear, () => <FinanceTransaction>[])
          .add(transaction);
    }
    return grouped;
  }

  void _showFilterSheet() async {
    await HapticHelper.light();
    if (!mounted) return;

    unawaited(showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TransactionFilterSheet(
        initialFilters: _filters,
        onApply: (filters) {
          setState(() => _filters = filters);
          ref.read(transactionHistoryProvider.notifier).applyFilters(filters);
        },
      ),
    ));
  }

  void _showTransactionDetails(FinanceTransaction transaction) async {
    await HapticHelper.light();
    if (!mounted) return;

    await context.push(
      AppRoutes.financeTransactionDetails,
      extra: transaction,
    );
  }
} 
