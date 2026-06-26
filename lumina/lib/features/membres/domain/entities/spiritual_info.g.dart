// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spiritual_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpiritualMilestoneImpl _$$SpiritualMilestoneImplFromJson(
        Map<String, dynamic> json) =>
    _$SpiritualMilestoneImpl(
      name: json['name'] as String,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      location: json['location'] as String?,
      officiant: json['officiant'] as String?,
      witnesses: json['witnesses'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$SpiritualMilestoneImplToJson(
        _$SpiritualMilestoneImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'date': instance.date?.toIso8601String(),
      'location': instance.location,
      'officiant': instance.officiant,
      'witnesses': instance.witnesses,
      'notes': instance.notes,
    };

_$SpiritualInfoImpl _$$SpiritualInfoImplFromJson(Map<String, dynamic> json) =>
    _$SpiritualInfoImpl(
      isConverted: json['is_converted'] as bool? ?? true,
      conversionDate: json['conversion_date'] == null
          ? null
          : DateTime.parse(json['conversion_date'] as String),
      conversionStory: json['conversion_story'] as String?,
      conversionPlace: json['conversion_place'] as String?,
      isBaptized: json['is_baptized'] as bool? ?? false,
      baptismDate: json['baptism_date'] == null
          ? null
          : DateTime.parse(json['baptism_date'] as String),
      baptismPlace: json['baptism_place'] as String?,
      baptismOfficiant: json['baptism_officiant'] as String?,
      baptismType:
          $enumDecodeNullable(_$BaptismTypeEnumMap, json['baptism_type']) ??
              BaptismType.immersion,
      godfather: json['godfather'] as String?,
      godmother: json['godmother'] as String?,
      hasCompletedBibleStudy:
          json['has_completed_bible_study'] as bool? ?? false,
      hasCompletedMembershipClass:
          json['has_completed_membership_class'] as bool? ?? false,
      isCurrentlyInFormation:
          json['is_currently_in_formation'] as bool? ?? false,
      currentFormation: json['current_formation'] as String?,
      completedFormations: (json['completed_formations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      hasSignedMembershipCovenent:
          json['has_signed_membership_covenent'] as bool? ?? false,
      membershipDate: json['membership_date'] == null
          ? null
          : DateTime.parse(json['membership_date'] as String),
      previousChurch: json['previous_church'] as String?,
      reasonForTransfer: json['reason_for_transfer'] as String?,
      transferDate: json['transfer_date'] == null
          ? null
          : DateTime.parse(json['transfer_date'] as String),
      transferCertificate: json['transfer_certificate'] as String?,
      isUnderDiscipline: json['is_under_discipline'] as bool? ?? false,
      disciplineStartDate: json['discipline_start_date'] == null
          ? null
          : DateTime.parse(json['discipline_start_date'] as String),
      disciplineReason: json['discipline_reason'] as String?,
      restorationDate: json['restoration_date'] == null
          ? null
          : DateTime.parse(json['restoration_date'] as String),
      milestones: (json['milestones'] as List<dynamic>?)
              ?.map(
                  (e) => SpiritualMilestone.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      spiritualGifts: (json['spiritual_gifts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      discipleshipLevel: json['discipleship_level'] as String?,
      mentor: json['mentor'] as String?,
      mentees: (json['mentees'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      shortTestimony: json['short_testimony'] as String?,
      fullTestimony: json['full_testimony'] as String?,
      pastoralNotes: json['pastoral_notes'] as String?,
    );

Map<String, dynamic> _$$SpiritualInfoImplToJson(_$SpiritualInfoImpl instance) =>
    <String, dynamic>{
      'is_converted': instance.isConverted,
      'conversion_date': instance.conversionDate?.toIso8601String(),
      'conversion_story': instance.conversionStory,
      'conversion_place': instance.conversionPlace,
      'is_baptized': instance.isBaptized,
      'baptism_date': instance.baptismDate?.toIso8601String(),
      'baptism_place': instance.baptismPlace,
      'baptism_officiant': instance.baptismOfficiant,
      'baptism_type': _$BaptismTypeEnumMap[instance.baptismType]!,
      'godfather': instance.godfather,
      'godmother': instance.godmother,
      'has_completed_bible_study': instance.hasCompletedBibleStudy,
      'has_completed_membership_class': instance.hasCompletedMembershipClass,
      'is_currently_in_formation': instance.isCurrentlyInFormation,
      'current_formation': instance.currentFormation,
      'completed_formations': instance.completedFormations,
      'has_signed_membership_covenent': instance.hasSignedMembershipCovenent,
      'membership_date': instance.membershipDate?.toIso8601String(),
      'previous_church': instance.previousChurch,
      'reason_for_transfer': instance.reasonForTransfer,
      'transfer_date': instance.transferDate?.toIso8601String(),
      'transfer_certificate': instance.transferCertificate,
      'is_under_discipline': instance.isUnderDiscipline,
      'discipline_start_date': instance.disciplineStartDate?.toIso8601String(),
      'discipline_reason': instance.disciplineReason,
      'restoration_date': instance.restorationDate?.toIso8601String(),
      'milestones': instance.milestones.map((e) => e.toJson()).toList(),
      'spiritual_gifts': instance.spiritualGifts,
      'discipleship_level': instance.discipleshipLevel,
      'mentor': instance.mentor,
      'mentees': instance.mentees,
      'short_testimony': instance.shortTestimony,
      'full_testimony': instance.fullTestimony,
      'pastoral_notes': instance.pastoralNotes,
    };

const _$BaptismTypeEnumMap = {
  BaptismType.immersion: 'immersion',
  BaptismType.sprinkling: 'sprinkling',
  BaptismType.pouring: 'pouring',
  BaptismType.unknown: 'unknown',
};
