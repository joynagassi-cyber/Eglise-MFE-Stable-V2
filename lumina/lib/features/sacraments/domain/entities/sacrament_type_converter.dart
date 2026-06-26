import 'package:freezed_annotation/freezed_annotation.dart';
import 'sacrament_type.dart';

class SacramentTypeConverter implements JsonConverter<SacramentType, String> {
  const SacramentTypeConverter();

  @override
  SacramentType fromJson(String json) {
    return SacramentTypeX.fromString(json);
  }

  @override
  String toJson(SacramentType object) {
    return object.when(
      baptism: () => 'baptism',
      baptismHolySpirit: () => 'baptism_holy_spirit',
      marriage: () => 'marriage',
      confirmation: () => 'confirmation',
      firstCommunion: () => 'first_communion',
      anointing: () => 'anointing',
      penance: () => 'penance',
    );
  }
}