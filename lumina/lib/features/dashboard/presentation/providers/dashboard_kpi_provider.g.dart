// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_kpi_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$superadminFinanceChartHash() =>
    r'61567ff4da13174ce330d39a0dfa2b568f089b85';

/// Provider pour récupérer l'historique financier via RPC (12 mois max)
/// et le tronquer à 3 mois comme validé par l'utilisateur.
///
/// Copied from [superadminFinanceChart].
@ProviderFor(superadminFinanceChart)
final superadminFinanceChartProvider =
    AutoDisposeFutureProvider<List<double>>.internal(
  superadminFinanceChart,
  name: r'superadminFinanceChartProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$superadminFinanceChartHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SuperadminFinanceChartRef = AutoDisposeFutureProviderRef<List<double>>;
String _$dashboardKpiHash() => r'fe0f268705d47e0ba7a4912b8ae1ea993d82bfc5';

/// See also [DashboardKpi].
@ProviderFor(DashboardKpi)
final dashboardKpiProvider =
    AutoDisposeAsyncNotifierProvider<DashboardKpi, DashboardKpiData>.internal(
  DashboardKpi.new,
  name: r'dashboardKpiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dashboardKpiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DashboardKpi = AutoDisposeAsyncNotifier<DashboardKpiData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
