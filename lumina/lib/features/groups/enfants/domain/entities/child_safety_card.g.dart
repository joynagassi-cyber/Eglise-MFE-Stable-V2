// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_safety_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChildSafetyCardImpl _$$ChildSafetyCardImplFromJson(
        Map<String, dynamic> json) =>
    _$ChildSafetyCardImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      memberId: json['member_id'] as String,
      medicalInfo: json['medical_info'] as Map<String, dynamic>? ?? const {},
      emergencyContact: json['emergency_contact'] as String?,
      allergies: (json['allergies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      bloodType: json['blood_type'] as String?,
      lastCheckIn: json['last_check_in'] == null
          ? null
          : DateTime.parse(json['last_check_in'] as String),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ChildSafetyCardImplToJson(
        _$ChildSafetyCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'member_id': instance.memberId,
      'medical_info': instance.medicalInfo,
      'emergency_contact': instance.emergencyContact,
      'allergies': instance.allergies,
      'blood_type': instance.bloodType,
      'last_check_in': instance.lastCheckIn?.toIso8601String(),
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
