import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/training.dart';

part 'training_model.g.dart';

@collection
class TrainingModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String originalId;

  @Index()
  late String churchId;

  @Index()
  late String groupId;

  late String title;
  String? description;
  String? trainer;
  DateTime? nextSession;
  int? capacity;
  int enrolledCount = 0;
  DateTime? createdAt;

  DateTime? lastSyncedAt;
  bool isDirty = false;
  bool isDeleted = false;

  String? jsonData;

  Training toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return Training.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return Training(
      id: originalId,
      churchId: churchId,
      groupId: groupId,
      title: title,
      description: description,
      trainer: trainer,
      nextSession: nextSession,
      capacity: capacity,
      enrolledCount: enrolledCount,
      createdAt: createdAt,
    );
  }

  static TrainingModel fromDomain(Training training) {
    return TrainingModel()
      ..originalId = training.id
      ..churchId = training.churchId
      ..groupId = training.groupId
      ..title = training.title
      ..description = training.description
      ..trainer = training.trainer
      ..nextSession = training.nextSession
      ..capacity = training.capacity
      ..enrolledCount = training.enrolledCount
      ..createdAt = training.createdAt
      ..jsonData = jsonEncode(training.toJson());
  }
}