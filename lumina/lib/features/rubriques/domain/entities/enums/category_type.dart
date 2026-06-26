// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

/// Type de catégorie financière
@JsonEnum(valueField: 'value')
enum CategoryType {
  /// Catégorie de revenus (dîmes, offrandes, dons, etc.)
  income('income', 'Revenu'),

  /// Catégorie de dépenses (salaires, entretien, projets, etc.)
  expense('expense', 'Dépense');

  const CategoryType(this.value, this.label);

  final String value;
  final String label;

  factory CategoryType.fromValue(String value) {
    return CategoryType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => CategoryType.expense,
    );
  }
}