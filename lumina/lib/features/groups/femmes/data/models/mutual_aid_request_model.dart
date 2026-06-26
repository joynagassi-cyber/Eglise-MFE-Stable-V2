import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/mutual_aid_request.dart';

part 'mutual_aid_request_model.g.dart';

@collection
class MutualAidRequestModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String originalId;

  @Index()
  late String churchId;

  @Index()
  late String groupId;

  @Index()
  late String requesterId;

  late String type;
  String? description;
  late String status;
  int responsesCount = 0;
  DateTime? createdAt;

  DateTime? lastSyncedAt;
  bool isDirty = false;
  bool isDeleted = false;

  String? jsonData;

  MutualAidRequest toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return MutualAidRequest.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return MutualAidRequest(
      id: originalId,
      churchId: churchId,
      groupId: groupId,
      requesterId: requesterId,
      type: type,
      description: description,
      status: status,
      responsesCount: responsesCount,
      createdAt: createdAt,
    );
  }

  static MutualAidRequestModel fromDomain(MutualAidRequest request) {
    return MutualAidRequestModel()
      ..originalId = request.id
      ..churchId = request.churchId
      ..groupId = request.groupId
      ..requesterId = request.requesterId
      ..type = request.type
      ..description = request.description
      ..status = request.status
      ..responsesCount = request.responsesCount
      ..createdAt = request.createdAt
      ..jsonData = jsonEncode(request.toJson());
  }
}