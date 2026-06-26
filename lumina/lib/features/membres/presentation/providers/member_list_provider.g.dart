// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$memberListHash() => r'259c395402bb90e305daa9d438959541546858c8';

/// See also [memberList].
@ProviderFor(memberList)
final memberListProvider = AutoDisposeStreamProvider<List<Member>>.internal(
  memberList,
  name: r'memberListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$memberListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MemberListRef = AutoDisposeStreamProviderRef<List<Member>>;
String _$filteredMembersHash() => r'd0ce39dec4893dd945e1271dbe0d11b164718878';

/// See also [filteredMembers].
@ProviderFor(filteredMembers)
final filteredMembersProvider = AutoDisposeProvider<List<Member>>.internal(
  filteredMembers,
  name: r'filteredMembersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredMembersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredMembersRef = AutoDisposeProviderRef<List<Member>>;
String _$paginatedMembersHash() => r'9b8c530d0d543b97c104d3a5cfa61c695e947d05';

/// Notifier pour l'Infinite Scroll (Supporte des milliers de membres)
///
/// Copied from [PaginatedMembers].
@ProviderFor(PaginatedMembers)
final paginatedMembersProvider = AutoDisposeNotifierProvider<PaginatedMembers,
    MemberPaginationState>.internal(
  PaginatedMembers.new,
  name: r'paginatedMembersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paginatedMembersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaginatedMembers = AutoDisposeNotifier<MemberPaginationState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
