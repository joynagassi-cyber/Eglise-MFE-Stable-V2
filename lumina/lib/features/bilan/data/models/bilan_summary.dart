import 'package:equatable/equatable.dart';

class BilanSummary extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  final int txCount;
  final int sealedCount;
  final int pendingCount;
  final double avgTransaction;
  final Map<String, dynamic>? largestTransaction;
  final DateTime? periodStart;
  final DateTime? periodEnd;

  const BilanSummary({
    this.totalIncome = 0,
    this.totalExpense = 0,
    this.netBalance = 0,
    this.txCount = 0,
    this.sealedCount = 0,
    this.pendingCount = 0,
    this.avgTransaction = 0,
    this.largestTransaction,
    this.periodStart,
    this.periodEnd,
  });

  factory BilanSummary.fromJson(Map<String, dynamic> json) => BilanSummary(
        totalIncome: (json['totalIncome'] ?? json['total_income'] ?? 0).toDouble(),
        totalExpense: (json['totalExpense'] ?? json['total_expense'] ?? 0).toDouble(),
        netBalance: (json['netBalance'] ?? json['net_balance'] ?? 0).toDouble(),
        txCount: json['txCount'] ?? json['transactionCount'] ?? json['tx_count'] ?? 0,
        sealedCount: json['sealedCount'] ?? json['sealed_count'] ?? 0,
        pendingCount: json['pendingCount'] ?? json['pending_count'] ?? 0,
        avgTransaction: (json['avgTransaction'] ?? json['avg_transaction'] ?? 0).toDouble(),
        largestTransaction: json['largestTransaction'] as Map<String, dynamic>?,
        periodStart: json['periodStart'] != null
            ? DateTime.tryParse(json['periodStart'] as String)
            : json['period_start'] != null
                ? DateTime.tryParse(json['period_start'] as String)
                : null,
        periodEnd: json['periodEnd'] != null
            ? DateTime.tryParse(json['periodEnd'] as String)
            : json['period_end'] != null
                ? DateTime.tryParse(json['period_end'] as String)
                : null,
      );

  BilanSummary copyWith({
    double? totalIncome,
    double? totalExpense,
    double? netBalance,
    int? txCount,
    int? sealedCount,
    int? pendingCount,
    double? avgTransaction,
    Map<String, dynamic>? largestTransaction,
    DateTime? periodStart,
    DateTime? periodEnd,
  }) {
    return BilanSummary(
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      netBalance: netBalance ?? this.netBalance,
      txCount: txCount ?? this.txCount,
      sealedCount: sealedCount ?? this.sealedCount,
      pendingCount: pendingCount ?? this.pendingCount,
      avgTransaction: avgTransaction ?? this.avgTransaction,
      largestTransaction: largestTransaction ?? this.largestTransaction,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
        'netBalance': netBalance,
        'txCount': txCount,
        'sealedCount': sealedCount,
        'pendingCount': pendingCount,
        'avgTransaction': avgTransaction,
        'largestTransaction': largestTransaction,
        'periodStart': periodStart?.toIso8601String(),
        'periodEnd': periodEnd?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        totalIncome,
        totalExpense,
        netBalance,
        txCount,
        sealedCount,
        pendingCount,
        avgTransaction,
        largestTransaction,
        periodStart,
        periodEnd,
      ];
}