import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/church_service.dart';

part 'church_service_model.g.dart';

@collection
class ChurchServiceModel {
  Id isarId = Isar.autoIncrement; // Isar ID

  @Index(unique: true, replace: true)
  late String remoteId;

  @Index()
  late String churchId;

  late String type; // specific string enum
  late DateTime date;

  String? title;
  String? theme;
  String? preacherId;
  String? preacherName;

  int attendanceCount = 0;
  int menCount = 0;
  int womenCount = 0;
  int childrenCount = 0;

  // Nouveaux champs pour visiteurs
  int menVisitorsCount = 0;
  int womenVisitorsCount = 0;
  int childrenVisitorsCount = 0;

  List<String> notes = [];
  bool isCompleted = false;

  DateTime? createdAt;
  DateTime? updatedAt;

  // Sync fields
  bool isSynced = true;
  bool isDeleted = false;
  DateTime? lastSyncedAt;

  String? jsonData;

  ChurchService toEntity() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return ChurchService.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return ChurchService(
      id: remoteId,
      churchId: churchId,
      type: ServiceType.values.firstWhere(
        (e) => e.id == type,
        orElse: () => ServiceType.sundayService,
      ),
      date: date,
      title: title,
      theme: theme,
      preacherId: preacherId,
      preacherName: preacherName,
      attendanceCount: attendanceCount,
      menCount: menCount,
      womenCount: womenCount,
      childrenCount: childrenCount,
      menVisitorsCount: menVisitorsCount,
      womenVisitorsCount: womenVisitorsCount,
      childrenVisitorsCount: childrenVisitorsCount,
      notes: notes,
      isCompleted: isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static ChurchServiceModel fromEntity(ChurchService service) {
    final model = ChurchServiceModel();
    model.isarId = Isar.autoIncrement; // Will be overwritten if updating
    model.remoteId = service.id;
    model.churchId = service.churchId;
    model.type = (service.type as dynamic).id; // Assuming extension usage
    model.date = service.date;
    model.title = service.title;
    model.theme = service.theme;
    model.preacherId = service.preacherId;
    model.preacherName = service.preacherName;
    model.attendanceCount = service.attendanceCount;
    model.menCount = service.menCount;
    model.womenCount = service.womenCount;
    model.childrenCount = service.childrenCount;
    model.menVisitorsCount = service.menVisitorsCount;
    model.womenVisitorsCount = service.womenVisitorsCount;
    model.childrenVisitorsCount = service.childrenVisitorsCount;
    model.notes = service.notes;
    model.isCompleted = service.isCompleted;
    model.createdAt = service.createdAt;
    model.updatedAt = service.updatedAt;

    // Default sync state for new items
    model.isSynced = false;
    model.jsonData = jsonEncode(service.toJson());

    return model;
  }
}