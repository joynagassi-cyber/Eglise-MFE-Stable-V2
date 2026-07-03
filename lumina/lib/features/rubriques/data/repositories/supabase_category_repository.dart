import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:isar/isar.dart';

import '../../domain/entities/transaction_category.dart';
import '../../domain/entities/enums/category_type.dart';
import '../../domain/repositories/category_repository.dart';
import '../models/category_model.dart';
import '../seed/default_categories.dart';
import '../../../../core/utils/supabase_extensions.dart';
import '../../../../core/data/local/isar_service.dart';

class SupabaseCategoryRepository
    implements CategoryRepository {
  final SupabaseClient _client;
  final IsarService _isarService;
  final Ref _ref;

  SupabaseCategoryRepository(this._client, this._isarService, this._ref);

  Isar get _isar => _isarService.db;

  @override
  Future<List<TransactionCategory>> getAllCategories({
    required String churchId,
    bool includeInactive = false,
  }) async {
    if (_isarService.isReady) {
      final query = _isar.categoryModels
          .filter()
          .churchIdEqualTo(churchId)
          .isDeletedEqualTo(false);

      final results = includeInactive
          ? await query.findAll()
          : await query.isActiveEqualTo(true).findAll();

      return results.map((model) => model.toDomain()).toList();
    }

    // Fallback Supabase
    try {
      var query = _client
          .from('transaction_categories')
          .select()
          .eq('churchId', churchId);
      if (!includeInactive) {
        query = query.eq('isActive', true);
      }
      final records = await query;
      return records
          .map((record) => TransactionCategory.fromJson(record))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<TransactionCategory>> getCategoriesByType({
    required String churchId,
    required CategoryType type,
  }) async {
    if (_isarService.isReady) {
      final categories = await _isar.categoryModels
          .filter()
          .churchIdEqualTo(churchId)
          .typeEqualTo(type)
          .isActiveEqualTo(true)
          .isDeletedEqualTo(false)
          .sortBySortOrder()
          .findAll();

      return categories.map((model) => model.toDomain()).toList();
    }

    try {
      final records = await _client
          .from('transaction_categories')
          .select()
          .eq('churchId', churchId)
          .eq('type', type.name)
          .eq('isActive', true)
          .order('sortOrder', ascending: true);
      return records
          .map((record) => TransactionCategory.fromJson(record))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<TransactionCategory>> getRootCategories({
    required String churchId,
    CategoryType? type,
  }) async {
    if (_isarService.isReady) {
      var query = _isar.categoryModels
          .filter()
          .churchIdEqualTo(churchId)
          .parentIdIsNull()
          .isActiveEqualTo(true)
          .isDeletedEqualTo(false);

      if (type != null) {
        query = query.typeEqualTo(type);
      }

      final categories = await query.sortBySortOrder().findAll();
      return categories.map((model) => model.toDomain()).toList();
    }

    try {
      var query = _client
          .from('transaction_categories')
          .select()
          .eq('churchId', churchId)
          .isFilter('parentId', null)
          .eq('isActive', true);

      if (type != null) {
        query = query.eq('type', type.name);
      }

      final records = await query.order('sortOrder', ascending: true);
      return records
          .map((record) => TransactionCategory.fromJson(record))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<TransactionCategory>> getChildCategories(String parentId) async {
    if (_isarService.isReady) {
      final categories = await _isar.categoryModels
          .filter()
          .parentIdEqualTo(parentId)
          .isActiveEqualTo(true)
          .isDeletedEqualTo(false)
          .sortBySortOrder()
          .findAll();

      return categories.map((model) => model.toDomain()).toList();
    }

    try {
      final records = await _client
          .from('transaction_categories')
          .select()
          .eq('parentId', parentId)
          .eq('isActive', true)
          .order('sortOrder', ascending: true);
      return records
          .map((record) => TransactionCategory.fromJson(record))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<TransactionCategory?> getCategoryById(String id) async {
    if (_isarService.isReady) {
      final model =
          await _isar.categoryModels.filter().idEqualTo(id).findFirst();
      if (model != null) return model.toDomain();
    }

    try {
      final record = await _client
          .from('transaction_categories')
          .select()
          .eq('id', id)
          .maybeSingle();
      if (record == null) return null;
      return TransactionCategory.fromJson(record);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<TransactionCategory> createCategory(
    TransactionCategory category,
  ) async {
    if (_isarService.isReady) {
      final model = CategoryModel.fromDomain(category);
      await _isar.writeTxn(() => _isar.categoryModels.put(model));
    }

    try {
      final json = category.toJson();
      json.remove('id');

      await _client
          .from('transaction_categories')
          .insertScoped(_ref, values: json, churchColumn: 'churchId');
    } catch (e) {
      // Offline-first
    }

    return category;
  }

  @override
  Future<TransactionCategory> updateCategory(
    TransactionCategory category,
  ) async {
    if (_isarService.isReady) {
      final model = CategoryModel.fromDomain(category);
      await _isar.writeTxn(() => _isar.categoryModels.put(model));
    }

    try {
      await _client
          .from('transaction_categories')
          .update(category.toJson())
          .scoped(_ref, churchColumn: 'churchId')
          .eq('id', category.id);
    } catch (e) {
      // Offline-first
    }

    return category;
  }

  @override
  Future<void> deleteCategory(String id) async {
    if (_isarService.isReady) {
      final model =
          await _isar.categoryModels.filter().idEqualTo(id).findFirst();
      if (model != null) {
        model.isActive = false;
        await _isar.writeTxn(() => _isar.categoryModels.put(model));
      }
    }

    try {
      await _client
          .from('transaction_categories')
          .update({'isActive': false})
          .scoped(_ref, churchColumn: 'churchId')
          .eq('id', id);
    } catch (e) {
      // Offline-first
    }
  }

  @override
  Future<void> permanentlyDeleteCategory(String id) async {
    if (_isarService.isReady) {
      await _isar.writeTxn(
        () => _isar.categoryModels.filter().idEqualTo(id).deleteAll(),
      );
    }

    try {
      await _client
          .from('transaction_categories')
          .delete()
          .scoped(_ref, churchColumn: 'churchId')
          .eq('id', id);
    } catch (e) {
      // Offline-first
    }
  }

  @override
  Future<void> reorderCategories(List<String> categoryIds) async {
    if (_isarService.isReady) {
      await _isar.writeTxn(() async {
        for (var i = 0; i < categoryIds.length; i++) {
          final model = await _isar.categoryModels
              .filter()
              .idEqualTo(categoryIds[i])
              .findFirst();
          if (model != null) {
            model.sortOrder = i;
            await _isar.categoryModels.put(model);
          }
        }
      });
    }

    for (var i = 0; i < categoryIds.length; i++) {
      try {
        await _client
            .from('transaction_categories')
            .update({'sortOrder': i}).eq('id', categoryIds[i]);
      } catch (e) {
        // Offline-first
      }
    }
  }

  @override
  Future<void> syncCategories(String churchId) async {
    try {
      final records = await _client
          .from('transaction_categories')
          .select()
          .scoped(_ref, churchColumn: 'churchId');

      if (_isarService.isReady) {
        await _isar.writeTxn(() async {
          for (final record in records) {
            final model = CategoryModel.fromDomain(
              TransactionCategory.fromJson(record),
            );
            await _isar.categoryModels.put(model);
          }
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> seedDefaultCategories(String churchId) async {
    final defaultCategories = DefaultCategoriesData.getAllCategories(churchId);

    if (_isarService.isReady) {
      await _isar.writeTxn(() async {
        for (final category in defaultCategories) {
          await _isar.categoryModels.put(CategoryModel.fromDomain(category));
        }
      });
    }

    for (final category in defaultCategories) {
      try {
        await _client.from('transaction_categories').insert(category.toJson());
      } catch (e) {
        // Offline-first
      }
    }
  }

  @override
  Future<int> countTransactionsUsingCategory(String categoryId) async {
    return 0; // Or implement logic connecting to transactions
  }

  @override
  Stream<List<TransactionCategory>> watchCategories({
    required String churchId,
  }) async* {
    if (!_isarService.isReady) {
      yield* _client
          .from('transaction_categories')
          .stream(primaryKey: ['id'])
          .eq('churchId', churchId)
          .map((records) => records
              .where((r) => r['isActive'] == true)
              .map((r) => TransactionCategory.fromJson(r))
              .toList());
      return;
    }

    yield* _isar.categoryModels
        .filter()
        .churchIdEqualTo(churchId)
        .isActiveEqualTo(true)
        .isDeletedEqualTo(false)
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toDomain()).toList());
  }
}