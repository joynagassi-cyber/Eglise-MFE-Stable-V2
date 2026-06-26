// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_attendance_360_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$memberAttendance360Hash() =>
    r'0eb4cfe89b7bb73a95321670246192892d55dc9e';

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

/// See also [memberAttendance360].
@ProviderFor(memberAttendance360)
const memberAttendance360Provider = MemberAttendance360Family();

/// See also [memberAttendance360].
class MemberAttendance360Family
    extends Family<AsyncValue<MemberAttendanceStats>> {
  /// See also [memberAttendance360].
  const MemberAttendance360Family();

  /// See also [memberAttendance360].
  MemberAttendance360Provider call(
    String memberId,
  ) {
    return MemberAttendance360Provider(
      memberId,
    );
  }

  @override
  MemberAttendance360Provider getProviderOverride(
    covariant MemberAttendance360Provider provider,
  ) {
    return call(
      provider.memberId,
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
  String? get name => r'memberAttendance360Provider';
}

/// See also [memberAttendance360].
class MemberAttendance360Provider
    extends AutoDisposeFutureProvider<MemberAttendanceStats> {
  /// See also [memberAttendance360].
  MemberAttendance360Provider(
    String memberId,
  ) : this._internal(
          (ref) => memberAttendance360(
            ref as MemberAttendance360Ref,
            memberId,
          ),
          from: memberAttendance360Provider,
          name: r'memberAttendance360Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$memberAttendance360Hash,
          dependencies: MemberAttendance360Family._dependencies,
          allTransitiveDependencies:
              MemberAttendance360Family._allTransitiveDependencies,
          memberId: memberId,
        );

  MemberAttendance360Provider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.memberId,
  }) : super.internal();

  final String memberId;

  @override
  Override overrideWith(
    FutureOr<MemberAttendanceStats> Function(MemberAttendance360Ref provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MemberAttendance360Provider._internal(
        (ref) => create(ref as MemberAttendance360Ref),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        memberId: memberId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MemberAttendanceStats> createElement() {
    return _MemberAttendance360ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberAttendance360Provider && other.memberId == memberId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, memberId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MemberAttendance360Ref
    on AutoDisposeFutureProviderRef<MemberAttendanceStats> {
  /// The parameter `memberId` of this provider.
  String get memberId;
}

class _MemberAttendance360ProviderElement
    extends AutoDisposeFutureProviderElement<MemberAttendanceStats>
    with MemberAttendance360Ref {
  _MemberAttendance360ProviderElement(super.provider);

  @override
  String get memberId => (origin as MemberAttendance360Provider).memberId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
