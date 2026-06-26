import 'package:freezed_annotation/freezed_annotation.dart';

part 'church_service.freezed.dart';
part 'church_service.g.dart';

enum ServiceType {
  sundayService,
  prayerMeeting,
  youthService,
  childrenService,
  specialEvent,
}

@freezed
class ChurchService with _$ChurchService {
  const factory ChurchService({
    required String id,
    required String churchId,
    required ServiceType type,
    required DateTime date,
    String? title,
    String? theme,
    String? preacherId, // Name or ID
    String? preacherName,
    @Default(0) int attendanceCount,
    @Default(0) int menCount,
    @Default(0) int womenCount,
    @Default(0) int childrenCount,
    @Default(0) int menVisitorsCount, // New
    @Default(0) int womenVisitorsCount, // New
    @Default(0) int childrenVisitorsCount, // New
    @Default([]) List<String> notes,
    @Default(false) bool isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ChurchService;

  factory ChurchService.fromJson(Map<String, dynamic> json) =>
      _$ChurchServiceFromJson(json);
}

extension ServiceTypeX on ServiceType {
  String get label {
    switch (this) {
      case ServiceType.sundayService:
        return 'Culte Dominical';
      case ServiceType.prayerMeeting:
        return 'Réunion de Prière';
      case ServiceType.youthService:
        return 'Culte Jeunesse';
      case ServiceType.childrenService:
        return 'Culte Enfants';
      case ServiceType.specialEvent:
        return 'Événement Spécial';
    }
  }

  String get id {
    switch (this) {
      case ServiceType.sundayService:
        return 'sunday';
      case ServiceType.prayerMeeting:
        return 'prayer';
      case ServiceType.youthService:
        return 'youth';
      case ServiceType.childrenService:
        return 'children';
      case ServiceType.specialEvent:
        return 'special';
    }
  }
}