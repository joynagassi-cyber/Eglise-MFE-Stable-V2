// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$budgetListHash() => r'93240752eca5891762c764d1b1dc0937e8edf605';

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

/// Provider pour la liste des budgets
///
/// Copied from [budgetList].
@ProviderFor(budgetList)
const budgetListProvider = BudgetListFamily();

/// Provider pour la liste des budgets
///
/// Copied from [budgetList].
class BudgetListFamily extends Family<AsyncValue<List<Budget>>> {
  /// Provider pour la liste des budgets
  ///
  /// Copied from [budgetList].
  const BudgetListFamily();

  /// Provider pour la liste des budgets
  ///
  /// Copied from [budgetList].
  BudgetListProvider call({
    int? year,
    BudgetPeriod? period,
  }) {
    return BudgetListProvider(
      year: year,
      period: period,
    );
  }

  @override
  BudgetListProvider getProviderOverride(
    covariant BudgetListProvider provider,
  ) {
    return call(
      year: provider.year,
      period: provider.period,
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
  String? get name => r'budgetListProvider';
}

/// Provider pour la liste des budgets
///
/// Copied from [budgetList].
class BudgetListProvider extends AutoDisposeFutureProvider<List<Budget>> {
  /// Provider pour la liste des budgets
  ///
  /// Copied from [budgetList].
  BudgetListProvider({
    int? year,
    BudgetPeriod? period,
  }) : this._internal(
          (ref) => budgetList(
            ref as BudgetListRef,
            year: year,
            period: period,
          ),
          from: budgetListProvider,
          name: r'budgetListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$budgetListHash,
          dependencies: BudgetListFamily._dependencies,
          allTransitiveDependencies:
              BudgetListFamily._allTransitiveDependencies,
          year: year,
          period: period,
        );

  BudgetListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.period,
  }) : super.internal();

  final int? year;
  final BudgetPeriod? period;

  @override
  Override overrideWith(
    FutureOr<List<Budget>> Function(BudgetListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BudgetListProvider._internal(
        (ref) => create(ref as BudgetListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        period: period,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Budget>> createElement() {
    return _BudgetListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BudgetListProvider &&
        other.year == year &&
        other.period == period;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BudgetListRef on AutoDisposeFutureProviderRef<List<Budget>> {
  /// The parameter `year` of this provider.
  int? get year;

  /// The parameter `period` of this provider.
  BudgetPeriod? get period;
}

class _BudgetListProviderElement
    extends AutoDisposeFutureProviderElement<List<Budget>> with BudgetListRef {
  _BudgetListProviderElement(super.provider);

  @override
  int? get year => (origin as BudgetListProvider).year;
  @override
  BudgetPeriod? get period => (origin as BudgetListProvider).period;
}

String _$overBudgetsHash() => r'edbe719d8a3c7962b9c077956e0c7a80af104390';

/// Provider pour les budgets en dépassement
///
/// Copied from [overBudgets].
@ProviderFor(overBudgets)
final overBudgetsProvider = AutoDisposeFutureProvider<List<Budget>>.internal(
  overBudgets,
  name: r'overBudgetsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$overBudgetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OverBudgetsRef = AutoDisposeFutureProviderRef<List<Budget>>;
String _$nearLimitBudgetsHash() => r'400be1081611dc26b985e6481a7bcdcf38ce7012';

/// Provider pour les budgets proches de la limite (>= 80%)
///
/// Copied from [nearLimitBudgets].
@ProviderFor(nearLimitBudgets)
final nearLimitBudgetsProvider =
    AutoDisposeFutureProvider<List<Budget>>.internal(
  nearLimitBudgets,
  name: r'nearLimitBudgetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nearLimitBudgetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NearLimitBudgetsRef = AutoDisposeFutureProviderRef<List<Budget>>;
String _$budgetActionsHash() => r'45e4eda02570afb94db04f2ee264acbc10f77835';

/// See also [BudgetActions].
@ProviderFor(BudgetActions)
final budgetActionsProvider =
    AutoDisposeAsyncNotifierProvider<BudgetActions, void>.internal(
  BudgetActions.new,
  name: r'budgetActionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BudgetActions = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
