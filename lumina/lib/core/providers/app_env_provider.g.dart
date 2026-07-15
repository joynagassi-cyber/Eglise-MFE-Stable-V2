// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_env_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appEnvHash() => r'92dd92ed1c79e10a12890f66471e14caf69c324b';

/// See also [appEnv].
@ProviderFor(appEnv)
final appEnvProvider = AutoDisposeProvider<AppEnv>.internal(
  appEnv,
  name: r'appEnvProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appEnvHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppEnvRef = AutoDisposeProviderRef<AppEnv>;
String _$googleWebClientIdHash() => r'277292a0f4b02894d8ecf158de0d1bf36b55f07d';

/// See also [googleWebClientId].
@ProviderFor(googleWebClientId)
final googleWebClientIdProvider = AutoDisposeProvider<String?>.internal(
  googleWebClientId,
  name: r'googleWebClientIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$googleWebClientIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GoogleWebClientIdRef = AutoDisposeProviderRef<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
