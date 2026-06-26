// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'professional_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

EmploymentHistory _$EmploymentHistoryFromJson(Map<String, dynamic> json) {
  return _EmploymentHistory.fromJson(json);
}

/// @nodoc
mixin _$EmploymentHistory {
  String get jobTitle => throw _privateConstructorUsedError;
  String get company => throw _privateConstructorUsedError;
  String? get industry => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  bool get isCurrent => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmploymentHistoryCopyWith<EmploymentHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmploymentHistoryCopyWith<$Res> {
  factory $EmploymentHistoryCopyWith(
          EmploymentHistory value, $Res Function(EmploymentHistory) then) =
      _$EmploymentHistoryCopyWithImpl<$Res, EmploymentHistory>;
  @useResult
  $Res call(
      {String jobTitle,
      String company,
      String? industry,
      DateTime? startDate,
      DateTime? endDate,
      bool isCurrent,
      String? description});
}

/// @nodoc
class _$EmploymentHistoryCopyWithImpl<$Res, $Val extends EmploymentHistory>
    implements $EmploymentHistoryCopyWith<$Res> {
  _$EmploymentHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jobTitle = null,
    Object? company = null,
    Object? industry = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isCurrent = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      jobTitle: null == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String,
      company: null == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String,
      industry: freezed == industry
          ? _value.industry
          : industry // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCurrent: null == isCurrent
          ? _value.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmploymentHistoryImplCopyWith<$Res>
    implements $EmploymentHistoryCopyWith<$Res> {
  factory _$$EmploymentHistoryImplCopyWith(_$EmploymentHistoryImpl value,
          $Res Function(_$EmploymentHistoryImpl) then) =
      __$$EmploymentHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String jobTitle,
      String company,
      String? industry,
      DateTime? startDate,
      DateTime? endDate,
      bool isCurrent,
      String? description});
}

/// @nodoc
class __$$EmploymentHistoryImplCopyWithImpl<$Res>
    extends _$EmploymentHistoryCopyWithImpl<$Res, _$EmploymentHistoryImpl>
    implements _$$EmploymentHistoryImplCopyWith<$Res> {
  __$$EmploymentHistoryImplCopyWithImpl(_$EmploymentHistoryImpl _value,
      $Res Function(_$EmploymentHistoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jobTitle = null,
    Object? company = null,
    Object? industry = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isCurrent = null,
    Object? description = freezed,
  }) {
    return _then(_$EmploymentHistoryImpl(
      jobTitle: null == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String,
      company: null == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String,
      industry: freezed == industry
          ? _value.industry
          : industry // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCurrent: null == isCurrent
          ? _value.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmploymentHistoryImpl extends _EmploymentHistory {
  const _$EmploymentHistoryImpl(
      {required this.jobTitle,
      required this.company,
      this.industry,
      this.startDate,
      this.endDate,
      this.isCurrent = true,
      this.description})
      : super._();

  factory _$EmploymentHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmploymentHistoryImplFromJson(json);

  @override
  final String jobTitle;
  @override
  final String company;
  @override
  final String? industry;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  @JsonKey()
  final bool isCurrent;
  @override
  final String? description;

  @override
  String toString() {
    return 'EmploymentHistory(jobTitle: $jobTitle, company: $company, industry: $industry, startDate: $startDate, endDate: $endDate, isCurrent: $isCurrent, description: $description)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmploymentHistoryImpl &&
            (identical(other.jobTitle, jobTitle) ||
                other.jobTitle == jobTitle) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.industry, industry) ||
                other.industry == industry) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isCurrent, isCurrent) ||
                other.isCurrent == isCurrent) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, jobTitle, company, industry,
      startDate, endDate, isCurrent, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmploymentHistoryImplCopyWith<_$EmploymentHistoryImpl> get copyWith =>
      __$$EmploymentHistoryImplCopyWithImpl<_$EmploymentHistoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmploymentHistoryImplToJson(
      this,
    );
  }
}

