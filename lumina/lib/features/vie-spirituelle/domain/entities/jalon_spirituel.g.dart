// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jalon_spirituel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JalonSpirituelImpl _$$JalonSpirituelImplFromJson(Map<String, dynamic> json) =>
    _$JalonSpirituelImpl(
      id: json['id'] as String,
      titre: json['titre'] as String,
      description: json['description'] as String? ?? '',
      iconName: json['icon_name'] as String? ?? 'flag',
      colorHex: json['color_hex'] as String? ?? '#1976D2',
      order: (json['order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$JalonSpirituelImplToJson(
        _$JalonSpirituelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titre': instance.titre,
      'description': instance.description,
      'icon_name': instance.iconName,
      'color_hex': instance.colorHex,
      'order': instance.order,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$MembreJalonImpl _$$MembreJalonImplFromJson(Map<String, dynamic> json) =>
    _$MembreJalonImpl(
      id: json['id'] as String,
      membreId: json['membre_id'] as String,
      jalonId: json['jalon_id'] as String,
      dateRealisation: DateTime.parse(json['date_realisation'] as String),
      lieu: json['lieu'] as String? ?? '',
      temoin: json['temoin'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$MembreJalonImplToJson(_$MembreJalonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'membre_id': instance.membreId,
      'jalon_id': instance.jalonId,
      'date_realisation': instance.dateRealisation.toIso8601String(),
      'lieu': instance.lieu,
      'temoin': instance.temoin,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$JalonStatsImpl _$$JalonStatsImplFromJson(Map<String, dynamic> json) =>
    _$JalonStatsImpl(
      jalonId: json['jalon_id'] as String,
      titre: json['titre'] as String,
      colorHex: json['color_hex'] as String,
      nombreMembres: (json['nombre_membres'] as num?)?.toInt() ?? 0,
      derniereRealisation: json['derniere_realisation'] == null
          ? null
          : DateTime.parse(json['derniere_realisation'] as String),
    );

Map<String, dynamic> _$$JalonStatsImplToJson(_$JalonStatsImpl instance) =>
    <String, dynamic>{
      'jalon_id': instance.jalonId,
      'titre': instance.titre,
      'color_hex': instance.colorHex,
      'nombre_membres': instance.nombreMembres,
      'derniere_realisation': instance.derniereRealisation?.toIso8601String(),
    };
