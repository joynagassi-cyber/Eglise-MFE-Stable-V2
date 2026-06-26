// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_roles_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$availableRolesHash() => r'4478a1016a6b7b7bbd1d768291df537675e74ed1';

/// See also [availableRoles].
@ProviderFor(availableRoles)
final availableRolesProvider =
    AutoDisposeFutureProvider<List<UserRole>>.internal(
  availableRoles,
  name: r'availableRolesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableRolesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AvailableRolesRef = AutoDisposeFutureProviderRef<List<UserRole>>;
String _$roleControllerHash() => r'064aa469fb1e935f34ed5cb498f4b65d1884bdc4';

/// See also [RoleController].
@ProviderFor(RoleController)
final roleControllerProvider =
    AutoDisposeNotifierProvider<RoleController, AsyncValue<void>>.internal(
  RoleController.new,
  name: r'roleControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$roleControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RoleController = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
