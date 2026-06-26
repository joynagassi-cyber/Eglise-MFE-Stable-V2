// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_export_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeChurchNameHash() => r'144ff0d144bca735319d6583bf8264a6a848643f';

/// Provider pour obtenir le nom de l'église active (pour les noms de fichiers)
///
/// Copied from [activeChurchName].
@ProviderFor(activeChurchName)
final activeChurchNameProvider = AutoDisposeFutureProvider<String?>.internal(
  activeChurchName,
  name: r'activeChurchNameProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeChurchNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ActiveChurchNameRef = AutoDisposeFutureProviderRef<String?>;
String _$memberExportActionsHash() =>
    r'ea670b0fe03eb7437d9228a7786e4d19f4ea6cc7';

/// Provider pour les actions d'export/import
///
/// Copied from [MemberExportActions].
@ProviderFor(MemberExportActions)
final memberExportActionsProvider =
    AutoDisposeAsyncNotifierProvider<MemberExportActions, void>.internal(
  MemberExportActions.new,
  name: r'memberExportActionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$memberExportActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MemberExportActions = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