abstract class _EmploymentHistory extends EmploymentHistory {
  const factory _EmploymentHistory(
      {required final String jobTitle,
      required final String company,
      final String? industry,
      final DateTime? startDate,
      final DateTime? endDate,
      final bool isCurrent,
      final String? description}) = _$EmploymentHistoryImpl;
  const _EmploymentHistory._() : super._();

  factory _EmploymentHistory.fromJson(Map<String, dynamic> json) =
      _$EmploymentHistoryImpl.fromJson;

  @override
  String get jobTitle;
  @override
  String get company;
  @override
  String? get industry;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  bool get isCurrent;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$EmploymentHistoryImplCopyWith<_$EmploymentHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfessionalInfo _$ProfessionalInfoFromJson(Map<String, dynamic> json) {
  return _ProfessionalInfo.fromJson(json);
}

/// @nodoc
mixin _$ProfessionalInfo {
// Situation actuelle
  EmploymentStatus get status => throw _privateConstructorUsedError;
  String? get currentJobTitle => throw _privateConstructorUsedError;
  String? get currentCompany => throw _privateConstructorUsedError;
  String? get industry => throw _privateConstructorUsedError;
  String? get department => throw _privateConstructorUsedError;
  String? get workAddress => throw _privateConstructorUsedError;
  String? get workPhone => throw _privateConstructorUsedError;
  String? get workEmail => throw _privateConstructorUsedError; // Historique
  List<EmploymentHistory> get employmentHistory =>
      throw _privateConstructorUsedError; // Formation
  EducationLevel get educationLevel => throw _privateConstructorUsedError;
  String? get highestDegree => throw _privateConstructorUsedError;
  String? get university => throw _privateConstructorUsedError;
  String? get fieldOfStudy => throw _privateConstructorUsedError;
  int? get graduationYear => throw _privateConstructorUsedError;
  List<String> get certifications => throw _privateConstructorUsedError;
  List<String> get specializations =>
      throw _privateConstructorUsedError; // Compétences
  List<String> get skills => throw _privateConstructorUsedError;
  List<String> get languages =>
      throw _privateConstructorUsedError; // Revenus (sensible - accès restreint)
  String? get incomeRange => throw _privateConstructorUsedError;
  bool get isFinanciallyStable =>
      throw _privateConstructorUsedError; // Disponibilité pour aider
  List<String> get canHelpWith => throw _privateConstructorUsedError;
  List<String> get professionalGifts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfessionalInfoCopyWith<ProfessionalInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfessionalInfoCopyWith<$Res> {
  factory $ProfessionalInfoCopyWith(
          ProfessionalInfo value, $Res Function(ProfessionalInfo) then) =
      _$ProfessionalInfoCopyWithImpl<$Res, ProfessionalInfo>;
  @useResult
  $Res call(
      {EmploymentStatus status,
      String? currentJobTitle,
      String? currentCompany,
      String? industry,
      String? department,
      String? workAddress,
      String? workPhone,
      String? workEmail,
      List<EmploymentHistory> employmentHistory,
      EducationLevel educationLevel,
      String? highestDegree,
      String? university,
      String? fieldOfStudy,
      int? graduationYear,
      List<String> certifications,
      List<String> specializations,
      List<String> skills,
      List<String> languages,
      String? incomeRange,
      bool isFinanciallyStable,
      List<String> canHelpWith,
      List<String> professionalGifts});
}

/// @nodoc
class _$ProfessionalInfoCopyWithImpl<$Res, $Val extends ProfessionalInfo>
    implements $ProfessionalInfoCopyWith<$Res> {
  _$ProfessionalInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? currentJobTitle = freezed,
    Object? currentCompany = freezed,
    Object? industry = freezed,
    Object? department = freezed,
    Object? workAddress = freezed,
    Object? workPhone = freezed,
    Object? workEmail = freezed,
    Object? employmentHistory = null,
    Object? educationLevel = null,
    Object? highestDegree = freezed,
    Object? university = freezed,
    Object? fieldOfStudy = freezed,
    Object? graduationYear = freezed,
    Object? certifications = null,
    Object? specializations = null,
    Object? skills = null,
    Object? languages = null,
    Object? incomeRange = freezed,
    Object? isFinanciallyStable = null,
    Object? canHelpWith = null,
    Object? professionalGifts = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EmploymentStatus,
      currentJobTitle: freezed == currentJobTitle
          ? _value.currentJobTitle
          : currentJobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      currentCompany: freezed == currentCompany
          ? _value.currentCompany
          : currentCompany // ignore: cast_nullable_to_non_nullable
              as String?,
      industry: freezed == industry
          ? _value.industry
          : industry // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      workAddress: freezed == workAddress
          ? _value.workAddress
          : workAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      workPhone: freezed == workPhone
          ? _value.workPhone
          : workPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      workEmail: freezed == workEmail
          ? _value.workEmail
          : workEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      employmentHistory: null == employmentHistory
          ? _value.employmentHistory
          : employmentHistory // ignore: cast_nullable_to_non_nullable
              as List<EmploymentHistory>,
      educationLevel: null == educationLevel
          ? _value.educationLevel
          : educationLevel // ignore: cast_nullable_to_non_nullable
              as EducationLevel,
      highestDegree: freezed == highestDegree
          ? _value.highestDegree
          : highestDegree // ignore: cast_nullable_to_non_nullable
              as String?,
      university: freezed == university
          ? _value.university
          : university // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldOfStudy: freezed == fieldOfStudy
          ? _value.fieldOfStudy
          : fieldOfStudy // ignore: cast_nullable_to_non_nullable
              as String?,
      graduationYear: freezed == graduationYear
          ? _value.graduationYear
          : graduationYear // ignore: cast_nullable_to_non_nullable
              as int?,
      certifications: null == certifications
          ? _value.certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<String>,
      specializations: null == specializations
          ? _value.specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      skills: null == skills
          ? _value.skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      languages: null == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      incomeRange: freezed == incomeRange
          ? _value.incomeRange
          : incomeRange // ignore: cast_nullable_to_non_nullable
              as String?,
      isFinanciallyStable: null == isFinanciallyStable
          ? _value.isFinanciallyStable
          : isFinanciallyStable // ignore: cast_nullable_to_non_nullable
              as bool,
      canHelpWith: null == canHelpWith
          ? _value.canHelpWith
          : canHelpWith // ignore: cast_nullable_to_non_nullable
              as List<String>,
      professionalGifts: null == professionalGifts
          ? _value.professionalGifts
          : professionalGifts // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfessionalInfoImplCopyWith<$Res>
    implements $ProfessionalInfoCopyWith<$Res> {
  factory _$$ProfessionalInfoImplCopyWith(_$ProfessionalInfoImpl value,
          $Res Function(_$ProfessionalInfoImpl) then) =
      __$$ProfessionalInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {EmploymentStatus status,
      String? currentJobTitle,
      String? currentCompany,
      String? industry,
      String? department,
      String? workAddress,
      String? workPhone,
      String? workEmail,
      List<EmploymentHistory> employmentHistory,
      EducationLevel educationLevel,
      String? highestDegree,
      String? university,
      String? fieldOfStudy,
      int? graduationYear,
      List<String> certifications,
      List<String> specializations,
      List<String> skills,
      List<String> languages,
      String? incomeRange,
      bool isFinanciallyStable,
      List<String> canHelpWith,
      List<String> professionalGifts});
}

/// @nodoc
class __$$ProfessionalInfoImplCopyWithImpl<$Res>
    extends _$ProfessionalInfoCopyWithImpl<$Res, _$ProfessionalInfoImpl>
    implements _$$ProfessionalInfoImplCopyWith<$Res> {
  __$$ProfessionalInfoImplCopyWithImpl(_$ProfessionalInfoImpl _value,
      $Res Function(_$ProfessionalInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? currentJobTitle = freezed,
    Object? currentCompany = freezed,
    Object? industry = freezed,
    Object? department = freezed,
    Object? workAddress = freezed,
    Object? workPhone = freezed,
    Object? workEmail = freezed,
    Object? employmentHistory = null,
    Object? educationLevel = null,
    Object? highestDegree = freezed,
    Object? university = freezed,
    Object? fieldOfStudy = freezed,
    Object? graduationYear = freezed,
    Object? certifications = null,
    Object? specializations = null,
    Object? skills = null,
    Object? languages = null,
    Object? incomeRange = freezed,
    Object? isFinanciallyStable = null,
    Object? canHelpWith = null,
    Object? professionalGifts = null,
  }) {
    return _then(_$ProfessionalInfoImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EmploymentStatus,
      currentJobTitle: freezed == currentJobTitle
          ? _value.currentJobTitle
          : currentJobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      currentCompany: freezed == currentCompany
          ? _value.currentCompany
          : currentCompany // ignore: cast_nullable_to_non_nullable
              as String?,
      industry: freezed == industry
          ? _value.industry
          : industry // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      workAddress: freezed == workAddress
          ? _value.workAddress
          : workAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      workPhone: freezed == workPhone
          ? _value.workPhone
          : workPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      workEmail: freezed == workEmail
          ? _value.workEmail
          : workEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      employmentHistory: null == employmentHistory
          ? _value._employmentHistory
          : employmentHistory // ignore: cast_nullable_to_non_nullable
              as List<EmploymentHistory>,
      educationLevel: null == educationLevel
          ? _value.educationLevel
          : educationLevel // ignore: cast_nullable_to_non_nullable
              as EducationLevel,
      highestDegree: freezed == highestDegree
          ? _value.highestDegree
          : highestDegree // ignore: cast_nullable_to_non_nullable
              as String?,
      university: freezed == university
          ? _value.university
          : university // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldOfStudy: freezed == fieldOfStudy
          ? _value.fieldOfStudy
          : fieldOfStudy // ignore: cast_nullable_to_non_nullable
              as String?,
      graduationYear: freezed == graduationYear
          ? _value.graduationYear
          : graduationYear // ignore: cast_nullable_to_non_nullable
              as int?,
      certifications: null == certifications
          ? _value._certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<String>,
      specializations: null == specializations
          ? _value._specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      skills: null == skills
          ? _value._skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      languages: null == languages
          ? _value._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      incomeRange: freezed == incomeRange
          ? _value.incomeRange
          : incomeRange // ignore: cast_nullable_to_non_nullable
              as String?,
      isFinanciallyStable: null == isFinanciallyStable
          ? _value.isFinanciallyStable
          : isFinanciallyStable // ignore: cast_nullable_to_non_nullable
              as bool,
      canHelpWith: null == canHelpWith
          ? _value._canHelpWith
          : canHelpWith // ignore: cast_nullable_to_non_nullable
              as List<String>,
      professionalGifts: null == professionalGifts
          ? _value._professionalGifts
          : professionalGifts // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfessionalInfoImpl extends _ProfessionalInfo {
  const _$ProfessionalInfoImpl(
      {this.status = EmploymentStatus.employed,
      this.currentJobTitle,
      this.currentCompany,
      this.industry,
      this.department,
      this.workAddress,
      this.workPhone,
      this.workEmail,
      final List<EmploymentHistory> employmentHistory = const [],
      this.educationLevel = EducationLevel.highSchool,
      this.highestDegree,
      this.university,
      this.fieldOfStudy,
      this.graduationYear,
      final List<String> certifications = const [],
      final List<String> specializations = const [],
      final List<String> skills = const [],
      final List<String> languages = const [],
      this.incomeRange,
      this.isFinanciallyStable = false,
      final List<String> canHelpWith = const [],
      final List<String> professionalGifts = const []})
      : _employmentHistory = employmentHistory,
        _certifications = certifications,
        _specializations = specializations,
        _skills = skills,
        _languages = languages,
        _canHelpWith = canHelpWith,
        _professionalGifts = professionalGifts,
        super._();

  factory _$ProfessionalInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfessionalInfoImplFromJson(json);

// Situation actuelle
  @override
  @JsonKey()
  final EmploymentStatus status;
  @override
  final String? currentJobTitle;
  @override
  final String? currentCompany;
  @override
  final String? industry;
  @override
  final String? department;
  @override
  final String? workAddress;
  @override
  final String? workPhone;
  @override
  final String? workEmail;
// Historique
  final List<EmploymentHistory> _employmentHistory;
// Historique
  @override
  @JsonKey()
  List<EmploymentHistory> get employmentHistory {
    if (_employmentHistory is EqualUnmodifiableListView)
      return _employmentHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_employmentHistory);
  }

// Formation
  @override
  @JsonKey()
  final EducationLevel educationLevel;
  @override
  final String? highestDegree;
  @override
  final String? university;
  @override
  final String? fieldOfStudy;
  @override
  final int? graduationYear;
  final List<String> _certifications;
  @override
  @JsonKey()
  List<String> get certifications {
    if (_certifications is EqualUnmodifiableListView) return _certifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_certifications);
  }

  final List<String> _specializations;
  @override
  @JsonKey()
  List<String> get specializations {
    if (_specializations is EqualUnmodifiableListView) return _specializations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specializations);
  }

// Compétences
  final List<String> _skills;
// Compétences
  @override
  @JsonKey()
  List<String> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  final List<String> _languages;
  @override
  @JsonKey()
  List<String> get languages {
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_languages);
  }

// Revenus (sensible - accès restreint)
  @override
  final String? incomeRange;
  @override
  @JsonKey()
  final bool isFinanciallyStable;
// Disponibilité pour aider
  final List<String> _canHelpWith;
// Disponibilité pour aider
  @override
  @JsonKey()
  List<String> get canHelpWith {
    if (_canHelpWith is EqualUnmodifiableListView) return _canHelpWith;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_canHelpWith);
  }

  final List<String> _professionalGifts;
  @override
  @JsonKey()
  List<String> get professionalGifts {
    if (_professionalGifts is EqualUnmodifiableListView)
      return _professionalGifts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_professionalGifts);
  }

  @override
  String toString() {
    return 'ProfessionalInfo(status: $status, currentJobTitle: $currentJobTitle, currentCompany: $currentCompany, industry: $industry, department: $department, workAddress: $workAddress, workPhone: $workPhone, workEmail: $workEmail, employmentHistory: $employmentHistory, educationLevel: $educationLevel, highestDegree: $highestDegree, university: $university, fieldOfStudy: $fieldOfStudy, graduationYear: $graduationYear, certifications: $certifications, specializations: $specializations, skills: $skills, languages: $languages, incomeRange: $incomeRange, isFinanciallyStable: $isFinanciallyStable, canHelpWith: $canHelpWith, professionalGifts: $professionalGifts)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfessionalInfoImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentJobTitle, currentJobTitle) ||
                other.currentJobTitle == currentJobTitle) &&
            (identical(other.currentCompany, currentCompany) ||
                other.currentCompany == currentCompany) &&
            (identical(other.industry, industry) ||
                other.industry == industry) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.workAddress, workAddress) ||
                other.workAddress == workAddress) &&
            (identical(other.workPhone, workPhone) ||
                other.workPhone == workPhone) &&
            (identical(other.workEmail, workEmail) ||
                other.workEmail == workEmail) &&
            const DeepCollectionEquality()
                .equals(other._employmentHistory, _employmentHistory) &&
            (identical(other.educationLevel, educationLevel) ||
                other.educationLevel == educationLevel) &&
            (identical(other.highestDegree, highestDegree) ||
                other.highestDegree == highestDegree) &&
            (identical(other.university, university) ||
                other.university == university) &&
            (identical(other.fieldOfStudy, fieldOfStudy) ||
                other.fieldOfStudy == fieldOfStudy) &&
            (identical(other.graduationYear, graduationYear) ||
                other.graduationYear == graduationYear) &&
            const DeepCollectionEquality()
                .equals(other._certifications, _certifications) &&
            const DeepCollectionEquality()
                .equals(other._specializations, _specializations) &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages) &&
            (identical(other.incomeRange, incomeRange) ||
                other.incomeRange == incomeRange) &&
            (identical(other.isFinanciallyStable, isFinanciallyStable) ||
                other.isFinanciallyStable == isFinanciallyStable) &&
            const DeepCollectionEquality()
                .equals(other._canHelpWith, _canHelpWith) &&
            const DeepCollectionEquality()
                .equals(other._professionalGifts, _professionalGifts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        status,
        currentJobTitle,
        currentCompany,
        industry,
        department,
        workAddress,
        workPhone,
        workEmail,
        const DeepCollectionEquality().hash(_employmentHistory),
        educationLevel,
        highestDegree,
        university,
        fieldOfStudy,
        graduationYear,
        const DeepCollectionEquality().hash(_certifications),
        const DeepCollectionEquality().hash(_specializations),
        const DeepCollectionEquality().hash(_skills),
        const DeepCollectionEquality().hash(_languages),
        incomeRange,
        isFinanciallyStable,
        const DeepCollectionEquality().hash(_canHelpWith),
        const DeepCollectionEquality().hash(_professionalGifts)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfessionalInfoImplCopyWith<_$ProfessionalInfoImpl> get copyWith =>
      __$$ProfessionalInfoImplCopyWithImpl<_$ProfessionalInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfessionalInfoImplToJson(
      this,
    );
  }
}

