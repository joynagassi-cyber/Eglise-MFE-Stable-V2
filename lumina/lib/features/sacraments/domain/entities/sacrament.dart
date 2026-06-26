import 'package:freezed_annotation/freezed_annotation.dart';
import 'sacrament_type.dart';
import 'sacrament_type_converter.dart';

part 'sacrament.freezed.dart';
part 'sacrament.g.dart';

@freezed
class Sacrament with _$Sacrament {
  const Sacrament._();

  const factory Sacrament({
    required String id,
    required String churchId,
    @SacramentTypeConverter() required SacramentType type,
    required DateTime date,
    String? memberFirstName,
    String? memberLastName,
    required String memberId,
    String? location,
    String? celebrant,
    String? godfather,
    String? godmother,
    String? spouseName,
    DateTime? spouseBirthDate,
    String? witnesses,
    String? certificateNumber,
    String? notes,
    String? attachmentUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _Sacrament;

  factory Sacrament.fromJson(Map<String, dynamic> json) =>
      _$SacramentFromJson(json);

  String get displayName {
    final name = memberFirstName != null && memberLastName != null
        ? '$memberFirstName $memberLastName'
        : 'Membre inconnu';
    return '${type.label} - $name';
  }

  bool get isMarriage => type.when(
        baptism: () => false,
        baptismHolySpirit: () => false,
        marriage: () => true,
        confirmation: () => false,
        firstCommunion: () => false,
        anointing: () => false,
        penance: () => false,
      );

  bool get hasSpouse => spouseName != null && spouseName!.isNotEmpty;
  bool get hasGodparents => godfather != null || godmother != null;
}