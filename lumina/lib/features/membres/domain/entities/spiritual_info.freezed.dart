// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spiritual_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SpiritualMilestone _$SpiritualMilestoneFromJson(Map<String, dynamic> json) {
  return _SpiritualMilestone.fromJson(json);
}

/// @nodoc
mixin _$SpiritualMilestone {
  String get name => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get officiant =>
      throw _privateConstructorUsedError; // Pasteur/Officiant
  String? get witnesses => throw _privateConstructorUsedError; // Témoins
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpiritualMilestoneCopyWith<SpiritualMilestone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpiritualMilestoneCopyWith<$Res> {
  factory $SpiritualMilestoneCopyWith(
          SpiritualMilestone value, $Res Function(SpiritualMilestone) then) =
      _$SpiritualMilestoneCopyWithImpl<$Res, SpiritualMilestone>;
  @useResult
  $Res call(
      {String name,
      DateTime? date,
      String? location,
      String? officiant,
      String? witnesses,
      String? notes});
}

/// @nodoc
class _$SpiritualMilestoneCopyWithImpl<$Res, $Val extends SpiritualMilestone>
    implements $SpiritualMilestoneCopyWith<$Res> {
  _$SpiritualMilestoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? date = freezed,
    Object? location = freezed,
    Object? officiant = freezed,
    Object? witnesses = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      officiant: freezed == officiant
          ? _value.officiant
          : officiant // ignore: cast_nullable_to_non_nullable
              as String?,
      witnesses: freezed == witnesses
          ? _value.witnesses
          : witnesses // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpiritualMilestoneImplCopyWith<$Res>
    implements $SpiritualMilestoneCopyWith<$Res> {
  factory _$$SpiritualMilestoneImplCopyWith(_$SpiritualMilestoneImpl value,
          $Res Function(_$SpiritualMilestoneImpl) then) =
      __$$SpiritualMilestoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      DateTime? date,
      String? location,
      String? officiant,
      String? witnesses,
      String? notes});
}

