// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_annotation_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bibleAnnotationsHash() => r'ef9e1c68ecfc02e073376a5af3f14750485e2569';

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

abstract class _$BibleAnnotations
    extends BuildlessAutoDisposeAsyncNotifier<List<BibleAnnotationModel>> {
  late final String book;
  late final int chapter;

  FutureOr<List<BibleAnnotationModel>> build(
    String book,
    int chapter,
  );
}

/// See also [BibleAnnotations].
@ProviderFor(BibleAnnotations)
const bibleAnnotationsProvider = BibleAnnotationsFamily();

/// See also [BibleAnnotations].
class BibleAnnotationsFamily
    extends Family<AsyncValue<List<BibleAnnotationModel>>> {
  /// See also [BibleAnnotations].
  const BibleAnnotationsFamily();

  /// See also [BibleAnnotations].
  BibleAnnotationsProvider call(
    String book,
    int chapter,
  ) {
    return BibleAnnotationsProvider(
      book,
      chapter,
    );
  }

  @override
  BibleAnnotationsProvider getProviderOverride(
    covariant BibleAnnotationsProvider provider,
  ) {
    return call(
      provider.book,
      provider.chapter,
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
  String? get name => r'bibleAnnotationsProvider';
}

/// See also [BibleAnnotations].
class BibleAnnotationsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    BibleAnnotations, List<BibleAnnotationModel>> {
  /// See also [BibleAnnotations].
  BibleAnnotationsProvider(
    String book,
    int chapter,
  ) : this._internal(
          () => BibleAnnotations()
            ..book = book
            ..chapter = chapter,
          from: bibleAnnotationsProvider,
          name: r'bibleAnnotationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bibleAnnotationsHash,
          dependencies: BibleAnnotationsFamily._dependencies,
          allTransitiveDependencies:
              BibleAnnotationsFamily._allTransitiveDependencies,
          book: book,
          chapter: chapter,
        );

  BibleAnnotationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.book,
    required this.chapter,
  }) : super.internal();

  final String book;
  final int chapter;

  @override
  FutureOr<List<BibleAnnotationModel>> runNotifierBuild(
    covariant BibleAnnotations notifier,
  ) {
    return notifier.build(
      book,
      chapter,
    );
  }

  @override
  Override overrideWith(BibleAnnotations Function() create) {
    return ProviderOverride(
      origin: this,
      override: BibleAnnotationsProvider._internal(
        () => create()
          ..book = book
          ..chapter = chapter,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        book: book,
        chapter: chapter,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<BibleAnnotations,
      List<BibleAnnotationModel>> createElement() {
    return _BibleAnnotationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BibleAnnotationsProvider &&
        other.book == book &&
        other.chapter == chapter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, book.hashCode);
    hash = _SystemHash.combine(hash, chapter.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BibleAnnotationsRef
    on AutoDisposeAsyncNotifierProviderRef<List<BibleAnnotationModel>> {
  /// The parameter `book` of this provider.
  String get book;

  /// The parameter `chapter` of this provider.
  int get chapter;
}

class _BibleAnnotationsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<BibleAnnotations,
        List<BibleAnnotationModel>> with BibleAnnotationsRef {
  _BibleAnnotationsProviderElement(super.provider);

  @override
  String get book => (origin as BibleAnnotationsProvider).book;
  @override
  int get chapter => (origin as BibleAnnotationsProvider).chapter;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
