// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskRepositoryHash() => r'e1315142f505f0034ae01a2f94d26a1c0eb87ff9';

/// See also [taskRepository].
@ProviderFor(taskRepository)
final taskRepositoryProvider = Provider<ITaskRepository>.internal(
  taskRepository,
  name: r'taskRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TaskRepositoryRef = ProviderRef<ITaskRepository>;
String _$taskHash() => r'bfe85fb18635025dcfa382dc12096a6476357963';

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

/// See also [task].
@ProviderFor(task)
const taskProvider = TaskFamily();

/// See also [task].
class TaskFamily extends Family<AsyncValue<Task?>> {
  /// See also [task].
  const TaskFamily();

  /// See also [task].
  TaskProvider call(
    String id,
  ) {
    return TaskProvider(
      id,
    );
  }

  @override
  TaskProvider getProviderOverride(
    covariant TaskProvider provider,
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
  String? get name => r'taskProvider';
}

/// See also [task].
class TaskProvider extends AutoDisposeFutureProvider<Task?> {
  /// See also [task].
  TaskProvider(
    String id,
  ) : this._internal(
          (ref) => task(
            ref as TaskRef,
            id,
          ),
          from: taskProvider,
          name: r'taskProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$taskHash,
          dependencies: TaskFamily._dependencies,
          allTransitiveDependencies: TaskFamily._allTransitiveDependencies,
          id: id,
        );

  TaskProvider._internal(
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
    FutureOr<Task?> Function(TaskRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskProvider._internal(
        (ref) => create(ref as TaskRef),
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
  AutoDisposeFutureProviderElement<Task?> createElement() {
    return _TaskProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TaskRef on AutoDisposeFutureProviderRef<Task?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _TaskProviderElement extends AutoDisposeFutureProviderElement<Task?>
    with TaskRef {
  _TaskProviderElement(super.provider);

  @override
  String get id => (origin as TaskProvider).id;
}

String _$watchTasksHash() => r'1da143adbeda2c56e438551aecabcda188f9adb9';

/// See also [watchTasks].
@ProviderFor(watchTasks)
const watchTasksProvider = WatchTasksFamily();

/// See also [watchTasks].
class WatchTasksFamily extends Family<AsyncValue<List<Task>>> {
  /// See also [watchTasks].
  const WatchTasksFamily();

  /// See also [watchTasks].
  WatchTasksProvider call({
    TaskType? type,
    String? groupId,
    String? assignedToId,
  }) {
    return WatchTasksProvider(
      type: type,
      groupId: groupId,
      assignedToId: assignedToId,
    );
  }

  @override
  WatchTasksProvider getProviderOverride(
    covariant WatchTasksProvider provider,
  ) {
    return call(
      type: provider.type,
      groupId: provider.groupId,
      assignedToId: provider.assignedToId,
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
  String? get name => r'watchTasksProvider';
}

/// See also [watchTasks].
class WatchTasksProvider extends AutoDisposeStreamProvider<List<Task>> {
  /// See also [watchTasks].
  WatchTasksProvider({
    TaskType? type,
    String? groupId,
    String? assignedToId,
  }) : this._internal(
          (ref) => watchTasks(
            ref as WatchTasksRef,
            type: type,
            groupId: groupId,
            assignedToId: assignedToId,
          ),
          from: watchTasksProvider,
          name: r'watchTasksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$watchTasksHash,
          dependencies: WatchTasksFamily._dependencies,
          allTransitiveDependencies:
              WatchTasksFamily._allTransitiveDependencies,
          type: type,
          groupId: groupId,
          assignedToId: assignedToId,
        );

  WatchTasksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
    required this.groupId,
    required this.assignedToId,
  }) : super.internal();

  final TaskType? type;
  final String? groupId;
  final String? assignedToId;

  @override
  Override overrideWith(
    Stream<List<Task>> Function(WatchTasksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchTasksProvider._internal(
        (ref) => create(ref as WatchTasksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
        groupId: groupId,
        assignedToId: assignedToId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Task>> createElement() {
    return _WatchTasksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchTasksProvider &&
        other.type == type &&
        other.groupId == groupId &&
        other.assignedToId == assignedToId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);
    hash = _SystemHash.combine(hash, assignedToId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WatchTasksRef on AutoDisposeStreamProviderRef<List<Task>> {
  /// The parameter `type` of this provider.
  TaskType? get type;

  /// The parameter `groupId` of this provider.
  String? get groupId;

  /// The parameter `assignedToId` of this provider.
  String? get assignedToId;
}

class _WatchTasksProviderElement
    extends AutoDisposeStreamProviderElement<List<Task>> with WatchTasksRef {
  _WatchTasksProviderElement(super.provider);

  @override
  TaskType? get type => (origin as WatchTasksProvider).type;
  @override
  String? get groupId => (origin as WatchTasksProvider).groupId;
  @override
  String? get assignedToId => (origin as WatchTasksProvider).assignedToId;
}

String _$memberTasksHash() => r'5c4fad2cc7f4de15b9aefaab648dd7c48ef96cc3';

/// See also [memberTasks].
@ProviderFor(memberTasks)
const memberTasksProvider = MemberTasksFamily();

/// See also [memberTasks].
class MemberTasksFamily extends Family<AsyncValue<List<Task>>> {
  /// See also [memberTasks].
  const MemberTasksFamily();

  /// See also [memberTasks].
  MemberTasksProvider call(
    String memberId,
  ) {
    return MemberTasksProvider(
      memberId,
    );
  }

  @override
  MemberTasksProvider getProviderOverride(
    covariant MemberTasksProvider provider,
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
  String? get name => r'memberTasksProvider';
}

/// See also [memberTasks].
class MemberTasksProvider extends AutoDisposeStreamProvider<List<Task>> {
  /// See also [memberTasks].
  MemberTasksProvider(
    String memberId,
  ) : this._internal(
          (ref) => memberTasks(
            ref as MemberTasksRef,
            memberId,
          ),
          from: memberTasksProvider,
          name: r'memberTasksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$memberTasksHash,
          dependencies: MemberTasksFamily._dependencies,
          allTransitiveDependencies:
              MemberTasksFamily._allTransitiveDependencies,
          memberId: memberId,
        );

  MemberTasksProvider._internal(
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
    Stream<List<Task>> Function(MemberTasksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MemberTasksProvider._internal(
        (ref) => create(ref as MemberTasksRef),
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
  AutoDisposeStreamProviderElement<List<Task>> createElement() {
    return _MemberTasksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberTasksProvider && other.memberId == memberId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, memberId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MemberTasksRef on AutoDisposeStreamProviderRef<List<Task>> {
  /// The parameter `memberId` of this provider.
  String get memberId;
}

class _MemberTasksProviderElement
    extends AutoDisposeStreamProviderElement<List<Task>> with MemberTasksRef {
  _MemberTasksProviderElement(super.provider);

  @override
  String get memberId => (origin as MemberTasksProvider).memberId;
}

String _$tasksControllerHash() => r'35517c41f0d3b3e830a974e3478fe8a88ddef2ec';

/// See also [TasksController].
@ProviderFor(TasksController)
final tasksControllerProvider =
    AutoDisposeAsyncNotifierProvider<TasksController, void>.internal(
  TasksController.new,
  name: r'tasksControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tasksControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TasksController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
