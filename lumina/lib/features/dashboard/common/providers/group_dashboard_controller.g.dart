// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$groupDashboardControllerHash() =>
    r'77eb9bc9d44fcaa09627382f422b13ec37e408b4';

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

abstract class _$GroupDashboardController
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, dynamic>> {
  late final String groupId;

  FutureOr<Map<String, dynamic>> build(
    String groupId,
  );
}

/// See also [GroupDashboardController].
@ProviderFor(GroupDashboardController)
const groupDashboardControllerProvider = GroupDashboardControllerFamily();

/// See also [GroupDashboardController].
class GroupDashboardControllerFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [GroupDashboardController].
  const GroupDashboardControllerFamily();

  /// See also [GroupDashboardController].
  GroupDashboardControllerProvider call(
    String groupId,
  ) {
    return GroupDashboardControllerProvider(
      groupId,
    );
  }

  @override
  GroupDashboardControllerProvider getProviderOverride(
    covariant GroupDashboardControllerProvider provider,
  ) {
    return call(
      provider.groupId,
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
  String? get name => r'groupDashboardControllerProvider';
}

/// See also [GroupDashboardController].
class GroupDashboardControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<GroupDashboardController,
        Map<String, dynamic>> {
  /// See also [GroupDashboardController].
  GroupDashboardControllerProvider(
    String groupId,
  ) : this._internal(
          () => GroupDashboardController()..groupId = groupId,
          from: groupDashboardControllerProvider,
          name: r'groupDashboardControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupDashboardControllerHash,
          dependencies: GroupDashboardControllerFamily._dependencies,
          allTransitiveDependencies:
              GroupDashboardControllerFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  GroupDashboardControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  FutureOr<Map<String, dynamic>> runNotifierBuild(
    covariant GroupDashboardController notifier,
  ) {
    return notifier.build(
      groupId,
    );
  }

  @override
  Override overrideWith(GroupDashboardController Function() create) {
    return ProviderOverride(
      origin: this,
      override: GroupDashboardControllerProvider._internal(
        () => create()..groupId = groupId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GroupDashboardController,
      Map<String, dynamic>> createElement() {
    return _GroupDashboardControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupDashboardControllerProvider &&
        other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GroupDashboardControllerRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, dynamic>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GroupDashboardControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<GroupDashboardController,
        Map<String, dynamic>> with GroupDashboardControllerRef {
  _GroupDashboardControllerProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupDashboardControllerProvider).groupId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
