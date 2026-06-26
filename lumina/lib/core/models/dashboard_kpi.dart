// ============================================================
// FICHIER : lib/core/models/dashboard_kpi.dart
// DESCRIPTION : Modèle générique pour les KPIs affichés sur les dashboards
// DÉPENDANCES : flutter/material.dart (pour IconData et Color)
// ============================================================

import 'package:flutter/material.dart';

class DashboardKpi {
  final String id;
  final String label;
  final String value;
  final String? previousValue;
  final double? changePercent;
  final KpiTrend trend;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final String? route;

  const DashboardKpi({
    required this.id,
    required this.label,
    required this.value,
    this.previousValue,
    this.changePercent,
    this.trend = KpiTrend.neutral,
    this.icon = Icons.analytics_outlined,
    this.color = const Color(0xFF6366F1),
    this.subtitle,
    this.route,
  });

  bool get hasChange => changePercent != null && changePercent != 0;

  String get changeLabel {
    if (changePercent == null) return '';
    final sign = changePercent! > 0 ? '+' : '';
    return '$sign${changePercent!.toStringAsFixed(1)}%';
  }

  factory DashboardKpi.fromJson(Map<String, dynamic> json) {
    return DashboardKpi(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      value: json['value']?.toString() ?? '0',
      previousValue: json['previous_value']?.toString(),
      changePercent: (json['change_percent'] as num?)?.toDouble(),
      trend: KpiTrend.fromString(json['trend'] as String? ?? 'neutral'),
      icon: Icons.analytics_outlined,
      color: const Color(0xFF6366F1),
      subtitle: json['subtitle'] as String?,
      route: json['route'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'value': value,
      'previous_value': previousValue,
      'change_percent': changePercent,
      'trend': trend.name,
      'subtitle': subtitle,
      'route': route,
    };
  }

  DashboardKpi copyWith({
    String? id,
    String? label,
    String? value,
    String? previousValue,
    double? changePercent,
    KpiTrend? trend,
    IconData? icon,
    Color? color,
    String? subtitle,
    String? route,
  }) {
    return DashboardKpi(
      id: id ?? this.id,
      label: label ?? this.label,
      value: value ?? this.value,
      previousValue: previousValue ?? this.previousValue,
      changePercent: changePercent ?? this.changePercent,
      trend: trend ?? this.trend,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      subtitle: subtitle ?? this.subtitle,
      route: route ?? this.route,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardKpi &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DashboardKpi($label: $value)';
}

enum KpiTrend {
  up,
  down,
  neutral;

  static KpiTrend fromString(String value) {
    return switch (value.toLowerCase()) {
      'up' => KpiTrend.up,
      'down' => KpiTrend.down,
      _ => KpiTrend.neutral,
    };
  }

  IconData get icon => switch (this) {
        KpiTrend.up => Icons.trending_up_rounded,
        KpiTrend.down => Icons.trending_down_rounded,
        KpiTrend.neutral => Icons.trending_flat_rounded,
      };

  Color get color => switch (this) {
        KpiTrend.up => const Color(0xFF22C55E),
        KpiTrend.down => const Color(0xFFEF4444),
        KpiTrend.neutral => const Color(0xFF94A3B8),
      };
}
