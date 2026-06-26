// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentChapterHash() => r'c335ba8f0aa077c5c4f22e4de5a35d9102721d65';

/// See also [currentChapter].
@ProviderFor(currentChapter)
final currentChapterProvider = AutoDisposeProvider<BibleChapter?>.internal(
  currentChapter,
  name: r'currentChapterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentChapterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentChapterRef = AutoDisposeProviderRef<BibleChapter?>;
String _$bibleSearchResultsHash() =>
    r'016bf9e86695ea6ba7159c998dbcb39501abf2f8';

/// See also [bibleSearchResults].
@ProviderFor(bibleSearchResults)
final bibleSearchResultsProvider =
    AutoDisposeProvider<List<BibleVerse>>.internal(
  bibleSearchResults,
  name: r'bibleSearchResultsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bibleSearchResultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BibleSearchResultsRef = AutoDisposeProviderRef<List<BibleVerse>>;
String _$selectedVersesHash() => r'525f9831d75c13fb816a173528e36450dc15d168';

/// See also [selectedVerses].
@ProviderFor(selectedVerses)
final selectedVersesProvider = AutoDisposeProvider<Set<int>>.internal(
  selectedVerses,
  name: r'selectedVersesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedVersesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SelectedVersesRef = AutoDisposeProviderRef<Set<int>>;
String _$ttsPlaybackStateHash() => r'2a64c884d98faa90ae03e808286de168ecf2dc4c';

/// See also [ttsPlaybackState].
@ProviderFor(ttsPlaybackState)
final ttsPlaybackStateProvider = AutoDisposeProvider<TtsPlaybackState>.internal(
  ttsPlaybackState,
  name: r'ttsPlaybackStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ttsPlaybackStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TtsPlaybackStateRef = AutoDisposeProviderRef<TtsPlaybackState>;
String _$bibleNotifierHash() => r'6c4c4ad1163f32105f6d3d5936e65b6e4a0f83b8';

/// See also [BibleNotifier].
@ProviderFor(BibleNotifier)
final bibleNotifierProvider =
    NotifierProvider<BibleNotifier, BibleState>.internal(
  BibleNotifier.new,
  name: r'bibleNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bibleNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BibleNotifier = Notifier<BibleState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
