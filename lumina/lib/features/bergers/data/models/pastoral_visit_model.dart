import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/pastoral_visit.dart';
import '../../domain/entities/visite_pastorale.dart';

part 'pastoral_visit_model.g.dart';

@collection
class PastoralVisitModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String churchId;

  @Index()
  late String shepherdId;

  @Index()
  late String memberId;
  late DateTime date;

  @Index(caseSensitive: false)
  String notes = '';

  String status = 'planifiee';

  String? membreNom;
  String? bergerNom;
  String? adresse;
  String? motif;
  DateTime? nextVisitDate;

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? lastSyncedAt;

  String? jsonData;

  static PastoralVisitModel fromDomain(PastoralVisit visit) {
    return PastoralVisitModel()
      ..id = visit.id
      ..churchId = visit.churchId
      ..shepherdId = visit.shepherdId
      ..memberId = visit.memberId
      ..date = visit.date
      ..notes = visit.notes
      ..status = visit.status
      ..nextVisitDate = visit.nextVisitDate
      ..createdAt = visit.createdAt
      ..updatedAt = visit.updatedAt
      ..jsonData = jsonEncode(visit.toJson());
  }

  static PastoralVisitModel fromVisitePastorale(VisitePastorale visit) {
    return PastoralVisitModel()
      ..id = visit.id
      ..churchId = visit.churchId
      ..shepherdId = visit.bergerId
      ..memberId = visit.membreId
      ..membreNom = visit.membreNom
      ..bergerNom = visit.bergerNom
      ..date = visit.dateVisite
      ..adresse = visit.adresse
      ..motif = visit.motif
      ..notes = visit.notes
      ..status = visit.statut.name
      ..createdAt = visit.createdAt
      ..updatedAt = visit.updatedAt;
  }

  VisitePastorale toVisitePastorale() {
    return VisitePastorale(
      id: id,
      churchId: churchId,
      membreId: memberId,
      membreNom: membreNom,
      bergerId: shepherdId,
      bergerNom: bergerNom,
      dateVisite: date,
      adresse: adresse ?? '',
      motif: motif ?? '',
      notes: notes,
      statut: _parseStatut(status),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static StatutVisite _parseStatut(String status) {
    return StatutVisite.values.firstWhere(
      (s) => s.name == status,
      orElse: () => StatutVisite.planifiee,
    );
  }

  PastoralVisit toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return PastoralVisit.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return PastoralVisit(
      id: id,
      churchId: churchId,
      shepherdId: shepherdId,
      memberId: memberId,
      date: date,
      notes: notes,
      status: status,
      nextVisitDate: nextVisitDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}