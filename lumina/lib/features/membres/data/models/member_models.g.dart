// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberImpl _$$MemberImplFromJson(Map<String, dynamic> json) => _$MemberImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      userId: json['user_id'] as String?,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      displayName: json['display_name'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      photoUrl: json['photo_url'] as String?,
      photoR2Key: json['photo_r2_key'] as String?,
      memberNumber: json['member_number'] as String?,
      status: json['status'] as String? ?? 'active',
      membershipDate: json['membership_date'] == null
          ? null
          : DateTime.parse(json['membership_date'] as String),
      baptismDate: json['baptism_date'] == null
          ? null
          : DateTime.parse(json['baptism_date'] as String),
      shepherdId: json['shepherd_id'] as String?,
      familyId: json['family_id'] as String?,
      maritalStatus: json['marital_status'] as String?,
      occupation: json['occupation'] as String?,
      notes: json['notes'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$MemberImplToJson(_$MemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'display_name': instance.displayName,
      'gender': instance.gender,
      'birth_date': instance.birthDate?.toIso8601String(),
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'photo_url': instance.photoUrl,
      'photo_r2_key': instance.photoR2Key,
      'member_number': instance.memberNumber,
      'status': instance.status,
      'membership_date': instance.membershipDate?.toIso8601String(),
      'baptism_date': instance.baptismDate?.toIso8601String(),
      'shepherd_id': instance.shepherdId,
      'family_id': instance.familyId,
      'marital_status': instance.maritalStatus,
      'occupation': instance.occupation,
      'notes': instance.notes,
      'tags': instance.tags,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$FamilyRelationshipImpl _$$FamilyRelationshipImplFromJson(
        Map<String, dynamic> json) =>
    _$FamilyRelationshipImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      memberId: json['member_id'] as String,
      relatedMemberId: json['related_member_id'] as String,
      relationshipType: json['relationship_type'] as String,
      isPrimary: json['is_primary'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$FamilyRelationshipImplToJson(
        _$FamilyRelationshipImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'member_id': instance.memberId,
      'related_member_id': instance.relatedMemberId,
      'relationship_type': instance.relationshipType,
      'is_primary': instance.isPrimary,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$MemberHistoryImpl _$$MemberHistoryImplFromJson(Map<String, dynamic> json) =>
    _$MemberHistoryImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      memberId: json['member_id'] as String,
      eventType: json['event_type'] as String,
      eventDate: DateTime.parse(json['event_date'] as String),
      description: json['description'] as String?,
      performedBy: json['performed_by'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$MemberHistoryImplToJson(_$MemberHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'member_id': instance.memberId,
      'event_type': instance.eventType,
      'event_date': instance.eventDate.toIso8601String(),
      'description': instance.description,
      'performed_by': instance.performedBy,
      'metadata': instance.metadata,
    };

_$SpiritualTrackingImpl _$$SpiritualTrackingImplFromJson(
        Map<String, dynamic> json) =>
    _$SpiritualTrackingImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      memberId: json['member_id'] as String,
      shepherdId: json['shepherd_id'] as String?,
      lastContactDate: json['last_contact_date'] == null
          ? null
          : DateTime.parse(json['last_contact_date'] as String),
      nextFollowUpDate: json['next_follow_up_date'] == null
          ? null
          : DateTime.parse(json['next_follow_up_date'] as String),
      spiritualLevel: json['spiritual_level'] as String?,
      prayerRequests: json['prayer_requests'] as String?,
      notes: json['notes'] as String?,
      growthMilestones: (json['growth_milestones'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SpiritualTrackingImplToJson(
        _$SpiritualTrackingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'member_id': instance.memberId,
      'shepherd_id': instance.shepherdId,
      'last_contact_date': instance.lastContactDate?.toIso8601String(),
      'next_follow_up_date': instance.nextFollowUpDate?.toIso8601String(),
      'spiritual_level': instance.spiritualLevel,
      'prayer_requests': instance.prayerRequests,
      'notes': instance.notes,
      'growth_milestones': instance.growthMilestones,
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
