// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bankAccountRepositoryHash() =>
    r'b1dfb4b0e1ae8951b8c4a75f7bb1f753d884d326';

/// Repository provider
///
/// Copied from [bankAccountRepository].
@ProviderFor(bankAccountRepository)
final bankAccountRepositoryProvider =
    AutoDisposeProvider<IBankAccountRepository>.internal(
  bankAccountRepository,
  name: r'bankAccountRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bankAccountRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BankAccountRepositoryRef
    = AutoDisposeProviderRef<IBankAccountRepository>;
String _$bankAccountListHash() => r'be3d682b3f867ae1823cdb5db8e8e3ff176db4f7';

/// Liste des comptes bancaires pour l'église courante
///
/// Copied from [bankAccountList].
@ProviderFor(bankAccountList)
final bankAccountListProvider =
    AutoDisposeFutureProvider<List<BankAccount>>.internal(
  bankAccountList,
  name: r'bankAccountListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bankAccountListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BankAccountListRef = AutoDisposeFutureProviderRef<List<BankAccount>>;
String _$bankAccountStreamHash() => r'295e9a4f44cc28e93221529671a00ffa18d89e16';

/// Stream des comptes bancaires (temps réel)
///
/// Copied from [bankAccountStream].
@ProviderFor(bankAccountStream)
final bankAccountStreamProvider =
    AutoDisposeStreamProvider<List<BankAccount>>.internal(
  bankAccountStream,
  name: r'bankAccountStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bankAccountStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BankAccountStreamRef = AutoDisposeStreamProviderRef<List<BankAccount>>;
String _$defaultBankAccountHash() =>
    r'5a0e90b87dba2b4004d873782b9174533ff67e87';

/// Compte par défaut
///
/// Copied from [defaultBankAccount].
@ProviderFor(defaultBankAccount)
final defaultBankAccountProvider =
    AutoDisposeFutureProvider<BankAccount?>.internal(
  defaultBankAccount,
  name: r'defaultBankAccountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$defaultBankAccountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DefaultBankAccountRef = AutoDisposeFutureProviderRef<BankAccount?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
