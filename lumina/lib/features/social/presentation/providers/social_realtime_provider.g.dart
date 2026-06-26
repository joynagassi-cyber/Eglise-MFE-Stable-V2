// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_realtime_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$watchPostsHash() => r'72b42ee66a9b42aba226074d15ebe7a2a240f415';

/// See also [watchPosts].
@ProviderFor(watchPosts)
final watchPostsProvider = AutoDisposeStreamProvider<List<SocialPost>>.internal(
  watchPosts,
  name: r'watchPostsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$watchPostsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WatchPostsRef = AutoDisposeStreamProviderRef<List<SocialPost>>;
String _$watchCommentsHash() => r'4f56b9cc9d32312e263d0ddd5444af412c7a831d';

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

/// See also [watchComments].
@ProviderFor(watchComments)
const watchCommentsProvider = WatchCommentsFamily();

/// See also [watchComments].
class WatchCommentsFamily extends Family<AsyncValue<List<Comment>>> {
  /// See also [watchComments].
  const WatchCommentsFamily();

  /// See also [watchComments].
  WatchCommentsProvider call(
    String postId,
  ) {
    return WatchCommentsProvider(
      postId,
    );
  }

  @override
  WatchCommentsProvider getProviderOverride(
    covariant WatchCommentsProvider provider,
  ) {
    return call(
      provider.postId,
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
  String? get name => r'watchCommentsProvider';
}

/// See also [watchComments].
class WatchCommentsProvider extends AutoDisposeStreamProvider<List<Comment>> {
  /// See also [watchComments].
  WatchCommentsProvider(
    String postId,
  ) : this._internal(
          (ref) => watchComments(
            ref as WatchCommentsRef,
            postId,
          ),
          from: watchCommentsProvider,
          name: r'watchCommentsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$watchCommentsHash,
          dependencies: WatchCommentsFamily._dependencies,
          allTransitiveDependencies:
              WatchCommentsFamily._allTransitiveDependencies,
          postId: postId,
        );

  WatchCommentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  Override overrideWith(
    Stream<List<Comment>> Function(WatchCommentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchCommentsProvider._internal(
        (ref) => create(ref as WatchCommentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Comment>> createElement() {
    return _WatchCommentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchCommentsProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WatchCommentsRef on AutoDisposeStreamProviderRef<List<Comment>> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _WatchCommentsProviderElement
    extends AutoDisposeStreamProviderElement<List<Comment>>
    with WatchCommentsRef {
  _WatchCommentsProviderElement(super.provider);

  @override
  String get postId => (origin as WatchCommentsProvider).postId;
}

String _$watchUnreadNotificationsHash() =>
    r'ffa2a6398979dd64ca73cd1076df4165b12e2585';

/// See also [watchUnreadNotifications].
@ProviderFor(watchUnreadNotifications)
final watchUnreadNotificationsProvider =
    AutoDisposeStreamProvider<int>.internal(
  watchUnreadNotifications,
  name: r'watchUnreadNotificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$watchUnreadNotificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WatchUnreadNotificationsRef = AutoDisposeStreamProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
