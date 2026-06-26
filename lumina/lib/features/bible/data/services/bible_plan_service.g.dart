// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_plan_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeBiblePlansHash() => r'961626adc4e8573e771cc5a2aa7ee19e9f75187c';

/// See also [activeBiblePlans].
@ProviderFor(activeBiblePlans)
final activeBiblePlansProvider =
    AutoDisposeFutureProvider<List<BiblePlanProgressModel>>.internal(
  activeBiblePlans,
  name: r'activeBiblePlansProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeBiblePlansHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ActiveBiblePlansRef
    = AutoDisposeFutureProviderRef<List<BiblePlanProgressModel>>;
String _$biblePlanServiceHash() => r'2d30447ee6c15570f1b7e76a3b99198c8caedeb1';

/// See also [BiblePlanService].
@ProviderFor(BiblePlanService)
final biblePlanServiceProvider =
    NotifierProvider<BiblePlanService, List<BibleReadingPlanModel>>.internal(
  BiblePlanService.new,
  name: r'biblePlanServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$biblePlanServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BiblePlanService = Notifier<List<BibleReadingPlanModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
