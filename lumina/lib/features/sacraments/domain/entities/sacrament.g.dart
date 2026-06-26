// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sacrament.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SacramentImpl _$$SacramentImplFromJson(Map<String, dynamic> json) =>
    _$SacramentImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      type: const SacramentTypeConverter().fromJson(json['type'] as String),
      date: DateTime.parse(json['date'] as String),
      memberFirstName: json['member_first_name'] as String?,
      memberLastName: json['member_last_name'] as String?,
      memberId: json['member_id'] as String,
      location: json['location'] as String?,
      celebrant: json['celebrant'] as String?,
      godfather: json['godfather'] as String?,
      godmother: json['godmother'] as String?,
      spouseName: json['spouse_name'] as String?,
      spouseBirthDate: json['spouse_birth_date'] == null
          ? null
          : DateTime.parse(json['spouse_birth_date'] as String),
      witnesses: json['witnesses'] as String?,
      certificateNumber: json['certificate_number'] as String?,
      notes: json['notes'] as String?,
      attachmentUrl: json['attachment_url'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String?,
      updatedBy: json['updated_by'] as String?,
    );

Map<String, dynamic> _$$SacramentImplToJson(_$SacramentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'type': const SacramentTypeConverter().toJson(instance.type),
      'date': instance.date.toIso8601String(),
      'member_first_name': instance.memberFirstName,
      'member_last_name': instance.memberLastName,
      'member_id': instance.memberId,
      'location': instance.location,
      'celebrant': instance.celebrant,
      'godfather': instance.godfather,
      'godmother': instance.godmother,
      'spouse_name': instance.spouseName,
      'spouse_birth_date': instance.spouseBirthDate?.toIso8601String(),
      'witnesses': instance.witnesses,
      'certificate_number': instance.certificateNumber,
      'notes': instance.notes,
      'attachment_url': instance.attachmentUrl,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
    };
