// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Event _$EventFromJson(Map<String, dynamic> json) {
  return _Event.fromJson(json);
}

/// @nodoc
mixin _$Event {
  String get id => throw _privateConstructorUsedError;
  String get churchId => throw _privateConstructorUsedError;
  @EventTypeConverter()
  EventType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get managerId => throw _privateConstructorUsedError;
  String? get officiantName => throw _privateConstructorUsedError;
  int? get estimatedParticipants => throw _privateConstructorUsedError;
  int? get actualParticipants => throw _privateConstructorUsedError;
  int? get maxSeats => throw _privateConstructorUsedError;
  double? get estimatedBudget => throw _privateConstructorUsedError;
  double? get actualBudget => throw _privateConstructorUsedError;
  String? get budgetAccountId => throw _privateConstructorUsedError;
  List<String> get participantsIds => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res, Event>;
  @useResult
  $Res call(
      {String id,
      String churchId,
      @EventTypeConverter() EventType type,
      String title,
      String? description,
      DateTime date,
      DateTime? endDate,
      String? location,
      String? managerId,
      String? officiantName,
      int? estimatedParticipants,
      int? actualParticipants,
      int? maxSeats,
      double? estimatedBudget,
      double? actualBudget,
      String? budgetAccountId,
      List<String> participantsIds,
      String status,
      String color,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class _$EventCopyWithImpl<$Res, $Val extends Event>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? type = null,
    Object? title = null,
    Object? description = freezed,
    Object? date = null,
    Object? endDate = freezed,
    Object? location = freezed,
    Object? managerId = freezed,
    Object? officiantName = freezed,
    Object? estimatedParticipants = freezed,
    Object? actualParticipants = freezed,
    Object? maxSeats = freezed,
    Object? estimatedBudget = freezed,
    Object? actualBudget = freezed,
    Object? budgetAccountId = freezed,
    Object? participantsIds = null,
    Object? status = null,
    Object? color = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as EventType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      managerId: freezed == managerId
          ? _value.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as String?,
      officiantName: freezed == officiantName
          ? _value.officiantName
          : officiantName // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedParticipants: freezed == estimatedParticipants
          ? _value.estimatedParticipants
          : estimatedParticipants // ignore: cast_nullable_to_non_nullable
              as int?,
      actualParticipants: freezed == actualParticipants
          ? _value.actualParticipants
          : actualParticipants // ignore: cast_nullable_to_non_nullable
              as int?,
      maxSeats: freezed == maxSeats
          ? _value.maxSeats
          : maxSeats // ignore: cast_nullable_to_non_nullable
              as int?,
      estimatedBudget: freezed == estimatedBudget
          ? _value.estimatedBudget
          : estimatedBudget // ignore: cast_nullable_to_non_nullable
              as double?,
      actualBudget: freezed == actualBudget
          ? _value.actualBudget
          : actualBudget // ignore: cast_nullable_to_non_nullable
              as double?,
      budgetAccountId: freezed == budgetAccountId
          ? _value.budgetAccountId
          : budgetAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      participantsIds: null == participantsIds
          ? _value.participantsIds
          : participantsIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventImplCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$EventImplCopyWith(
          _$EventImpl value, $Res Function(_$EventImpl) then) =
      __$$EventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String churchId,
      @EventTypeConverter() EventType type,
      String title,
      String? description,
      DateTime date,
      DateTime? endDate,
      String? location,
      String? managerId,
      String? officiantName,
      int? estimatedParticipants,
      int? actualParticipants,
      int? maxSeats,
      double? estimatedBudget,
      double? actualBudget,
      String? budgetAccountId,
      List<String> participantsIds,
      String status,
      String color,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class __$$EventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$EventImpl>
    implements _$$EventImplCopyWith<$Res> {
  __$$EventImplCopyWithImpl(
      _$EventImpl _value, $Res Function(_$EventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? type = null,
    Object? title = null,
    Object? description = freezed,
    Object? date = null,
    Object? endDate = freezed,
    Object? location = freezed,
    Object? managerId = freezed,
    Object? officiantName = freezed,
    Object? estimatedParticipants = freezed,
    Object? actualParticipants = freezed,
    Object? maxSeats = freezed,
    Object? estimatedBudget = freezed,
    Object? actualBudget = freezed,
    Object? budgetAccountId = freezed,
    Object? participantsIds = null,
    Object? status = null,
    Object? color = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_$EventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as EventType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      managerId: freezed == managerId
          ? _value.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as String?,
      officiantName: freezed == officiantName
          ? _value.officiantName
          : officiantName // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedParticipants: freezed == estimatedParticipants
          ? _value.estimatedParticipants
          : estimatedParticipants // ignore: cast_nullable_to_non_nullable
              as int?,
      actualParticipants: freezed == actualParticipants
          ? _value.actualParticipants
          : actualParticipants // ignore: cast_nullable_to_non_nullable
              as int?,
      maxSeats: freezed == maxSeats
          ? _value.maxSeats
          : maxSeats // ignore: cast_nullable_to_non_nullable
              as int?,
      estimatedBudget: freezed == estimatedBudget
          ? _value.estimatedBudget
          : estimatedBudget // ignore: cast_nullable_to_non_nullable
              as double?,
      actualBudget: freezed == actualBudget
          ? _value.actualBudget
          : actualBudget // ignore: cast_nullable_to_non_nullable
              as double?,
      budgetAccountId: freezed == budgetAccountId
          ? _value.budgetAccountId
          : budgetAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      participantsIds: null == participantsIds
          ? _value._participantsIds
          : participantsIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventImpl extends _Event {
  const _$EventImpl(
      {required this.id,
      required this.churchId,
      @EventTypeConverter() required this.type,
      required this.title,
      this.description,
      required this.date,
      this.endDate,
      this.location,
      this.managerId,
      this.officiantName,
      this.estimatedParticipants,
      this.actualParticipants,
      this.maxSeats,
      this.estimatedBudget,
      this.actualBudget,
      this.budgetAccountId,
      final List<String> participantsIds = const [],
      this.status = '',
      this.color = '',
      this.notes,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy})
      : _participantsIds = participantsIds,
        super._();

  factory _$EventImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImplFromJson(json);

  @override
  final String id;
  @override
  final String churchId;
  @override
  @EventTypeConverter()
  final EventType type;
  @override
  final String title;
  @override
  final String? description;
  @override
  final DateTime date;
  @override
  final DateTime? endDate;
  @override
  final String? location;
  @override
  final String? managerId;
  @override
  final String? officiantName;
  @override
  final int? estimatedParticipants;
  @override
  final int? actualParticipants;
  @override
  final int? maxSeats;
  @override
  final double? estimatedBudget;
  @override
  final double? actualBudget;
  @override
  final String? budgetAccountId;
  final List<String> _participantsIds;
  @override
  @JsonKey()
  List<String> get participantsIds {
    if (_participantsIds is EqualUnmodifiableListView) return _participantsIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantsIds);
  }

  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String color;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? createdBy;
  @override
  final String? updatedBy;

  @override
  String toString() {
    return 'Event(id: $id, churchId: $churchId, type: $type, title: $title, description: $description, date: $date, endDate: $endDate, location: $location, managerId: $managerId, officiantName: $officiantName, estimatedParticipants: $estimatedParticipants, actualParticipants: $actualParticipants, maxSeats: $maxSeats, estimatedBudget: $estimatedBudget, actualBudget: $actualBudget, budgetAccountId: $budgetAccountId, participantsIds: $participantsIds, status: $status, color: $color, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
            (identical(other.officiantName, officiantName) ||
                other.officiantName == officiantName) &&
            (identical(other.estimatedParticipants, estimatedParticipants) ||
                other.estimatedParticipants == estimatedParticipants) &&
            (identical(other.actualParticipants, actualParticipants) ||
                other.actualParticipants == actualParticipants) &&
            (identical(other.maxSeats, maxSeats) ||
                other.maxSeats == maxSeats) &&
            (identical(other.estimatedBudget, estimatedBudget) ||
                other.estimatedBudget == estimatedBudget) &&
            (identical(other.actualBudget, actualBudget) ||
                other.actualBudget == actualBudget) &&
            (identical(other.budgetAccountId, budgetAccountId) ||
                other.budgetAccountId == budgetAccountId) &&
            const DeepCollectionEquality()
                .equals(other._participantsIds, _participantsIds) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        churchId,
        type,
        title,
        description,
        date,
        endDate,
        location,
        managerId,
        officiantName,
        estimatedParticipants,
        actualParticipants,
        maxSeats,
        estimatedBudget,
        actualBudget,
        budgetAccountId,
        const DeepCollectionEquality().hash(_participantsIds),
        status,
        color,
        notes,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      __$$EventImplCopyWithImpl<_$EventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventImplToJson(
      this,
    );
  }
}

abstract class _Event extends Event {
  const factory _Event(
      {required final String id,
      required final String churchId,
      @EventTypeConverter() required final EventType type,
      required final String title,
      final String? description,
      required final DateTime date,
      final DateTime? endDate,
      final String? location,
      final String? managerId,
      final String? officiantName,
      final int? estimatedParticipants,
      final int? actualParticipants,
      final int? maxSeats,
      final double? estimatedBudget,
      final double? actualBudget,
      final String? budgetAccountId,
      final List<String> participantsIds,
      final String status,
      final String color,
      final String? notes,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? createdBy,
      final String? updatedBy}) = _$EventImpl;
  const _Event._() : super._();

  factory _Event.fromJson(Map<String, dynamic> json) = _$EventImpl.fromJson;

  @override
  String get id;
  @override
  String get churchId;
  @override
  @EventTypeConverter()
  EventType get type;
  @override
  String get title;
  @override
  String? get description;
  @override
  DateTime get date;
  @override
  DateTime? get endDate;
  @override
  String? get location;
  @override
  String? get managerId;
  @override
  String? get officiantName;
  @override
  int? get estimatedParticipants;
  @override
  int? get actualParticipants;
  @override
  int? get maxSeats;
  @override
  double? get estimatedBudget;
  @override
  double? get actualBudget;
  @override
  String? get budgetAccountId;
  @override
  List<String> get participantsIds;
  @override
  String get status;
  @override
  String get color;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get createdBy;
  @override
  String? get updatedBy;
  @override
  @JsonKey(ignore: true)
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
