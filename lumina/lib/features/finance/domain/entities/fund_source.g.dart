// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FundSourceImpl _$$FundSourceImplFromJson(Map<String, dynamic> json) =>
    _$FundSourceImpl(
      code: json['code'] as String,
      label: json['label'] as String,
      requiresForeignDeclaration:
          json['requires_foreign_declaration'] as bool? ?? false,
      requiresNif: json['requires_nif'] as bool? ?? false,
      maxAmountCfa: (json['max_amount_cfa'] as num?)?.toInt(),
      active: json['active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$FundSourceImplToJson(_$FundSourceImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'label': instance.label,
      'requires_foreign_declaration': instance.requiresForeignDeclaration,
      'requires_nif': instance.requiresNif,
      'max_amount_cfa': instance.maxAmountCfa,
      'active': instance.active,
      'created_at': instance.createdAt?.toIso8601String(),
    };
