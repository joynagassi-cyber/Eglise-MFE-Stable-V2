import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/models/audit_log.dart';

part 'audit_log_model.g.dart';

@collection
class AuditLogModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String entityType;

  late String entityId;

  @Index()
  late String action;

  @Index()
  late DateTime occurredAt;

  String? actorId;
  String? actorName;
  String? churchId;

  String? jsonData;

  AuditLog toDomain() {
    if (jsonData != null) {
      return AuditLog.fromJson(jsonDecode(jsonData!));
    }
    throw Exception('Data corrupted');
  }

  static AuditLogModel fromDomain(AuditLog log, String churchId) {
    return AuditLogModel()
      ..id = log.id
      ..entityType = log.entityType
      ..entityId = log.entityId
      ..action = log.action.name
      ..occurredAt = log.occurredAt
      ..actorId = log.actorId
      ..actorName = log.actorName
      ..churchId = churchId
      ..jsonData = jsonEncode(log.toJson());
  }
}
