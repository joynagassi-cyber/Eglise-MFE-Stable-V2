// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_management_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serviceAttendanceStreamHash() =>
    r'3c27bb2052b0ef42c931ef3de61369d09791844b';

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

/// See also [serviceAttendanceStream].
@ProviderFor(serviceAttendanceStream)
const serviceAttendanceStreamProvider = ServiceAttendanceStreamFamily();

/// See also [serviceAttendanceStream].
class ServiceAttendanceStreamFamily
    extends Family<AsyncValue<List<ServiceAttendance>>> {
  /// See also [serviceAttendanceStream].
  const ServiceAttendanceStreamFamily();

  /// See also [serviceAttendanceStream].
  ServiceAttendanceStreamProvider call(
    String serviceId,
  ) {
    return ServiceAttendanceStreamProvider(
      serviceId,
    );
  }

  @override
  ServiceAttendanceStreamProvider getProviderOverride(
    covariant ServiceAttendanceStreamProvider provider,
  ) {
    return call(
      provider.serviceId,
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
  String? get name => r'serviceAttendanceStreamProvider';
}

/// See also [serviceAttendanceStream].
class ServiceAttendanceStreamProvider
    extends AutoDisposeStreamProvider<List<ServiceAttendance>> {
  /// See also [serviceAttendanceStream].
  ServiceAttendanceStreamProvider(
    String serviceId,
  ) : this._internal(
          (ref) => serviceAttendanceStream(
            ref as ServiceAttendanceStreamRef,
            serviceId,
          ),
          from: serviceAttendanceStreamProvider,
          name: r'serviceAttendanceStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceAttendanceStreamHash,
          dependencies: ServiceAttendanceStreamFamily._dependencies,
          allTransitiveDependencies:
              ServiceAttendanceStreamFamily._allTransitiveDependencies,
          serviceId: serviceId,
        );

  ServiceAttendanceStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serviceId,
  }) : super.internal();

  final String serviceId;

  @override
  Override overrideWith(
    Stream<List<ServiceAttendance>> Function(
            ServiceAttendanceStreamRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServiceAttendanceStreamProvider._internal(
        (ref) => create(ref as ServiceAttendanceStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serviceId: serviceId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ServiceAttendance>> createElement() {
    return _ServiceAttendanceStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceAttendanceStreamProvider &&
        other.serviceId == serviceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ServiceAttendanceStreamRef
    on AutoDisposeStreamProviderRef<List<ServiceAttendance>> {
  /// The parameter `serviceId` of this provider.
  String get serviceId;
}

class _ServiceAttendanceStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<ServiceAttendance>>
    with ServiceAttendanceStreamRef {
  _ServiceAttendanceStreamProviderElement(super.provider);

  @override
  String get serviceId => (origin as ServiceAttendanceStreamProvider).serviceId;
}

String _$attendanceManagementControllerHash() =>
    r'dee0650ef3107720353114cf3840be9a0cf8dff6';

abstract class _$AttendanceManagementController
    extends BuildlessAutoDisposeAsyncNotifier<List<ServiceAttendance>> {
  late final String serviceId;

  FutureOr<List<ServiceAttendance>> build(
    String serviceId,
  );
}

/// See also [AttendanceManagementController].
@ProviderFor(AttendanceManagementController)
const attendanceManagementControllerProvider =
    AttendanceManagementControllerFamily();

/// See also [AttendanceManagementController].
class AttendanceManagementControllerFamily
    extends Family<AsyncValue<List<ServiceAttendance>>> {
  /// See also [AttendanceManagementController].
  const AttendanceManagementControllerFamily();

  /// See also [AttendanceManagementController].
  AttendanceManagementControllerProvider call(
    String serviceId,
  ) {
    return AttendanceManagementControllerProvider(
      serviceId,
    );
  }

  @override
  AttendanceManagementControllerProvider getProviderOverride(
    covariant AttendanceManagementControllerProvider provider,
  ) {
    return call(
      provider.serviceId,
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
  String? get name => r'attendanceManagementControllerProvider';
}

/// See also [AttendanceManagementController].
class AttendanceManagementControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<AttendanceManagementController,
        List<ServiceAttendance>> {
  /// See also [AttendanceManagementController].
  AttendanceManagementControllerProvider(
    String serviceId,
  ) : this._internal(
          () => AttendanceManagementController()..serviceId = serviceId,
          from: attendanceManagementControllerProvider,
          name: r'attendanceManagementControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$attendanceManagementControllerHash,
          dependencies: AttendanceManagementControllerFamily._dependencies,
          allTransitiveDependencies:
              AttendanceManagementControllerFamily._allTransitiveDependencies,
          serviceId: serviceId,
        );

  AttendanceManagementControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serviceId,
  }) : super.internal();

  final String serviceId;

  @override
  FutureOr<List<ServiceAttendance>> runNotifierBuild(
    covariant AttendanceManagementController notifier,
  ) {
    return notifier.build(
      serviceId,
    );
  }

  @override
  Override overrideWith(AttendanceManagementController Function() create) {
    return ProviderOverride(
      origin: this,
      override: AttendanceManagementControllerProvider._internal(
        () => create()..serviceId = serviceId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serviceId: serviceId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AttendanceManagementController,
      List<ServiceAttendance>> createElement() {
    return _AttendanceManagementControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AttendanceManagementControllerProvider &&
        other.serviceId == serviceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AttendanceManagementControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<ServiceAttendance>> {
  /// The parameter `serviceId` of this provider.
  String get serviceId;
}

class _AttendanceManagementControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        AttendanceManagementController,
        List<ServiceAttendance>> with AttendanceManagementControllerRef {
  _AttendanceManagementControllerProviderElement(super.provider);

  @override
  String get serviceId =>
      (origin as AttendanceManagementControllerProvider).serviceId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
