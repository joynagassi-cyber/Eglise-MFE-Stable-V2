class KpiData {
  final num value;
  final num previousValue;
  final double variation; // en %
  final String? unit; // ex: 'XOF', '%'

  const KpiData({
    required this.value,
    this.previousValue = 0,
    this.variation = 0.0,
    this.unit,
  });

  factory KpiData.fromJson(Map<String, dynamic> json) {
    final val = json['value'] ?? 0;
    final prev = json['previousValue'] ?? 0;

    // Compute variation if not explicitly provided but both values exist
    double computedVar = 0.0;
    if (json.containsKey('variation')) {
      computedVar = (json['variation'] as num).toDouble();
    } else if (prev != 0) {
      computedVar = ((val - prev) / prev) * 100.0;
    }

    return KpiData(
      value: val,
      previousValue: prev,
      variation: computedVar,
      unit: json['unit'],
    );
  }
}

class SystemAlert {
  final String type; // 'budget_exceeded'|'sync_error'|'permission_missing'
  final String message;
  final String severity; // 'critical'|'warning'|'info'
  final String? actionRoute;

  const SystemAlert({
    required this.type,
    required this.message,
    required this.severity,
    this.actionRoute,
  });
}

class ChartPoint {
  final DateTime date;
  final double value;

  const ChartPoint({
    required this.date,
    required this.value,
  });
}

class GroupDistributionData {
  final String id;
  final String name;
  final int memberCount;
  final double percentage;
  final String colorHex;

  const GroupDistributionData({
    required this.id,
    required this.name,
    required this.memberCount,
    required this.percentage,
    required this.colorHex,
  });
}

class MonthlyFinanceData {
  final DateTime month;
  final double revenue;
  final double expense;

  const MonthlyFinanceData({
    required this.month,
    required this.revenue,
    required this.expense,
  });
}