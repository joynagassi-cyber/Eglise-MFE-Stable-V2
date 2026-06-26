import 'package:equatable/equatable.dart';

enum CampStatus { planned, ongoing, completed, cancelled }

class Camp extends Equatable {
  final String id;
  final String churchId;
  final String groupId;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final String? eventId;
  final double budgetTarget;
  final double budgetActual;
  final int capacity;
  final int registeredCount;
  final String themeColor;
  final CampStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Camp({
    required this.id,
    required this.churchId,
    required this.groupId,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    this.eventId,
    this.budgetTarget = 0,
    this.budgetActual = 0,
    this.capacity = 0,
    this.registeredCount = 0,
    this.themeColor = '#FF5722',
    this.status = CampStatus.planned,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        churchId,
        groupId,
        name,
        description,
        startDate,
        endDate,
        eventId,
        budgetTarget,
        budgetActual,
        capacity,
        registeredCount,
        themeColor,
        status,
        createdAt,
        updatedAt,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'church_id': churchId,
      'group_id': groupId,
      'name': name,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'event_id': eventId,
      'budget_target': budgetTarget,
      'budget_actual': budgetActual,
      'capacity': capacity,
      'registered_count': registeredCount,
      'theme_color': themeColor,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Camp.fromJson(Map<String, dynamic> json) {
    return Camp(
      id: json['id'] as String,
      churchId: json['church_id'] as String? ?? '',
      groupId: json['group_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      eventId: json['event_id'] as String?,
      budgetTarget: (json['budget_target'] as num?)?.toDouble() ?? 0,
      budgetActual: (json['budget_actual'] as num?)?.toDouble() ?? 0,
      capacity: json['capacity'] as int? ?? 0,
      registeredCount: json['registered_count'] as int? ?? 0,
      themeColor: json['theme_color'] as String? ?? '#FF5722',
      status: CampStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => CampStatus.planned,
      ),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Camp copyWith({
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? eventId,
    double? budgetTarget,
    double? budgetActual,
    int? capacity,
    int? registeredCount,
    String? themeColor,
    CampStatus? status,
    DateTime? updatedAt,
  }) {
    return Camp(
      id: id,
      churchId: churchId,
      groupId: groupId,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      eventId: eventId ?? this.eventId,
      budgetTarget: budgetTarget ?? this.budgetTarget,
      budgetActual: budgetActual ?? this.budgetActual,
      capacity: capacity ?? this.capacity,
      registeredCount: registeredCount ?? this.registeredCount,
      themeColor: themeColor ?? this.themeColor,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}