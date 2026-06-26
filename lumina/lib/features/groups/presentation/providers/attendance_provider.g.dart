// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$groupAttendanceStreamHash() =>
    r'8739f7cc70e4860471493d73a24eb4f438494a58';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [groupAttendanceStream].
@ProviderFor(groupAttendanceStream)
const groupAttendanceStreamProvider = GroupAttendanceStreamFamily();

/// See also [groupAttendanceStream].
class GroupAttendanceStreamFamily
    extends Family<AsyncValue<List<GroupAttendance>>> {
  /// See also [groupAttendanceStream].
  const GroupAttendanceStreamFamily();

  /// See also [groupAttendanceStream].
  GroupAttendanceStreamProvider call(
    String churchId,
    String groupId,
    DateTime date,
  ) {
    return GroupAttendanceStreamProvider(
      churchId,
      groupId,
      date,
    );
  }

  @override
  GroupAttendanceStreamProvider getProviderOverride(
    covariant GroupAttendanceStreamProvider provider,
  ) {
    return call(
      provider.churchId,
      provider.groupId,
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'groupAttendanceStreamProvider';
}

/// See also [groupAttendanceStream].
class GroupAttendanceStreamProvider
    extends AutoDisposeStreamProvider<List<GroupAttendance>> {
  /// See also [groupAttendanceStream].
  GroupAttendanceStreamProvider(
    String churchId,
    String groupId,
    DateTime date,
  ) : this._internal(
          (ref) => groupAttendanceStream(
            ref as GroupAttendanceStreamRef,
            churchId,
            groupId,
            date,
          ),
          from: groupAttendanceStreamProvider,
          name: r'groupAttendanceStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupAttendanceStreamHash,
          dependencies: GroupAttendanceStreamFamily._dependencies,
          allTransitiveDependencies:
              GroupAttendanceStreamFamily._allTransitiveDependencies,
          churchId: churchId,
          groupId: groupId,
          date: date,
        );

  GroupAttendanceStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.churchId,
    required this.groupId,
    required this.date,
  }) : super.internal();

  final String churchId;
  final String groupId;
  final DateTime date;

  @override
  Override overrideWith(
    Stream<List<GroupAttendance>> Function(GroupAttendanceStreamRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupAttendanceStreamProvider._internal(
        (ref) => create(ref as GroupAttendanceStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        churchId: churchId,
        groupId: groupId,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<GroupAttendance>> createElement() {
    return _GroupAttendanceStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupAttendanceStreamProvider &&
        other.churchId == churchId &&
        other.groupId == groupId &&
        other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, churchId.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GroupAttendanceStreamRef
    on AutoDisposeStreamProviderRef<List<GroupAttendance>> {
  /// The parameter `churchId` of this provider.
  String get churchId;

  /// The parameter `groupId` of this provider.
  String get groupId;

  /// The parameter `date` of this provider.
  DateTime get date;
}

class _GroupAttendanceStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<GroupAttendance>>
    with GroupAttendanceStreamRef {
  _GroupAttendanceStreamProviderElement(super.provider);

  @override
  String get churchId => (origin as GroupAttendanceStreamProvider).churchId;
  @override
  String get groupId => (origin as GroupAttendanceStreamProvider).groupId;
  @override
  DateTime get date => (origin as GroupAttendanceStreamProvider).date;
}

String _$attendanceControllerHash() =>
    r'149d284e8b678180ad968bed2902e3030fb9a15f';

abstract class _$AttendanceController
    extends BuildlessAutoDisposeAsyncNotifier<List<GroupAttendance>> {
  late final String churchId;
  late final String groupId;
  late final DateTime date;

  FutureOr<List<GroupAttendance>> build(
    String churchId,
    String groupId,
    DateTime date,
  );
}

/// See also [AttendanceController].
@ProviderFor(AttendanceController)
const attendanceControllerProvider = AttendanceControllerFamily();

/// See also [AttendanceController].
class AttendanceControllerFamily
    extends Family<AsyncValue<List<GroupAttendance>>> {
  /// See also [AttendanceController].
  const AttendanceControllerFamily();

  /// See also [AttendanceController].
  AttendanceControllerProvider call(
    String churchId,
    String groupId,
    DateTime date,
  ) {
    return AttendanceControllerProvider(
      churchId,
      groupId,
      date,
    );
  }

  @override
  AttendanceControllerProvider getProviderOverride(
    covariant AttendanceControllerProvider provider,
  ) {
    return call(
      provider.churchId,
      provider.groupId,
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'attendanceControllerProvider';
}

/// See also [AttendanceController].
class AttendanceControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    AttendanceController, List<GroupAttendance>> {
  /// See also [AttendanceController].
  AttendanceControllerProvider(
    String churchId,
    String groupId,
    DateTime date,
  ) : this._internal(
          () => AttendanceController()
            ..churchId = churchId
            ..groupId = groupId
            ..date = date,
          from: attendanceControllerProvider,
          name: r'attendanceControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$attendanceControllerHash,
          dependencies: AttendanceControllerFamily._dependencies,
          allTransitiveDependencies:
              AttendanceControllerFamily._allTransitiveDependencies,
          churchId: churchId,
          groupId: groupId,
          date: date,
        );

  AttendanceControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.churchId,
    required this.groupId,
    required this.date,
  }) : super.internal();

  final String churchId;
  final String groupId;
  final DateTime date;

  @override
  FutureOr<List<GroupAttendance>> runNotifierBuild(
    covariant AttendanceController notifier,
  ) {
    return notifier.build(
      churchId,
      groupId,
      date,
    );
  }

  @override
  Override overrideWith(AttendanceController Function() create) {
    return ProviderOverride(
      origin: this,
      override: AttendanceControllerProvider._internal(
        () => create()
          ..churchId = churchId
          ..groupId = groupId
          ..date = date,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        churchId: churchId,
        groupId: groupId,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AttendanceController,
      List<GroupAttendance>> createElement() {
    return _AttendanceControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AttendanceControllerProvider &&
        other.churchId == churchId &&
        other.groupId == groupId &&
        other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, churchId.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AttendanceControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<GroupAttendance>> {
  /// The parameter `churchId` of this provider.
  String get churchId;

  /// The parameter `groupId` of this provider.
  String get groupId;

  /// The parameter `date` of this provider.
  DateTime get date;
}

class _AttendanceControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<AttendanceController,
        List<GroupAttendance>> with AttendanceControllerRef {
  _AttendanceControllerProviderElement(super.provider);

  @override
  String get churchId => (origin as AttendanceControllerProvider).churchId;
  @override
  String get groupId => (origin as AttendanceControllerProvider).groupId;
  @override
  DateTime get date => (origin as AttendanceControllerProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
