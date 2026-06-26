// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$groupsHash() => r'85743c22057c26e5b073424784680eeefb9fe012';

/// See also [groups].
@ProviderFor(groups)
final groupsProvider = AutoDisposeStreamProvider<List<Group>>.internal(
  groups,
  name: r'groupsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$groupsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GroupsRef = AutoDisposeStreamProviderRef<List<Group>>;
String _$groupDetailHash() => r'f48498ffccca5b92de2739f0f1965a8821a5a8f8';

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

/// See also [groupDetail].
@ProviderFor(groupDetail)
const groupDetailProvider = GroupDetailFamily();

/// See also [groupDetail].
class GroupDetailFamily extends Family<AsyncValue<Group?>> {
  /// See also [groupDetail].
  const GroupDetailFamily();

  /// See also [groupDetail].
  GroupDetailProvider call(
    String id,
  ) {
    return GroupDetailProvider(
      id,
    );
  }

  @override
  GroupDetailProvider getProviderOverride(
    covariant GroupDetailProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'groupDetailProvider';
}

/// See also [groupDetail].
class GroupDetailProvider extends AutoDisposeFutureProvider<Group?> {
  /// See also [groupDetail].
  GroupDetailProvider(
    String id,
  ) : this._internal(
          (ref) => groupDetail(
            ref as GroupDetailRef,
            id,
          ),
          from: groupDetailProvider,
          name: r'groupDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupDetailHash,
          dependencies: GroupDetailFamily._dependencies,
          allTransitiveDependencies:
              GroupDetailFamily._allTransitiveDependencies,
          id: id,
        );

  GroupDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Group?> Function(GroupDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupDetailProvider._internal(
        (ref) => create(ref as GroupDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Group?> createElement() {
    return _GroupDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GroupDetailRef on AutoDisposeFutureProviderRef<Group?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _GroupDetailProviderElement
    extends AutoDisposeFutureProviderElement<Group?> with GroupDetailRef {
  _GroupDetailProviderElement(super.provider);

  @override
  String get id => (origin as GroupDetailProvider).id;
}

String _$groupMembersHash() => r'8efddf67c0662feadec39207f69656ec3415d8ae';

/// See also [groupMembers].
@ProviderFor(groupMembers)
const groupMembersProvider = GroupMembersFamily();

/// See also [groupMembers].
class GroupMembersFamily extends Family<AsyncValue<List<GroupMembership>>> {
  /// See also [groupMembers].
  const GroupMembersFamily();

  /// See also [groupMembers].
  GroupMembersProvider call(
    String groupId,
  ) {
    return GroupMembersProvider(
      groupId,
    );
  }

  @override
  GroupMembersProvider getProviderOverride(
    covariant GroupMembersProvider provider,
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
  String? get name => r'groupMembersProvider';
}

/// See also [groupMembers].
class GroupMembersProvider
    extends AutoDisposeFutureProvider<List<GroupMembership>> {
  /// See also [groupMembers].
  GroupMembersProvider(
    String groupId,
  ) : this._internal(
          (ref) => groupMembers(
            ref as GroupMembersRef,
            groupId,
          ),
          from: groupMembersProvider,
          name: r'groupMembersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupMembersHash,
          dependencies: GroupMembersFamily._dependencies,
          allTransitiveDependencies:
              GroupMembersFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  GroupMembersProvider._internal(
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
    FutureOr<List<GroupMembership>> Function(GroupMembersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupMembersProvider._internal(
        (ref) => create(ref as GroupMembersRef),
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
  AutoDisposeFutureProviderElement<List<GroupMembership>> createElement() {
    return _GroupMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupMembersProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GroupMembersRef on AutoDisposeFutureProviderRef<List<GroupMembership>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GroupMembersProviderElement
    extends AutoDisposeFutureProviderElement<List<GroupMembership>>
    with GroupMembersRef {
  _GroupMembersProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupMembersProvider).groupId;
}

String _$memberGroupsHash() => r'053fd4585bcd79c1008fba81f03141101bbab022';

/// See also [memberGroups].
@ProviderFor(memberGroups)
const memberGroupsProvider = MemberGroupsFamily();

/// See also [memberGroups].
class MemberGroupsFamily extends Family<AsyncValue<List<GroupMembership>>> {
  /// See also [memberGroups].
  const MemberGroupsFamily();

  /// See also [memberGroups].
  MemberGroupsProvider call(
    String memberId,
  ) {
    return MemberGroupsProvider(
      memberId,
    );
  }

  @override
  MemberGroupsProvider getProviderOverride(
    covariant MemberGroupsProvider provider,
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
  String? get name => r'memberGroupsProvider';
}

/// See also [memberGroups].
class MemberGroupsProvider
    extends AutoDisposeFutureProvider<List<GroupMembership>> {
  /// See also [memberGroups].
  MemberGroupsProvider(
    String memberId,
  ) : this._internal(
          (ref) => memberGroups(
            ref as MemberGroupsRef,
            memberId,
          ),
          from: memberGroupsProvider,
          name: r'memberGroupsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$memberGroupsHash,
          dependencies: MemberGroupsFamily._dependencies,
          allTransitiveDependencies:
              MemberGroupsFamily._allTransitiveDependencies,
          memberId: memberId,
        );

  MemberGroupsProvider._internal(
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
    FutureOr<List<GroupMembership>> Function(MemberGroupsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MemberGroupsProvider._internal(
        (ref) => create(ref as MemberGroupsRef),
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
  AutoDisposeFutureProviderElement<List<GroupMembership>> createElement() {
    return _MemberGroupsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberGroupsProvider && other.memberId == memberId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, memberId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MemberGroupsRef on AutoDisposeFutureProviderRef<List<GroupMembership>> {
  /// The parameter `memberId` of this provider.
  String get memberId;
}

class _MemberGroupsProviderElement
    extends AutoDisposeFutureProviderElement<List<GroupMembership>>
    with MemberGroupsRef {
  _MemberGroupsProviderElement(super.provider);

  @override
  String get memberId => (origin as MemberGroupsProvider).memberId;
}

String _$pendingMembershipsHash() =>
    r'c6d617122ff91a0b809b5491a86b01fb20f33cdd';

/// See also [pendingMemberships].
@ProviderFor(pendingMemberships)
const pendingMembershipsProvider = PendingMembershipsFamily();

/// See also [pendingMemberships].
class PendingMembershipsFamily
    extends Family<AsyncValue<List<GroupMembership>>> {
  /// See also [pendingMemberships].
  const PendingMembershipsFamily();

  /// See also [pendingMemberships].
  PendingMembershipsProvider call(
    String groupId,
  ) {
    return PendingMembershipsProvider(
      groupId,
    );
  }

  @override
  PendingMembershipsProvider getProviderOverride(
    covariant PendingMembershipsProvider provider,
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
  String? get name => r'pendingMembershipsProvider';
}

/// See also [pendingMemberships].
class PendingMembershipsProvider
    extends AutoDisposeFutureProvider<List<GroupMembership>> {
  /// See also [pendingMemberships].
  PendingMembershipsProvider(
    String groupId,
  ) : this._internal(
          (ref) => pendingMemberships(
            ref as PendingMembershipsRef,
            groupId,
          ),
          from: pendingMembershipsProvider,
          name: r'pendingMembershipsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pendingMembershipsHash,
          dependencies: PendingMembershipsFamily._dependencies,
          allTransitiveDependencies:
              PendingMembershipsFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  PendingMembershipsProvider._internal(
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
    FutureOr<List<GroupMembership>> Function(PendingMembershipsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PendingMembershipsProvider._internal(
        (ref) => create(ref as PendingMembershipsRef),
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
  AutoDisposeFutureProviderElement<List<GroupMembership>> createElement() {
    return _PendingMembershipsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PendingMembershipsProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PendingMembershipsRef
    on AutoDisposeFutureProviderRef<List<GroupMembership>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _PendingMembershipsProviderElement
    extends AutoDisposeFutureProviderElement<List<GroupMembership>>
    with PendingMembershipsRef {
  _PendingMembershipsProviderElement(super.provider);

  @override
  String get groupId => (origin as PendingMembershipsProvider).groupId;
}

String _$myMemberGroupsHash() => r'e9690959a7cefffb63b07e7d69fb93c41d2346b9';

/// See also [myMemberGroups].
@ProviderFor(myMemberGroups)
final myMemberGroupsProvider =
    AutoDisposeFutureProvider<List<GroupMembership>>.internal(
  myMemberGroups,
  name: r'myMemberGroupsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myMemberGroupsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MyMemberGroupsRef = AutoDisposeFutureProviderRef<List<GroupMembership>>;
String _$myPendingGroupRequestsHash() =>
    r'012d47ea138d18a691e3f091c93fd416461d97df';

/// See also [myPendingGroupRequests].
@ProviderFor(myPendingGroupRequests)
final myPendingGroupRequestsProvider =
    AutoDisposeFutureProvider<List<GroupMembership>>.internal(
  myPendingGroupRequests,
  name: r'myPendingGroupRequestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myPendingGroupRequestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MyPendingGroupRequestsRef
    = AutoDisposeFutureProviderRef<List<GroupMembership>>;
String _$availableGroupsForAdminHash() =>
    r'c2e62dc36277f63ace11641f78d83a62f83b83bd';

/// See also [availableGroupsForAdmin].
@ProviderFor(availableGroupsForAdmin)
final availableGroupsForAdminProvider =
    AutoDisposeFutureProvider<List<Group>>.internal(
  availableGroupsForAdmin,
  name: r'availableGroupsForAdminProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableGroupsForAdminHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AvailableGroupsForAdminRef = AutoDisposeFutureProviderRef<List<Group>>;
String _$groupControllerHash() => r'6d56c1da02c61ac0d0f82b9178a5367001599946';

/// See also [GroupController].
@ProviderFor(GroupController)
final groupControllerProvider =
    AutoDisposeAsyncNotifierProvider<GroupController, void>.internal(
  GroupController.new,
  name: r'groupControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$groupControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GroupController = AutoDisposeAsyncNotifier<void>;
String _$adminGroupSubscriptionHash() =>
    r'c6b578d43398c85e402dac96e7cbc05a4d0b12b3';

/// See also [AdminGroupSubscription].
@ProviderFor(AdminGroupSubscription)
final adminGroupSubscriptionProvider = AutoDisposeAsyncNotifierProvider<
    AdminGroupSubscription, List<String>>.internal(
  AdminGroupSubscription.new,
  name: r'adminGroupSubscriptionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminGroupSubscriptionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AdminGroupSubscription = AutoDisposeAsyncNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
