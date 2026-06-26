// lib/features/finance/data/repositories/bank_account_repository_impl.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/bank_account.dart';
import '../../domain/repositories/i_bank_account_repository.dart';
import '../../../../core/utils/app_date_time.dart';

class SupabaseBankAccountRepository implements IBankAccountRepository {
  final SupabaseClient _client;
  final _logger = Logger();
  static const _table = 'bank_accounts';

  SupabaseBankAccountRepository(this._client);

  @override
  Future<List<BankAccount>> getByChurchId(String churchId) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('church_id', churchId)
          .eq('is_active', true)
          .order('is_default', ascending: false)
          .order('name');

      return response.map((json) => _fromSupabase(json)).toList();
    } catch (e) {
      _logger.e('Error fetching bank accounts: $e');
      return [];
    }
  }

  @override
  Future<BankAccount?> getById(String id) async {
    try {
      final response =
          await _client.from(_table).select().eq('id', id).maybeSingle();
      if (response == null) return null;
      return _fromSupabase(response);
    } catch (e) {
      _logger.e('Error fetching bank account $id: $e');
      return null;
    }
  }

  @override
  Future<BankAccount?> getDefaultAccount(String churchId) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('church_id', churchId)
          .eq('is_default', true)
          .maybeSingle();
      if (response == null) return null;
      return _fromSupabase(response);
    } catch (e) {
      _logger.e('Error fetching default account: $e');
      return null;
    }
  }

  @override
  Future<void> save(BankAccount account) async {
    try {
      final data = _toSupabase(account);
      await _client.from(_table).upsert(data);
    } catch (e) {
      _logger.e('Error saving bank account: $e');
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _client.from(_table).update({'is_active': false}).eq('id', id);
    } catch (e) {
      _logger.e('Error deleting bank account $id: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateBalance(String id, double newBalance) async {
    try {
      await _client.from(_table).update({
        'balance': newBalance,
        'updated_at': AppDateTime.nowIso(),
      }).eq('id', id);
    } catch (e) {
      _logger.e('Error updating balance for $id: $e');
      rethrow;
    }
  }

  @override
  Stream<List<BankAccount>> watchByChurchId(String churchId) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('church_id', churchId)
        .map(
          (rows) => rows
              .where((r) => r['is_active'] == true)
              .map((json) => _fromSupabase(json))
              .toList(),
        );
  }

  // --- Mapping helpers ---

  BankAccount _fromSupabase(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'] as String,
      churchId: json['church_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      accountType: _parseAccountType(json['account_type'] as String?),
      currency: json['currency'] as String? ?? 'XAF',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      initialBalance: (json['initial_balance'] as num?)?.toDouble() ?? 0.0,
      bankName: json['bank_name'] as String?,
      accountNumber: json['account_number'] as String?,
      iban: json['iban'] as String?,
      swift: json['swift'] as String?,
      description: json['description'] as String?,
      groupId: json['group_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> _toSupabase(BankAccount account) {
    return {
      'id': account.id,
      'church_id': account.churchId,
      'name': account.name,
      'account_type': account.accountType.name,
      'currency': account.currency,
      'balance': account.balance,
      'initial_balance': account.initialBalance,
      'bank_name': account.bankName,
      'account_number': account.accountNumber,
      'iban': account.iban,
      'swift': account.swift,
      'description': account.description,
      'group_id': account.groupId,
      'is_active': account.isActive,
      'is_default': account.isDefault,
      'updated_at': AppDateTime.nowIso(),
    };
  }

  BankAccountType _parseAccountType(String? value) {
    switch (value) {
      case 'cash':
        return BankAccountType.cash;
      case 'mobileMoney':
        return BankAccountType.mobileMoney;
      case 'savings':
        return BankAccountType.savings;
      default:
        return BankAccountType.bank;
    }
  }
}