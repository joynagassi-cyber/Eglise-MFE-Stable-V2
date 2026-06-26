import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:lumina/core/logging/app_logger.dart';
import '../../domain/entities/sacrament.dart';
import '../../domain/entities/sacrament_type.dart';

part 'sacrament_model.g.dart';

@collection
class SacramentModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String churchId;

  @Index()
  late String typeId;

  @Index()
  late DateTime date;

  @Index()
  late String memberId;

  @Index(caseSensitive: false)
  String? memberFirstName;
  @Index(caseSensitive: false)
  String? memberLastName;

  String? location;
  String? celebrant;

  @Index(caseSensitive: false)
  String? godfather;
  @Index(caseSensitive: false)
  String? godmother;

  String? spouseName;
  DateTime? spouseBirthDate;

  String? witnesses;
  @Index(caseSensitive: false)
  String? certificateNumber;

  String? notes;
  String? attachmentUrl;

  DateTime? createdAt;
  DateTime? updatedAt;
  String? createdBy;
  String? updatedBy;

  int version = 1;
  String deviceId = 'unknown';

  bool isDeleted = false;
  DateTime? deletedAt;
  String? deletedBy;
  DateTime? lastSyncedAt;

  String? jsonData;

  static SacramentModel fromDomain(Sacrament sacrament) {
    return SacramentModel()
      ..id = sacrament.id
      ..churchId = sacrament.churchId
      ..typeId = _typeToString(sacrament.type)
      ..date = sacrament.date
      ..memberId = sacrament.memberId
      ..memberFirstName = sacrament.memberFirstName
      ..memberLastName = sacrament.memberLastName
      ..location = sacrament.location
      ..celebrant = sacrament.celebrant
      ..godfather = sacrament.godfather
      ..godmother = sacrament.godmother
      ..spouseName = sacrament.spouseName
      ..spouseBirthDate = sacrament.spouseBirthDate
      ..witnesses = sacrament.witnesses
      ..certificateNumber = sacrament.certificateNumber
      ..notes = sacrament.notes
      ..attachmentUrl = sacrament.attachmentUrl
      ..createdAt = sacrament.createdAt
      ..updatedAt = sacrament.updatedAt
      ..createdBy = sacrament.createdBy
      ..updatedBy = sacrament.updatedBy
      ..jsonData = jsonEncode(sacrament.toJson());
  }

  Sacrament toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return Sacrament.fromJson(jsonDecode(jsonData!));
      } catch (e, stack) {
        AppLogger.e(
            'Error parsing SacramentModel', 'SACRAMENT_MODEL', e, stack);
      }
    }
    return Sacrament(
      id: id,
      churchId: churchId,
      type: _stringToType(typeId),
      date: date,
      memberId: memberId,
      memberFirstName: memberFirstName,
      memberLastName: memberLastName,
      location: location,
      celebrant: celebrant,
      godfather: godfather,
      godmother: godmother,
      spouseName: spouseName,
      spouseBirthDate: spouseBirthDate,
      witnesses: witnesses,
      certificateNumber: certificateNumber,
      notes: notes,
      attachmentUrl: attachmentUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
      updatedBy: updatedBy,
    );
  }

  static String _typeToString(SacramentType type) {
    return type.when(
      baptism: () => 'baptism',
      baptismHolySpirit: () => 'baptism_holy_spirit',
      marriage: () => 'marriage',
      confirmation: () => 'confirmation',
      firstCommunion: () => 'first_communion',
      anointing: () => 'anointing',
      penance: () => 'penance',
    );
  }

  static SacramentType _stringToType(String typeId) {
    return SacramentTypeX.fromString(typeId);
  }
}