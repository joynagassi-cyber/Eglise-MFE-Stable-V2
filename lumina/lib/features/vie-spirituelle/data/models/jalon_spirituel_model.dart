import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/jalon_spirituel.dart';

part 'jalon_spirituel_model.g.dart';

@collection
class JalonSpirituelModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  late String titre;
  late String description;
  late String iconName;
  late String colorHex;
  late int order;
  late bool isActive;

  DateTime? createdAt;
  DateTime? updatedAt;

  // Local-First fields
  int version = 1;
  bool isDeleted = false;
  bool isSynced = true;
  DateTime? lastSyncedAt;
  String? jsonData;

  JalonSpirituel toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return JalonSpirituel.fromJson(jsonDecode(jsonData!));
      } catch (_) {}
    }
    return JalonSpirituel(
      id: id,
      titre: titre,
      description: description,
      iconName: iconName,
      colorHex: colorHex,
      order: order,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static JalonSpirituelModel fromDomain(JalonSpirituel jalon) {
    return JalonSpirituelModel()
      ..id = jalon.id
      ..titre = jalon.titre
      ..description = jalon.description
      ..iconName = jalon.iconName
      ..colorHex = jalon.colorHex
      ..order = jalon.order
      ..isActive = jalon.isActive
      ..createdAt = jalon.createdAt
      ..updatedAt = jalon.updatedAt
      ..jsonData = jsonEncode(jalon.toJson());
  }
}

@collection
class MembreJalonModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String membreId;

  @Index()
  late String jalonId;

  late DateTime dateRealisation;
  late String lieu;
  late String temoin;
  late String notes;

  DateTime? createdAt;

  // Local-First fields
  int version = 1;
  bool isDeleted = false;
  bool isSynced = true;
  DateTime? lastSyncedAt;
  String? jsonData;

  MembreJalon toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return MembreJalon.fromJson(jsonDecode(jsonData!));
      } catch (_) {}
    }
    return MembreJalon(
      id: id,
      membreId: membreId,
      jalonId: jalonId,
      dateRealisation: dateRealisation,
      lieu: lieu,
      temoin: temoin,
      notes: notes,
      createdAt: createdAt,
    );
  }

  static MembreJalonModel fromDomain(MembreJalon m) {
    return MembreJalonModel()
      ..id = m.id
      ..membreId = m.membreId
      ..jalonId = m.jalonId
      ..dateRealisation = m.dateRealisation
      ..lieu = m.lieu
      ..temoin = m.temoin
      ..notes = m.notes
      ..createdAt = m.createdAt
      ..jsonData = jsonEncode(m.toJson());
  }
}
