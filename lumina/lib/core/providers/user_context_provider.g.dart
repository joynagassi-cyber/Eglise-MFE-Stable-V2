// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_context_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authStateHash() => r'fe965816dae452e3ad22e2508579b748e697d5a9';

/// See also [authState].
@ProviderFor(authState)
final authStateProvider = AutoDisposeStreamProvider<AuthState>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthStateRef = AutoDisposeStreamProviderRef<AuthState>;
String _$userContextNotifierHash() =>
    r'023187303d8fa3159c52f70d374de28166f30fff';

/// See also [UserContextNotifier].
@ProviderFor(UserContextNotifier)
final userContextNotifierProvider = AutoDisposeAsyncNotifierProvider<
    UserContextNotifier, UserContext?>.internal(
  UserContextNotifier.new,
  name: r'userContextNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userContextNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserContextNotifier = AutoDisposeAsyncNotifier<UserContext?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
