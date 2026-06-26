import 'package:freezed_annotation/freezed_annotation.dart';

part 'sacrament_type.freezed.dart';

@freezed
class SacramentType with _$SacramentType {
  const SacramentType._();

  const factory SacramentType.baptism() = Baptism;
  const factory SacramentType.baptismHolySpirit() = BaptismHolySpirit;
  const factory SacramentType.marriage() = Marriage;
  const factory SacramentType.confirmation() = Confirmation;
  const factory SacramentType.firstCommunion() = FirstCommunion;
  const factory SacramentType.anointing() = Anointing;
  const factory SacramentType.penance() = Penance;

  String get label {
    return when(
      baptism: () => 'Baptême',
      baptismHolySpirit: () => 'Baptême du Saint-Esprit',
      marriage: () => 'Mariage',
      confirmation: () => 'Confirmation',
      firstCommunion: () => 'Première Communion',
      anointing: () => 'Onction des Malades',
      penance: () => 'Pénitence',
    );
  }

  String get icon {
    return when(
      baptism: () => '💧',
      baptismHolySpirit: () => '',
      marriage: () => '💍',
      confirmation: () => '',
      firstCommunion: () => '🕊️',
      anointing: () => '',
      penance: () => '',
    );
  }

  bool get isMarriage => when(
        baptism: () => false,
        baptismHolySpirit: () => false,
        marriage: () => true,
        confirmation: () => false,
        firstCommunion: () => false,
        anointing: () => false,
        penance: () => false,
      );
}

extension SacramentTypeX on SacramentType {
  static const List<SacramentType> allTypes = [
    SacramentType.baptism(),
    SacramentType.baptismHolySpirit(),
    SacramentType.marriage(),
    SacramentType.confirmation(),
    SacramentType.firstCommunion(),
    SacramentType.anointing(),
    SacramentType.penance(),
  ];

  static SacramentType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'baptism':
      case 'baptême':
        return const SacramentType.baptism();
      case 'baptism_holy_spirit':
      case 'baptême du saint-esprit':
        return const SacramentType.baptismHolySpirit();
      case 'marriage':
      case 'mariage':
        return const SacramentType.marriage();
      case 'confirmation':
        return const SacramentType.confirmation();
      case 'first_communion':
      case 'première communion':
        return const SacramentType.firstCommunion();
      case 'anointing':
      case 'onction des malades':
        return const SacramentType.anointing();
      case 'penance':
      case 'pénitence':
        return const SacramentType.penance();
      default:
        throw ArgumentError('Unknown sacrament type: $value');
    }
  }

  static List<SacramentType> get values => allTypes;
}