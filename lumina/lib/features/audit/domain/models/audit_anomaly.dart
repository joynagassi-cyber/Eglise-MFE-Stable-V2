import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_anomaly.freezed.dart';
part 'audit_anomaly.g.dart';

enum AnomalySeverity { low, warning, critical }

@freezed
class AuditAnomaly with _$AuditAnomaly {
  const factory AuditAnomaly({
    required String logId,
    required AnomalySeverity severity,
    required String description,
    required DateTime detectedAt,
  }) = _AuditAnomaly;

  factory AuditAnomaly.fromJson(Map<String, dynamic> json) =>
      _$AuditAnomalyFromJson(json);
}