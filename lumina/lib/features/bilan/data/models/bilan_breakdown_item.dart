import 'package:freezed_annotation/freezed_annotation.dart';

part 'bilan_breakdown_item.freezed.dart';
part 'bilan_breakdown_item.g.dart';

@freezed
class BilanBreakdownItem with _$BilanBreakdownItem {
  const factory BilanBreakdownItem({
    required String key, // Category name, Group ID, or Month
    @Default(0) double totalIncome,
    @Default(0) double totalExpense,
    @Default(0) int transactionCount,
  }) = _BilanBreakdownItem;

  factory BilanBreakdownItem.fromJson(Map<String, dynamic> json) =>
      _$BilanBreakdownItemFromJson(json);
}