/// @nodoc
class __$$SpiritualMilestoneImplCopyWithImpl<$Res>
    extends _$SpiritualMilestoneCopyWithImpl<$Res, _$SpiritualMilestoneImpl>
    implements _$$SpiritualMilestoneImplCopyWith<$Res> {
  __$$SpiritualMilestoneImplCopyWithImpl(_$SpiritualMilestoneImpl _value,
      $Res Function(_$SpiritualMilestoneImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? date = freezed,
    Object? location = freezed,
    Object? officiant = freezed,
    Object? witnesses = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$SpiritualMilestoneImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      officiant: freezed == officiant
          ? _value.officiant
          : officiant // ignore: cast_nullable_to_non_nullable
              as String?,
      witnesses: freezed == witnesses
          ? _value.witnesses
          : witnesses // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpiritualMilestoneImpl implements _SpiritualMilestone {
  const _$SpiritualMilestoneImpl(
      {required this.name,
      this.date,
      this.location,
      this.officiant,
      this.witnesses,
      this.notes});

  factory _$SpiritualMilestoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpiritualMilestoneImplFromJson(json);

  @override
  final String name;
  @override
  final DateTime? date;
  @override
  final String? location;
  @override
  final String? officiant;
// Pasteur/Officiant
  @override
  final String? witnesses;
// Témoins
  @override
  final String? notes;

  @override
  String toString() {
    return 'SpiritualMilestone(name: $name, date: $date, location: $location, officiant: $officiant, witnesses: $witnesses, notes: $notes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpiritualMilestoneImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.officiant, officiant) ||
                other.officiant == officiant) &&
            (identical(other.witnesses, witnesses) ||
                other.witnesses == witnesses) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, date, location, officiant, witnesses, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpiritualMilestoneImplCopyWith<_$SpiritualMilestoneImpl> get copyWith =>
      __$$SpiritualMilestoneImplCopyWithImpl<_$SpiritualMilestoneImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpiritualMilestoneImplToJson(
      this,
    );
  }
}

abstract class _SpiritualMilestone implements SpiritualMilestone {
  const factory _SpiritualMilestone(
      {required final String name,
      final DateTime? date,
      final String? location,
      final String? officiant,
      final String? witnesses,
      final String? notes}) = _$SpiritualMilestoneImpl;

  factory _SpiritualMilestone.fromJson(Map<String, dynamic> json) =
      _$SpiritualMilestoneImpl.fromJson;

  @override
  String get name;
  @override
  DateTime? get date;
  @override
  String? get location;
  @override
  String? get officiant;
  @override // Pasteur/Officiant
  String? get witnesses;
  @override // Témoins
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$SpiritualMilestoneImplCopyWith<_$SpiritualMilestoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpiritualInfo _$SpiritualInfoFromJson(Map<String, dynamic> json) {
  return _SpiritualInfo.fromJson(json);
}

/// @nodoc
mixin _$SpiritualInfo {
// Conversion
  bool get isConverted => throw _privateConstructorUsedError;
  DateTime? get conversionDate => throw _privateConstructorUsedError;
  String? get conversionStory => throw _privateConstructorUsedError;
  String? get conversionPlace => throw _privateConstructorUsedError; // Baptême
  bool get isBaptized => throw _privateConstructorUsedError;
  DateTime? get baptismDate => throw _privateConstructorUsedError;
  String? get baptismPlace => throw _privateConstructorUsedError;
  String? get baptismOfficiant =>
      throw _privateConstructorUsedError; // Qui a baptisé
  BaptismType get baptismType => throw _privateConstructorUsedError;
  String? get godfather =>
      throw _privateConstructorUsedError; // Parrain spirituel
  String? get godmother =>
      throw _privateConstructorUsedError; // Marraine spirituelle
// Formation biblique
  bool get hasCompletedBibleStudy => throw _privateConstructorUsedError;
  bool get hasCompletedMembershipClass => throw _privateConstructorUsedError;
  bool get isCurrentlyInFormation => throw _privateConstructorUsedError;
  String? get currentFormation => throw _privateConstructorUsedError;
  List<String> get completedFormations =>
      throw _privateConstructorUsedError; // Engagement
  bool get hasSignedMembershipCovenent =>
      throw _privateConstructorUsedError; // Pacte d'adhésion
  DateTime? get membershipDate => throw _privateConstructorUsedError;
  String? get previousChurch => throw _privateConstructorUsedError;
  String? get reasonForTransfer => throw _privateConstructorUsedError;
  DateTime? get transferDate => throw _privateConstructorUsedError;
  String? get transferCertificate =>
      throw _privateConstructorUsedError; // Discipline (si applicable)
  bool get isUnderDiscipline => throw _privateConstructorUsedError;
  DateTime? get disciplineStartDate => throw _privateConstructorUsedError;
  String? get disciplineReason => throw _privateConstructorUsedError;
  DateTime? get restorationDate =>
      throw _privateConstructorUsedError; // Étapes importantes
  List<SpiritualMilestone> get milestones =>
      throw _privateConstructorUsedError; // Dons spirituels identifiés
  List<String> get spiritualGifts =>
      throw _privateConstructorUsedError; // Croissance
  String? get discipleshipLevel => throw _privateConstructorUsedError;
  String? get mentor => throw _privateConstructorUsedError; // Mentor spirituel
  List<String> get mentees => throw _privateConstructorUsedError; // Disciples
// Témoignage
  String? get shortTestimony => throw _privateConstructorUsedError;
  String? get fullTestimony =>
      throw _privateConstructorUsedError; // Notes pastorales (accès restreint)
  String? get pastoralNotes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpiritualInfoCopyWith<SpiritualInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpiritualInfoCopyWith<$Res> {
  factory $SpiritualInfoCopyWith(
          SpiritualInfo value, $Res Function(SpiritualInfo) then) =
      _$SpiritualInfoCopyWithImpl<$Res, SpiritualInfo>;
  @useResult
  $Res call(
      {bool isConverted,
      DateTime? conversionDate,
      String? conversionStory,
      String? conversionPlace,
      bool isBaptized,
      DateTime? baptismDate,
      String? baptismPlace,
      String? baptismOfficiant,
      BaptismType baptismType,
      String? godfather,
      String? godmother,
      bool hasCompletedBibleStudy,
      bool hasCompletedMembershipClass,
      bool isCurrentlyInFormation,
      String? currentFormation,
      List<String> completedFormations,
      bool hasSignedMembershipCovenent,
      DateTime? membershipDate,
      String? previousChurch,
      String? reasonForTransfer,
      DateTime? transferDate,
      String? transferCertificate,
      bool isUnderDiscipline,
      DateTime? disciplineStartDate,
      String? disciplineReason,
      DateTime? restorationDate,
      List<SpiritualMilestone> milestones,
      List<String> spiritualGifts,
      String? discipleshipLevel,
      String? mentor,
      List<String> mentees,
      String? shortTestimony,
      String? fullTestimony,
      String? pastoralNotes});
}

/// @nodoc
class _$SpiritualInfoCopyWithImpl<$Res, $Val extends SpiritualInfo>
    implements $SpiritualInfoCopyWith<$Res> {
  _$SpiritualInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isConverted = null,
    Object? conversionDate = freezed,
    Object? conversionStory = freezed,
    Object? conversionPlace = freezed,
    Object? isBaptized = null,
    Object? baptismDate = freezed,
    Object? baptismPlace = freezed,
    Object? baptismOfficiant = freezed,
    Object? baptismType = null,
    Object? godfather = freezed,
    Object? godmother = freezed,
    Object? hasCompletedBibleStudy = null,
    Object? hasCompletedMembershipClass = null,
    Object? isCurrentlyInFormation = null,
    Object? currentFormation = freezed,
    Object? completedFormations = null,
    Object? hasSignedMembershipCovenent = null,
    Object? membershipDate = freezed,
    Object? previousChurch = freezed,
    Object? reasonForTransfer = freezed,
    Object? transferDate = freezed,
    Object? transferCertificate = freezed,
    Object? isUnderDiscipline = null,
    Object? disciplineStartDate = freezed,
    Object? disciplineReason = freezed,
    Object? restorationDate = freezed,
    Object? milestones = null,
    Object? spiritualGifts = null,
    Object? discipleshipLevel = freezed,
    Object? mentor = freezed,
    Object? mentees = null,
    Object? shortTestimony = freezed,
    Object? fullTestimony = freezed,
    Object? pastoralNotes = freezed,
  }) {
    return _then(_value.copyWith(
      isConverted: null == isConverted
          ? _value.isConverted
          : isConverted // ignore: cast_nullable_to_non_nullable
              as bool,
      conversionDate: freezed == conversionDate
          ? _value.conversionDate
          : conversionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      conversionStory: freezed == conversionStory
          ? _value.conversionStory
          : conversionStory // ignore: cast_nullable_to_non_nullable
              as String?,
      conversionPlace: freezed == conversionPlace
          ? _value.conversionPlace
          : conversionPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      isBaptized: null == isBaptized
          ? _value.isBaptized
          : isBaptized // ignore: cast_nullable_to_non_nullable
              as bool,
      baptismDate: freezed == baptismDate
          ? _value.baptismDate
          : baptismDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      baptismPlace: freezed == baptismPlace
          ? _value.baptismPlace
          : baptismPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      baptismOfficiant: freezed == baptismOfficiant
          ? _value.baptismOfficiant
          : baptismOfficiant // ignore: cast_nullable_to_non_nullable
              as String?,
      baptismType: null == baptismType
          ? _value.baptismType
          : baptismType // ignore: cast_nullable_to_non_nullable
              as BaptismType,
      godfather: freezed == godfather
          ? _value.godfather
          : godfather // ignore: cast_nullable_to_non_nullable
              as String?,
      godmother: freezed == godmother
          ? _value.godmother
          : godmother // ignore: cast_nullable_to_non_nullable
              as String?,
      hasCompletedBibleStudy: null == hasCompletedBibleStudy
          ? _value.hasCompletedBibleStudy
          : hasCompletedBibleStudy // ignore: cast_nullable_to_non_nullable
              as bool,
      hasCompletedMembershipClass: null == hasCompletedMembershipClass
          ? _value.hasCompletedMembershipClass
          : hasCompletedMembershipClass // ignore: cast_nullable_to_non_nullable
              as bool,
      isCurrentlyInFormation: null == isCurrentlyInFormation
          ? _value.isCurrentlyInFormation
          : isCurrentlyInFormation // ignore: cast_nullable_to_non_nullable
              as bool,
      currentFormation: freezed == currentFormation
          ? _value.currentFormation
          : currentFormation // ignore: cast_nullable_to_non_nullable
              as String?,
      completedFormations: null == completedFormations
          ? _value.completedFormations
          : completedFormations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasSignedMembershipCovenent: null == hasSignedMembershipCovenent
          ? _value.hasSignedMembershipCovenent
          : hasSignedMembershipCovenent // ignore: cast_nullable_to_non_nullable
              as bool,
      membershipDate: freezed == membershipDate
          ? _value.membershipDate
          : membershipDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      previousChurch: freezed == previousChurch
          ? _value.previousChurch
          : previousChurch // ignore: cast_nullable_to_non_nullable
              as String?,
      reasonForTransfer: freezed == reasonForTransfer
          ? _value.reasonForTransfer
          : reasonForTransfer // ignore: cast_nullable_to_non_nullable
              as String?,
      transferDate: freezed == transferDate
          ? _value.transferDate
          : transferDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      transferCertificate: freezed == transferCertificate
          ? _value.transferCertificate
          : transferCertificate // ignore: cast_nullable_to_non_nullable
              as String?,
      isUnderDiscipline: null == isUnderDiscipline
          ? _value.isUnderDiscipline
          : isUnderDiscipline // ignore: cast_nullable_to_non_nullable
              as bool,
      disciplineStartDate: freezed == disciplineStartDate
          ? _value.disciplineStartDate
          : disciplineStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      disciplineReason: freezed == disciplineReason
          ? _value.disciplineReason
          : disciplineReason // ignore: cast_nullable_to_non_nullable
              as String?,
      restorationDate: freezed == restorationDate
          ? _value.restorationDate
          : restorationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      milestones: null == milestones
          ? _value.milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<SpiritualMilestone>,
      spiritualGifts: null == spiritualGifts
          ? _value.spiritualGifts
          : spiritualGifts // ignore: cast_nullable_to_non_nullable
              as List<String>,
      discipleshipLevel: freezed == discipleshipLevel
          ? _value.discipleshipLevel
          : discipleshipLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      mentor: freezed == mentor
          ? _value.mentor
          : mentor // ignore: cast_nullable_to_non_nullable
              as String?,
      mentees: null == mentees
          ? _value.mentees
          : mentees // ignore: cast_nullable_to_non_nullable
              as List<String>,
      shortTestimony: freezed == shortTestimony
          ? _value.shortTestimony
          : shortTestimony // ignore: cast_nullable_to_non_nullable
              as String?,
      fullTestimony: freezed == fullTestimony
          ? _value.fullTestimony
          : fullTestimony // ignore: cast_nullable_to_non_nullable
              as String?,
      pastoralNotes: freezed == pastoralNotes
          ? _value.pastoralNotes
          : pastoralNotes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpiritualInfoImplCopyWith<$Res>
    implements $SpiritualInfoCopyWith<$Res> {
  factory _$$SpiritualInfoImplCopyWith(
          _$SpiritualInfoImpl value, $Res Function(_$SpiritualInfoImpl) then) =
      __$$SpiritualInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isConverted,
      DateTime? conversionDate,
      String? conversionStory,
      String? conversionPlace,
      bool isBaptized,
      DateTime? baptismDate,
      String? baptismPlace,
      String? baptismOfficiant,
      BaptismType baptismType,
      String? godfather,
      String? godmother,
      bool hasCompletedBibleStudy,
      bool hasCompletedMembershipClass,
      bool isCurrentlyInFormation,
      String? currentFormation,
      List<String> completedFormations,
      bool hasSignedMembershipCovenent,
      DateTime? membershipDate,
      String? previousChurch,
      String? reasonForTransfer,
      DateTime? transferDate,
      String? transferCertificate,
      bool isUnderDiscipline,
      DateTime? disciplineStartDate,
      String? disciplineReason,
      DateTime? restorationDate,
      List<SpiritualMilestone> milestones,
      List<String> spiritualGifts,
      String? discipleshipLevel,
      String? mentor,
      List<String> mentees,
      String? shortTestimony,
      String? fullTestimony,
      String? pastoralNotes});
}

/// @nodoc
class __$$SpiritualInfoImplCopyWithImpl<$Res>
    extends _$SpiritualInfoCopyWithImpl<$Res, _$SpiritualInfoImpl>
    implements _$$SpiritualInfoImplCopyWith<$Res> {
  __$$SpiritualInfoImplCopyWithImpl(
      _$SpiritualInfoImpl _value, $Res Function(_$SpiritualInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isConverted = null,
    Object? conversionDate = freezed,
    Object? conversionStory = freezed,
    Object? conversionPlace = freezed,
    Object? isBaptized = null,
    Object? baptismDate = freezed,
    Object? baptismPlace = freezed,
    Object? baptismOfficiant = freezed,
    Object? baptismType = null,
    Object? godfather = freezed,
    Object? godmother = freezed,
    Object? hasCompletedBibleStudy = null,
    Object? hasCompletedMembershipClass = null,
    Object? isCurrentlyInFormation = null,
    Object? currentFormation = freezed,
    Object? completedFormations = null,
    Object? hasSignedMembershipCovenent = null,
    Object? membershipDate = freezed,
    Object? previousChurch = freezed,
    Object? reasonForTransfer = freezed,
    Object? transferDate = freezed,
    Object? transferCertificate = freezed,
    Object? isUnderDiscipline = null,
    Object? disciplineStartDate = freezed,
    Object? disciplineReason = freezed,
    Object? restorationDate = freezed,
    Object? milestones = null,
    Object? spiritualGifts = null,
    Object? discipleshipLevel = freezed,
    Object? mentor = freezed,
    Object? mentees = null,
    Object? shortTestimony = freezed,
    Object? fullTestimony = freezed,
    Object? pastoralNotes = freezed,
  }) {
    return _then(_$SpiritualInfoImpl(
      isConverted: null == isConverted
          ? _value.isConverted
          : isConverted // ignore: cast_nullable_to_non_nullable
              as bool,
      conversionDate: freezed == conversionDate
          ? _value.conversionDate
          : conversionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      conversionStory: freezed == conversionStory
          ? _value.conversionStory
          : conversionStory // ignore: cast_nullable_to_non_nullable
              as String?,
      conversionPlace: freezed == conversionPlace
          ? _value.conversionPlace
          : conversionPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      isBaptized: null == isBaptized
          ? _value.isBaptized
          : isBaptized // ignore: cast_nullable_to_non_nullable
              as bool,
      baptismDate: freezed == baptismDate
          ? _value.baptismDate
          : baptismDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      baptismPlace: freezed == baptismPlace
          ? _value.baptismPlace
          : baptismPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      baptismOfficiant: freezed == baptismOfficiant
          ? _value.baptismOfficiant
          : baptismOfficiant // ignore: cast_nullable_to_non_nullable
              as String?,
      baptismType: null == baptismType
          ? _value.baptismType
          : baptismType // ignore: cast_nullable_to_non_nullable
              as BaptismType,
      godfather: freezed == godfather
          ? _value.godfather
          : godfather // ignore: cast_nullable_to_non_nullable
              as String?,
      godmother: freezed == godmother
          ? _value.godmother
          : godmother // ignore: cast_nullable_to_non_nullable
              as String?,
      hasCompletedBibleStudy: null == hasCompletedBibleStudy
          ? _value.hasCompletedBibleStudy
          : hasCompletedBibleStudy // ignore: cast_nullable_to_non_nullable
              as bool,
      hasCompletedMembershipClass: null == hasCompletedMembershipClass
          ? _value.hasCompletedMembershipClass
          : hasCompletedMembershipClass // ignore: cast_nullable_to_non_nullable
              as bool,
      isCurrentlyInFormation: null == isCurrentlyInFormation
          ? _value.isCurrentlyInFormation
          : isCurrentlyInFormation // ignore: cast_nullable_to_non_nullable
              as bool,
      currentFormation: freezed == currentFormation
          ? _value.currentFormation
          : currentFormation // ignore: cast_nullable_to_non_nullable
              as String?,
      completedFormations: null == completedFormations
          ? _value._completedFormations
          : completedFormations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasSignedMembershipCovenent: null == hasSignedMembershipCovenent
          ? _value.hasSignedMembershipCovenent
          : hasSignedMembershipCovenent // ignore: cast_nullable_to_non_nullable
              as bool,
      membershipDate: freezed == membershipDate
          ? _value.membershipDate
          : membershipDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      previousChurch: freezed == previousChurch
          ? _value.previousChurch
          : previousChurch // ignore: cast_nullable_to_non_nullable
              as String?,
      reasonForTransfer: freezed == reasonForTransfer
          ? _value.reasonForTransfer
          : reasonForTransfer // ignore: cast_nullable_to_non_nullable
              as String?,
      transferDate: freezed == transferDate
          ? _value.transferDate
          : transferDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      transferCertificate: freezed == transferCertificate
          ? _value.transferCertificate
          : transferCertificate // ignore: cast_nullable_to_non_nullable
              as String?,
      isUnderDiscipline: null == isUnderDiscipline
          ? _value.isUnderDiscipline
          : isUnderDiscipline // ignore: cast_nullable_to_non_nullable
              as bool,
      disciplineStartDate: freezed == disciplineStartDate
          ? _value.disciplineStartDate
          : disciplineStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      disciplineReason: freezed == disciplineReason
          ? _value.disciplineReason
          : disciplineReason // ignore: cast_nullable_to_non_nullable
              as String?,
      restorationDate: freezed == restorationDate
          ? _value.restorationDate
          : restorationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      milestones: null == milestones
          ? _value._milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<SpiritualMilestone>,
      spiritualGifts: null == spiritualGifts
          ? _value._spiritualGifts
          : spiritualGifts // ignore: cast_nullable_to_non_nullable
              as List<String>,
      discipleshipLevel: freezed == discipleshipLevel
          ? _value.discipleshipLevel
          : discipleshipLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      mentor: freezed == mentor
          ? _value.mentor
          : mentor // ignore: cast_nullable_to_non_nullable
              as String?,
      mentees: null == mentees
          ? _value._mentees
          : mentees // ignore: cast_nullable_to_non_nullable
              as List<String>,
      shortTestimony: freezed == shortTestimony
          ? _value.shortTestimony
          : shortTestimony // ignore: cast_nullable_to_non_nullable
              as String?,
      fullTestimony: freezed == fullTestimony
          ? _value.fullTestimony
          : fullTestimony // ignore: cast_nullable_to_non_nullable
              as String?,
      pastoralNotes: freezed == pastoralNotes
          ? _value.pastoralNotes
          : pastoralNotes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpiritualInfoImpl extends _SpiritualInfo {
  const _$SpiritualInfoImpl(
      {this.isConverted = true,
      this.conversionDate,
      this.conversionStory,
      this.conversionPlace,
      this.isBaptized = false,
      this.baptismDate,
      this.baptismPlace,
      this.baptismOfficiant,
      this.baptismType = BaptismType.immersion,
      this.godfather,
      this.godmother,
      this.hasCompletedBibleStudy = false,
      this.hasCompletedMembershipClass = false,
      this.isCurrentlyInFormation = false,
      this.currentFormation,
      final List<String> completedFormations = const [],
      this.hasSignedMembershipCovenent = false,
      this.membershipDate,
      this.previousChurch,
      this.reasonForTransfer,
      this.transferDate,
      this.transferCertificate,
      this.isUnderDiscipline = false,
      this.disciplineStartDate,
      this.disciplineReason,
      this.restorationDate,
      final List<SpiritualMilestone> milestones = const [],
      final List<String> spiritualGifts = const [],
      this.discipleshipLevel,
      this.mentor,
      final List<String> mentees = const [],
      this.shortTestimony,
      this.fullTestimony,
      this.pastoralNotes})
      : _completedFormations = completedFormations,
        _milestones = milestones,
        _spiritualGifts = spiritualGifts,
        _mentees = mentees,
        super._();

  factory _$SpiritualInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpiritualInfoImplFromJson(json);

// Conversion
  @override
  @JsonKey()
  final bool isConverted;
  @override
  final DateTime? conversionDate;
  @override
  final String? conversionStory;
  @override
  final String? conversionPlace;
// Baptême
  @override
  @JsonKey()
  final bool isBaptized;
  @override
  final DateTime? baptismDate;
  @override
  final String? baptismPlace;
  @override
  final String? baptismOfficiant;
// Qui a baptisé
  @override
  @JsonKey()
  final BaptismType baptismType;
  @override
  final String? godfather;
// Parrain spirituel
  @override
  final String? godmother;
// Marraine spirituelle
// Formation biblique
  @override
  @JsonKey()
  final bool hasCompletedBibleStudy;
  @override
  @JsonKey()
  final bool hasCompletedMembershipClass;
  @override
  @JsonKey()
  final bool isCurrentlyInFormation;
  @override
  final String? currentFormation;
  final List<String> _completedFormations;
  @override
  @JsonKey()
  List<String> get completedFormations {
    if (_completedFormations is EqualUnmodifiableListView)
      return _completedFormations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedFormations);
  }

// Engagement
  @override
  @JsonKey()
  final bool hasSignedMembershipCovenent;
// Pacte d'adhésion
  @override
  final DateTime? membershipDate;
  @override
  final String? previousChurch;
  @override
  final String? reasonForTransfer;
  @override
  final DateTime? transferDate;
  @override
  final String? transferCertificate;
// Discipline (si applicable)
  @override
  @JsonKey()
  final bool isUnderDiscipline;
  @override
  final DateTime? disciplineStartDate;
  @override
  final String? disciplineReason;
  @override
  final DateTime? restorationDate;
// Étapes importantes
  final List<SpiritualMilestone> _milestones;
// Étapes importantes
  @override
  @JsonKey()
  List<SpiritualMilestone> get milestones {
    if (_milestones is EqualUnmodifiableListView) return _milestones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_milestones);
  }

// Dons spirituels identifiés
  final List<String> _spiritualGifts;
// Dons spirituels identifiés
  @override
  @JsonKey()
  List<String> get spiritualGifts {
    if (_spiritualGifts is EqualUnmodifiableListView) return _spiritualGifts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_spiritualGifts);
  }

// Croissance
  @override
  final String? discipleshipLevel;
  @override
  final String? mentor;
// Mentor spirituel
  final List<String> _mentees;
// Mentor spirituel
  @override
  @JsonKey()
  List<String> get mentees {
    if (_mentees is EqualUnmodifiableListView) return _mentees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mentees);
  }

// Disciples
// Témoignage
  @override
  final String? shortTestimony;
  @override
  final String? fullTestimony;
// Notes pastorales (accès restreint)
  @override
  final String? pastoralNotes;

  @override
  String toString() {
    return 'SpiritualInfo(isConverted: $isConverted, conversionDate: $conversionDate, conversionStory: $conversionStory, conversionPlace: $conversionPlace, isBaptized: $isBaptized, baptismDate: $baptismDate, baptismPlace: $baptismPlace, baptismOfficiant: $baptismOfficiant, baptismType: $baptismType, godfather: $godfather, godmother: $godmother, hasCompletedBibleStudy: $hasCompletedBibleStudy, hasCompletedMembershipClass: $hasCompletedMembershipClass, isCurrentlyInFormation: $isCurrentlyInFormation, currentFormation: $currentFormation, completedFormations: $completedFormations, hasSignedMembershipCovenent: $hasSignedMembershipCovenent, membershipDate: $membershipDate, previousChurch: $previousChurch, reasonForTransfer: $reasonForTransfer, transferDate: $transferDate, transferCertificate: $transferCertificate, isUnderDiscipline: $isUnderDiscipline, disciplineStartDate: $disciplineStartDate, disciplineReason: $disciplineReason, restorationDate: $restorationDate, milestones: $milestones, spiritualGifts: $spiritualGifts, discipleshipLevel: $discipleshipLevel, mentor: $mentor, mentees: $mentees, shortTestimony: $shortTestimony, fullTestimony: $fullTestimony, pastoralNotes: $pastoralNotes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpiritualInfoImpl &&
            (identical(other.isConverted, isConverted) ||
                other.isConverted == isConverted) &&
            (identical(other.conversionDate, conversionDate) ||
                other.conversionDate == conversionDate) &&
            (identical(other.conversionStory, conversionStory) ||
                other.conversionStory == conversionStory) &&
            (identical(other.conversionPlace, conversionPlace) ||
                other.conversionPlace == conversionPlace) &&
            (identical(other.isBaptized, isBaptized) ||
                other.isBaptized == isBaptized) &&
            (identical(other.baptismDate, baptismDate) ||
                other.baptismDate == baptismDate) &&
            (identical(other.baptismPlace, baptismPlace) ||
                other.baptismPlace == baptismPlace) &&
            (identical(other.baptismOfficiant, baptismOfficiant) ||
                other.baptismOfficiant == baptismOfficiant) &&
            (identical(other.baptismType, baptismType) ||
                other.baptismType == baptismType) &&
            (identical(other.godfather, godfather) ||
                other.godfather == godfather) &&
            (identical(other.godmother, godmother) ||
                other.godmother == godmother) &&
            (identical(other.hasCompletedBibleStudy, hasCompletedBibleStudy) ||
                other.hasCompletedBibleStudy == hasCompletedBibleStudy) &&
            (identical(other.hasCompletedMembershipClass, hasCompletedMembershipClass) ||
                other.hasCompletedMembershipClass ==
                    hasCompletedMembershipClass) &&
            (identical(other.isCurrentlyInFormation, isCurrentlyInFormation) ||
                other.isCurrentlyInFormation == isCurrentlyInFormation) &&
            (identical(other.currentFormation, currentFormation) ||
                other.currentFormation == currentFormation) &&
            const DeepCollectionEquality()
                .equals(other._completedFormations, _completedFormations) &&
            (identical(other.hasSignedMembershipCovenent, hasSignedMembershipCovenent) ||
                other.hasSignedMembershipCovenent ==
                    hasSignedMembershipCovenent) &&
            (identical(other.membershipDate, membershipDate) ||
                other.membershipDate == membershipDate) &&
            (identical(other.previousChurch, previousChurch) ||
                other.previousChurch == previousChurch) &&
            (identical(other.reasonForTransfer, reasonForTransfer) ||
                other.reasonForTransfer == reasonForTransfer) &&
            (identical(other.transferDate, transferDate) ||
                other.transferDate == transferDate) &&
            (identical(other.transferCertificate, transferCertificate) ||
                other.transferCertificate == transferCertificate) &&
            (identical(other.isUnderDiscipline, isUnderDiscipline) ||
                other.isUnderDiscipline == isUnderDiscipline) &&
            (identical(other.disciplineStartDate, disciplineStartDate) ||
                other.disciplineStartDate == disciplineStartDate) &&
            (identical(other.disciplineReason, disciplineReason) ||
                other.disciplineReason == disciplineReason) &&
            (identical(other.restorationDate, restorationDate) ||
                other.restorationDate == restorationDate) &&
            const DeepCollectionEquality()
                .equals(other._milestones, _milestones) &&
            const DeepCollectionEquality()
                .equals(other._spiritualGifts, _spiritualGifts) &&
            (identical(other.discipleshipLevel, discipleshipLevel) ||
                other.discipleshipLevel == discipleshipLevel) &&
            (identical(other.mentor, mentor) || other.mentor == mentor) &&
            const DeepCollectionEquality().equals(other._mentees, _mentees) &&
            (identical(other.shortTestimony, shortTestimony) ||
                other.shortTestimony == shortTestimony) &&
            (identical(other.fullTestimony, fullTestimony) ||
                other.fullTestimony == fullTestimony) &&
            (identical(other.pastoralNotes, pastoralNotes) ||
                other.pastoralNotes == pastoralNotes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        isConverted,
        conversionDate,
        conversionStory,
        conversionPlace,
        isBaptized,
        baptismDate,
        baptismPlace,
        baptismOfficiant,
        baptismType,
        godfather,
        godmother,
        hasCompletedBibleStudy,
        hasCompletedMembershipClass,
        isCurrentlyInFormation,
        currentFormation,
        const DeepCollectionEquality().hash(_completedFormations),
        hasSignedMembershipCovenent,
        membershipDate,
        previousChurch,
        reasonForTransfer,
        transferDate,
        transferCertificate,
        isUnderDiscipline,
        disciplineStartDate,
        disciplineReason,
        restorationDate,
        const DeepCollectionEquality().hash(_milestones),
        const DeepCollectionEquality().hash(_spiritualGifts),
        discipleshipLevel,
        mentor,
        const DeepCollectionEquality().hash(_mentees),
        shortTestimony,
        fullTestimony,
        pastoralNotes
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpiritualInfoImplCopyWith<_$SpiritualInfoImpl> get copyWith =>
      __$$SpiritualInfoImplCopyWithImpl<_$SpiritualInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpiritualInfoImplToJson(
      this,
    );
  }
}

abstract class _SpiritualInfo extends SpiritualInfo {
  const factory _SpiritualInfo(
      {final bool isConverted,
      final DateTime? conversionDate,
      final String? conversionStory,
      final String? conversionPlace,
      final bool isBaptized,
      final DateTime? baptismDate,
      final String? baptismPlace,
      final String? baptismOfficiant,
      final BaptismType baptismType,
      final String? godfather,
      final String? godmother,
      final bool hasCompletedBibleStudy,
      final bool hasCompletedMembershipClass,
      final bool isCurrentlyInFormation,
      final String? currentFormation,
      final List<String> completedFormations,
      final bool hasSignedMembershipCovenent,
      final DateTime? membershipDate,
      final String? previousChurch,
      final String? reasonForTransfer,
      final DateTime? transferDate,
      final String? transferCertificate,
      final bool isUnderDiscipline,
      final DateTime? disciplineStartDate,
      final String? disciplineReason,
      final DateTime? restorationDate,
      final List<SpiritualMilestone> milestones,
      final List<String> spiritualGifts,
      final String? discipleshipLevel,
      final String? mentor,
      final List<String> mentees,
      final String? shortTestimony,
      final String? fullTestimony,
      final String? pastoralNotes}) = _$SpiritualInfoImpl;
  const _SpiritualInfo._() : super._();

  factory _SpiritualInfo.fromJson(Map<String, dynamic> json) =
      _$SpiritualInfoImpl.fromJson;

  @override // Conversion
  bool get isConverted;
  @override
  DateTime? get conversionDate;
  @override
  String? get conversionStory;
  @override
  String? get conversionPlace;
  @override // Baptême
  bool get isBaptized;
  @override
  DateTime? get baptismDate;
  @override
  String? get baptismPlace;
  @override
  String? get baptismOfficiant;
  @override // Qui a baptisé
  BaptismType get baptismType;
  @override
  String? get godfather;
  @override // Parrain spirituel
  String? get godmother;
  @override // Marraine spirituelle
// Formation biblique
  bool get hasCompletedBibleStudy;
  @override
  bool get hasCompletedMembershipClass;
  @override
  bool get isCurrentlyInFormation;
  @override
  String? get currentFormation;
  @override
  List<String> get completedFormations;
  @override // Engagement
  bool get hasSignedMembershipCovenent;
  @override // Pacte d'adhésion
  DateTime? get membershipDate;
  @override
  String? get previousChurch;
  @override
  String? get reasonForTransfer;
  @override
  DateTime? get transferDate;
  @override
  String? get transferCertificate;
  @override // Discipline (si applicable)
  bool get isUnderDiscipline;
  @override
  DateTime? get disciplineStartDate;
  @override
  String? get disciplineReason;
  @override
  DateTime? get restorationDate;
  @override // Étapes importantes
  List<SpiritualMilestone> get milestones;
  @override // Dons spirituels identifiés
  List<String> get spiritualGifts;
  @override // Croissance
  String? get discipleshipLevel;
  @override
  String? get mentor;
  @override // Mentor spirituel
  List<String> get mentees;
  @override // Disciples
// Témoignage
  String? get shortTestimony;
  @override
  String? get fullTestimony;
  @override // Notes pastorales (accès restreint)
  String? get pastoralNotes;
  @override
  @JsonKey(ignore: true)
  _$$SpiritualInfoImplCopyWith<_$SpiritualInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
