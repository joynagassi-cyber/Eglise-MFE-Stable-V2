import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'jalon_spirituel.freezed.dart';
part 'jalon_spirituel.g.dart';

@freezed
class JalonSpirituel with _$JalonSpirituel {
  const factory JalonSpirituel({
    required String id,
    required String titre,
    @Default('') String description,
    @Default('flag') String iconName,
    @Default('#1976D2') String colorHex,
    @Default(0) int order,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _JalonSpirituel;

  const JalonSpirituel._();

  factory JalonSpirituel.fromJson(Map<String, dynamic> json) => _$JalonSpirituelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$$JalonSpirituelImplToJson(this as _$JalonSpirituelImpl);

  Color get color {
    try {
      final hex = colorHex.replaceFirst('#', '');
      if (hex.length == 6) return Color(int.parse('FF$hex', radix: 16));
      return const Color(0xFF1976D2);
    } catch (e) {
      return const Color(0xFF1976D2);
    }
  }

  IconData get iconData => _iconMap[iconName] ?? Icons.flag_rounded;
  String get displayTitre => titre.isNotEmpty ? titre : 'Jalon sans nom';
  String get displayDescription => description.isNotEmpty ? description : 'Aucune description';

  static const Map<String, IconData> _iconMap = {
    'water_drop': Icons.water_drop_rounded,
    'local_fire_department': Icons.local_fire_department_rounded,
    'church': Icons.church_rounded,
    'favorite': Icons.favorite_rounded,
    'handshake': Icons.handshake_rounded,
    'flag': Icons.flag_rounded,
    'star': Icons.star_rounded,
    'book': Icons.book_rounded,
    'person': Icons.person_rounded,
    'groups': Icons.groups_rounded,
    'home': Icons.home_rounded,
    'location_on': Icons.location_on_rounded,
  };
}

@freezed
class MembreJalon with _$MembreJalon {
  const factory MembreJalon({
    required String id,
    required String membreId,
    required String jalonId,
    required DateTime dateRealisation,
    @Default('') String lieu,
    @Default('') String temoin,
    @Default('') String notes,
    DateTime? createdAt,
  }) = _MembreJalon;

  const MembreJalon._();

  factory MembreJalon.fromJson(Map<String, dynamic> json) => _$MembreJalonFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$$MembreJalonImplToJson(this as _$MembreJalonImpl);

  String get displayDate => '${dateRealisation.day.toString().padLeft(2, '0')}/${dateRealisation.month.toString().padLeft(2, '0')}/${dateRealisation.year}';
}

@freezed
class JalonStats with _$JalonStats {
  const factory JalonStats({
    required String jalonId,
    required String titre,
    required String colorHex,
    @Default(0) int nombreMembres,
    DateTime? derniereRealisation,
  }) = _JalonStats;

  const JalonStats._();

  factory JalonStats.fromJson(Map<String, dynamic> json) => _$JalonStatsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$$JalonStatsImplToJson(this as _$JalonStatsImpl);
}