abstract class _ProfessionalInfo extends ProfessionalInfo {
  const factory _ProfessionalInfo(
      {final EmploymentStatus status,
      final String? currentJobTitle,
      final String? currentCompany,
      final String? industry,
      final String? department,
      final String? workAddress,
      final String? workPhone,
      final String? workEmail,
      final List<EmploymentHistory> employmentHistory,
      final EducationLevel educationLevel,
      final String? highestDegree,
      final String? university,
      final String? fieldOfStudy,
      final int? graduationYear,
      final List<String> certifications,
      final List<String> specializations,
      final List<String> skills,
      final List<String> languages,
      final String? incomeRange,
      final bool isFinanciallyStable,
      final List<String> canHelpWith,
      final List<String> professionalGifts}) = _$ProfessionalInfoImpl;
  const _ProfessionalInfo._() : super._();

  factory _ProfessionalInfo.fromJson(Map<String, dynamic> json) =
      _$ProfessionalInfoImpl.fromJson;

  @override // Situation actuelle
  EmploymentStatus get status;
  @override
  String? get currentJobTitle;
  @override
  String? get currentCompany;
  @override
  String? get industry;
  @override
  String? get department;
  @override
  String? get workAddress;
  @override
  String? get workPhone;
  @override
  String? get workEmail;
  @override // Historique
  List<EmploymentHistory> get employmentHistory;
  @override // Formation
  EducationLevel get educationLevel;
  @override
  String? get highestDegree;
  @override
  String? get university;
  @override
  String? get fieldOfStudy;
  @override
  int? get graduationYear;
  @override
  List<String> get certifications;
  @override
  List<String> get specializations;
  @override // Compétences
  List<String> get skills;
  @override
  List<String> get languages;
  @override // Revenus (sensible - accès restreint)
  String? get incomeRange;
  @override
  bool get isFinanciallyStable;
  @override // Disponibilité pour aider
  List<String> get canHelpWith;
  @override
  List<String> get professionalGifts;
  @override
  @JsonKey(ignore: true)
  _$$ProfessionalInfoImplCopyWith<_$ProfessionalInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
