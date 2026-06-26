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
      iconName: json['iconName'] as String? ?? 'flag',
      colorHex: json['colorHex'] as String? ?? '#1976D2',
      order: (json['order'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$JalonSpirituelImplToJson(
        _$JalonSpirituelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titre': instance.titre,
      'description': instance.description,
      'iconName': instance.iconName,
      'colorHex': instance.colorHex,
      'order': instance.order,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

Map<String, dynamic> _$JalonSpirituelToJson(JalonSpirituel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titre': instance.titre,
      'description': instance.description,
      'iconName': instance.iconName,
      'colorHex': instance.colorHex,
      'order': instance.order,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$MembreJalonImpl _$$MembreJalonImplFromJson(Map<String, dynamic> json) =>
    _$MembreJalonImpl(
      id: json['id'] as String,
      membreId: json['membreId'] as String,
      jalonId: json['jalonId'] as String,
      dateRealisation: DateTime.parse(json['dateRealisation'] as String),
      lieu: json['lieu'] as String? ?? '',
      temoin: json['temoin'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MembreJalonImplToJson(_$MembreJalonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'membreId': instance.membreId,
      'jalonId': instance.jalonId,
      'dateRealisation': instance.dateRealisation.toIso8601String(),
      'lieu': instance.lieu,
      'temoin': instance.temoin,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

Map<String, dynamic> _$MembreJalonToJson(MembreJalon instance) =>
    <String, dynamic>{
      'id': instance.id,
      'membreId': instance.membreId,
      'jalonId': instance.jalonId,
      'dateRealisation': instance.dateRealisation.toIso8601String(),
      'lieu': instance.lieu,
      'temoin': instance.temoin,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$JalonStatsImpl _$$JalonStatsImplFromJson(Map<String, dynamic> json) =>
    _$JalonStatsImpl(
      jalonId: json['jalonId'] as String,
      titre: json['titre'] as String,
      colorHex: json['colorHex'] as String,
      nombreMembres: (json['nombreMembres'] as num?)?.toInt() ?? 0,
      derniereRealisation: json['derniereRealisation'] == null
          ? null
          : DateTime.parse(json['derniereRealisation'] as String),
    );

Map<String, dynamic> _$$JalonStatsImplToJson(_$JalonStatsImpl instance) =>
    <String, dynamic>{
      'jalonId': instance.jalonId,
      'titre': instance.titre,
      'colorHex': instance.colorHex,
      'nombreMembres': instance.nombreMembres,
      'derniereRealisation': instance.derniereRealisation?.toIso8601String(),
    };

Map<String, dynamic> _$JalonStatsToJson(JalonStats instance) =>
    <String, dynamic>{
      'jalonId': instance.jalonId,
      'titre': instance.titre,
      'colorHex': instance.colorHex,
      'nombreMembres': instance.nombreMembres,
      'derniereRealisation': instance.derniereRealisation?.toIso8601String(),
    };
