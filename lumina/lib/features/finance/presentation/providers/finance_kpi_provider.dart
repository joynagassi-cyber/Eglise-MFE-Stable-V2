import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/enums/transaction_type.dart';
import './finance_providers.dart';

part 'finance_kpi_provider.g.dart';

class FinanceKpiData {
  final double totalCollected;
  final double bestDayAmount;
  final DateTime? bestDayDate;
  final double averagePerService;
  final String mostProfitableService;

  const FinanceKpiData({
    required this.totalCollected,
    required this.bestDayAmount,
    this.bestDayDate,
    required this.averagePerService,
    required this.mostProfitableService,
  });
}

@riverpod
class FinanceKpi extends _$FinanceKpi {
  @override
  Future<FinanceKpiData> build() async {
    final transactionsAsync = ref.watch(transactionsProvider);
    final transactions = transactionsAsync.valueOrNull ?? [];

    if (transactions.isEmpty) {
      return const FinanceKpiData(
        totalCollected: 0.0,
        bestDayAmount: 0.0,
        averagePerService: 0.0,
        mostProfitableService: '-',
      );
    }

    double totalCollected = 0;
    final dailyTotals = <DateTime, double>{};
    final serviceTotals = <String, double>{};
    final uniqueDates = <DateTime>{};

    for (final t in transactions) {
      if (t.type != TransactionType.income) continue;

      totalCollected += t.amount;

      final day = DateTime(t.date.year, t.date.month, t.date.day);
      uniqueDates.add(day);

      dailyTotals[day] = (dailyTotals[day] ?? 0) + t.amount;

      final serviceType = t.description;
      if (serviceType.isNotEmpty) {
        serviceTotals[serviceType] =
            (serviceTotals[serviceType] ?? 0) + t.amount;
      }
    }

    double bestDayAmt = 0;
    DateTime? bestDay;
    dailyTotals.forEach((date, amount) {
      if (amount > bestDayAmt) {
        bestDayAmt = amount;
        bestDay = date;
      }
    });

    final avg =
        uniqueDates.isNotEmpty ? totalCollected / uniqueDates.length : 0.0;

    String mostProf = '-';
    double mostProfAmt = 0;
    serviceTotals.forEach((service, amount) {
      if (amount > mostProfAmt) {
        mostProfAmt = amount;
        mostProf = service;
      }
    });

    return FinanceKpiData(
      totalCollected: totalCollected,
      bestDayAmount: bestDayAmt,
      bestDayDate: bestDay,
      averagePerService: avg,
      mostProfitableService: mostProf,
    );
  }
}