// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_anomaly.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuditAnomalyImpl _$$AuditAnomalyImplFromJson(Map<String, dynamic> json) =>
    _$AuditAnomalyImpl(
      logId: json['log_id'] as String,
      severity: $enumDecode(_$AnomalySeverityEnumMap, json['severity']),
      description: json['description'] as String,
      detectedAt: DateTime.parse(json['detected_at'] as String),
    );

Map<String, dynamic> _$$AuditAnomalyImplToJson(_$AuditAnomalyImpl instance) =>
    <String, dynamic>{
      'log_id': instance.logId,
      'severity': _$AnomalySeverityEnumMap[instance.severity]!,
      'description': instance.description,
      'detected_at': instance.detectedAt.toIso8601String(),
    };

const _$AnomalySeverityEnumMap = {
  AnomalySeverity.low: 'low',
  AnomalySeverity.warning: 'warning',
  AnomalySeverity.critical: 'critical',
};
