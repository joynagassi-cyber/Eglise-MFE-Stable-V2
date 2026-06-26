// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bibleTtsSettingsHash() => r'f603f424f0e5306eaaaa9c3b2b781ff458d10e0f';

/// See also [bibleTtsSettings].
@ProviderFor(bibleTtsSettings)
final bibleTtsSettingsProvider = AutoDisposeProvider<BibleTtsSettings>.internal(
  bibleTtsSettings,
  name: r'bibleTtsSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bibleTtsSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BibleTtsSettingsRef = AutoDisposeProviderRef<BibleTtsSettings>;
String _$bibleTranslationHash() => r'9514f98671910b86dc71b0979546990a4341ae4c';

/// See also [BibleTranslation].
@ProviderFor(BibleTranslation)
final bibleTranslationProvider =
    NotifierProvider<BibleTranslation, String>.internal(
  BibleTranslation.new,
  name: r'bibleTranslationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bibleTranslationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BibleTranslation = Notifier<String>;
String _$bibleTtsSettingsNotifierHash() =>
    r'e12647c0834f593f5c0609768a24498dc59a1d96';

/// See also [BibleTtsSettingsNotifier].
@ProviderFor(BibleTtsSettingsNotifier)
final bibleTtsSettingsNotifierProvider =
    NotifierProvider<BibleTtsSettingsNotifier, BibleTtsSettings>.internal(
  BibleTtsSettingsNotifier.new,
  name: r'bibleTtsSettingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bibleTtsSettingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BibleTtsSettingsNotifier = Notifier<BibleTtsSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
