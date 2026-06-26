import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/member_transfer_request.dart';

part 'member_transfer_request_model.g.dart';

@collection
class MemberTransferRequestModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String originalId;

  @Index()
  late String churchId;

  @Index()
  late String memberId;

  @Index()
  late String fromGroupId;

  @Index()
  String? toGroupId;

  @Index()
  late String requesterId;

  String? reason;

  @Enumerated(EnumType.name)
  late TransferStatus status;

  String? notes;
  String? approvedBy;
  DateTime? approvedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  DateTime? lastSyncedAt;
  bool isDirty = false;

  String? jsonData;

  MemberTransferRequest toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return MemberTransferRequest.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return MemberTransferRequest(
      id: originalId,
      churchId: churchId,
      memberId: memberId,
      fromGroupId: fromGroupId,
      toGroupId: toGroupId,
      requesterId: requesterId,
      reason: reason,
      status: status,
      notes: notes,
      approvedBy: approvedBy,
      approvedAt: approvedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static MemberTransferRequestModel fromDomain(MemberTransferRequest domain) {
    return MemberTransferRequestModel()
      ..originalId = domain.id
      ..churchId = domain.churchId
      ..memberId = domain.memberId
      ..fromGroupId = domain.fromGroupId
      ..toGroupId = domain.toGroupId
      ..requesterId = domain.requesterId
      ..reason = domain.reason
      ..status = domain.status
      ..notes = domain.notes
      ..approvedBy = domain.approvedBy
      ..approvedAt = domain.approvedAt
      ..createdAt = domain.createdAt
      ..updatedAt = domain.updatedAt
      ..jsonData = jsonEncode(domain.toJson());
  }
}