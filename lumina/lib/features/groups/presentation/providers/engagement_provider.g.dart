// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'engagement_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$topEngagedMembersHash() => r'84c4270860edbac1f95e2e9ffc7f25466bc7126c';

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

/// See also [topEngagedMembers].
@ProviderFor(topEngagedMembers)
const topEngagedMembersProvider = TopEngagedMembersFamily();

/// See also [topEngagedMembers].
class TopEngagedMembersFamily
    extends Family<AsyncValue<List<MemberEngagement>>> {
  /// See also [topEngagedMembers].
  const TopEngagedMembersFamily();

  /// See also [topEngagedMembers].
  TopEngagedMembersProvider call(
    String groupId,
  ) {
    return TopEngagedMembersProvider(
      groupId,
    );
  }

  @override
  TopEngagedMembersProvider getProviderOverride(
    covariant TopEngagedMembersProvider provider,
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
  String? get name => r'topEngagedMembersProvider';
}

/// See also [topEngagedMembers].
class TopEngagedMembersProvider
    extends AutoDisposeFutureProvider<List<MemberEngagement>> {
  /// See also [topEngagedMembers].
  TopEngagedMembersProvider(
    String groupId,
  ) : this._internal(
          (ref) => topEngagedMembers(
            ref as TopEngagedMembersRef,
            groupId,
          ),
          from: topEngagedMembersProvider,
          name: r'topEngagedMembersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$topEngagedMembersHash,
          dependencies: TopEngagedMembersFamily._dependencies,
          allTransitiveDependencies:
              TopEngagedMembersFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  TopEngagedMembersProvider._internal(
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
  Override overrideWith(
    FutureOr<List<MemberEngagement>> Function(TopEngagedMembersRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TopEngagedMembersProvider._internal(
        (ref) => create(ref as TopEngagedMembersRef),
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
  AutoDisposeFutureProviderElement<List<MemberEngagement>> createElement() {
    return _TopEngagedMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TopEngagedMembersProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TopEngagedMembersRef
    on AutoDisposeFutureProviderRef<List<MemberEngagement>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _TopEngagedMembersProviderElement
    extends AutoDisposeFutureProviderElement<List<MemberEngagement>>
    with TopEngagedMembersRef {
  _TopEngagedMembersProviderElement(super.provider);

  @override
  String get groupId => (origin as TopEngagedMembersProvider).groupId;
}

String _$membersAtRiskHash() => r'3cd210d0067e1357915b6bf3534063cae6623802';

/// See also [membersAtRisk].
@ProviderFor(membersAtRisk)
const membersAtRiskProvider = MembersAtRiskFamily();

/// See also [membersAtRisk].
class MembersAtRiskFamily extends Family<AsyncValue<List<MemberEngagement>>> {
  /// See also [membersAtRisk].
  const MembersAtRiskFamily();

  /// See also [membersAtRisk].
  MembersAtRiskProvider call(
    String groupId,
  ) {
    return MembersAtRiskProvider(
      groupId,
    );
  }

  @override
  MembersAtRiskProvider getProviderOverride(
    covariant MembersAtRiskProvider provider,
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
  String? get name => r'membersAtRiskProvider';
}

/// See also [membersAtRisk].
class MembersAtRiskProvider
    extends AutoDisposeFutureProvider<List<MemberEngagement>> {
  /// See also [membersAtRisk].
  MembersAtRiskProvider(
    String groupId,
  ) : this._internal(
          (ref) => membersAtRisk(
            ref as MembersAtRiskRef,
            groupId,
          ),
          from: membersAtRiskProvider,
          name: r'membersAtRiskProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$membersAtRiskHash,
          dependencies: MembersAtRiskFamily._dependencies,
          allTransitiveDependencies:
              MembersAtRiskFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  MembersAtRiskProvider._internal(
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
  Override overrideWith(
    FutureOr<List<MemberEngagement>> Function(MembersAtRiskRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MembersAtRiskProvider._internal(
        (ref) => create(ref as MembersAtRiskRef),
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
  AutoDisposeFutureProviderElement<List<MemberEngagement>> createElement() {
    return _MembersAtRiskProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MembersAtRiskProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MembersAtRiskRef on AutoDisposeFutureProviderRef<List<MemberEngagement>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _MembersAtRiskProviderElement
    extends AutoDisposeFutureProviderElement<List<MemberEngagement>>
    with MembersAtRiskRef {
  _MembersAtRiskProviderElement(super.provider);

  @override
  String get groupId => (origin as MembersAtRiskProvider).groupId;
}

String _$groupEngagementHash() => r'ec25bc87409b8ab2dbf3b7d08ff31075d6d781f5';

abstract class _$GroupEngagement
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, MemberEngagement>> {
  late final String groupId;

  FutureOr<Map<String, MemberEngagement>> build(
    String groupId,
  );
}

/// See also [GroupEngagement].
@ProviderFor(GroupEngagement)
const groupEngagementProvider = GroupEngagementFamily();

/// See also [GroupEngagement].
class GroupEngagementFamily
    extends Family<AsyncValue<Map<String, MemberEngagement>>> {
  /// See also [GroupEngagement].
  const GroupEngagementFamily();

  /// See also [GroupEngagement].
  GroupEngagementProvider call(
    String groupId,
  ) {
    return GroupEngagementProvider(
      groupId,
    );
  }

  @override
  GroupEngagementProvider getProviderOverride(
    covariant GroupEngagementProvider provider,
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
  String? get name => r'groupEngagementProvider';
}

/// See also [GroupEngagement].
class GroupEngagementProvider extends AutoDisposeAsyncNotifierProviderImpl<
    GroupEngagement, Map<String, MemberEngagement>> {
  /// See also [GroupEngagement].
  GroupEngagementProvider(
    String groupId,
  ) : this._internal(
          () => GroupEngagement()..groupId = groupId,
          from: groupEngagementProvider,
          name: r'groupEngagementProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupEngagementHash,
          dependencies: GroupEngagementFamily._dependencies,
          allTransitiveDependencies:
              GroupEngagementFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  GroupEngagementProvider._internal(
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
  FutureOr<Map<String, MemberEngagement>> runNotifierBuild(
    covariant GroupEngagement notifier,
  ) {
    return notifier.build(
      groupId,
    );
  }

  @override
  Override overrideWith(GroupEngagement Function() create) {
    return ProviderOverride(
      origin: this,
      override: GroupEngagementProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<GroupEngagement,
      Map<String, MemberEngagement>> createElement() {
    return _GroupEngagementProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupEngagementProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GroupEngagementRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, MemberEngagement>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GroupEngagementProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<GroupEngagement,
        Map<String, MemberEngagement>> with GroupEngagementRef {
  _GroupEngagementProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupEngagementProvider).groupId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
