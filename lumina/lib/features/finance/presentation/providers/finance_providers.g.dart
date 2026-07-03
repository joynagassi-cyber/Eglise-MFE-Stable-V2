// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dataMaskingHash() => r'c6275d7d15dbbdf2a0ae9ab5a3201b12a0781120';

/// Provider pour gérer le masquage des données sensibles (Mode "Oil")
///
/// Copied from [DataMasking].
@ProviderFor(DataMasking)
final dataMaskingProvider =
    AutoDisposeNotifierProvider<DataMasking, bool>.internal(
  DataMasking.new,
  name: r'dataMaskingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dataMaskingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DataMasking = AutoDisposeNotifier<bool>;
String _$reconciliationActionsHash() =>
    r'b1b9cf652af508b7cc20f750c3869de0fdd6f5a3';

/// Notifier pour le rapprochement bancaire (Généré)
///
/// Copied from [ReconciliationActions].
@ProviderFor(ReconciliationActions)
final reconciliationActionsProvider = AutoDisposeNotifierProvider<
    ReconciliationActions, ReconciliationState>.internal(
  ReconciliationActions.new,
  name: r'reconciliationActionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reconciliationActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReconciliationActions = AutoDisposeNotifier<ReconciliationState>;
String _$reportActionsHash() => r'5b37ecab79e3053817d650c214bab1a2fcd04f74';

/// Notifier pour les rapports financiers (Généré)
///
/// Copied from [ReportActions].
@ProviderFor(ReportActions)
final reportActionsProvider =
    AutoDisposeNotifierProvider<ReportActions, ReportState>.internal(
  ReportActions.new,
  name: r'reportActionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reportActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReportActions = AutoDisposeNotifier<ReportState>;
String _$transactionApprovalActionsHash() =>
    r'6cf1dad4eceb6a89492ad8290f45deb7e943d756';

/// Notifier pour l'approbation des transactions (Généré)
///
/// Copied from [TransactionApprovalActions].
@ProviderFor(TransactionApprovalActions)
final transactionApprovalActionsProvider =
    AutoDisposeAsyncNotifierProvider<TransactionApprovalActions, void>.internal(
  TransactionApprovalActions.new,
  name: r'transactionApprovalActionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionApprovalActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionApprovalActions = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
