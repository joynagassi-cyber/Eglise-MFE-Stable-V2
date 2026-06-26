// lib/features/finance/domain/entities/fund_source.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fund_source.freezed.dart';
part 'fund_source.g.dart';

/// Source de financement conforme OHADA (IMAGIR)
/// Reflète la table `fund_sources` Supabase
@freezed
class FundSource with _$FundSource {
  const FundSource._();

  const factory FundSource({
    required String code,
    required String label,
    @Default(false) bool requiresForeignDeclaration,
    @Default(false) bool requiresNif,
    int? maxAmountCfa,
    @Default(true) bool active,
    DateTime? createdAt,
  }) = _FundSource;

  factory FundSource.fromJson(Map<String, dynamic> json) =>
      _$FundSourceFromJson(json);

  /// Vérifie si un montant dépasse le plafond autorisé
  bool exceedsLimit(double amount) {
    if (maxAmountCfa == null) return false;
    return amount > maxAmountCfa!;
  }

  /// Liste des sources de fonds standard IMAGIR
  static const List<FundSource> defaults = [
    FundSource(code: 'fonds_propres', label: 'Fonds Propres'),
    FundSource(code: 'cotisation', label: 'Cotisation Membres'),
    FundSource(code: 'dime', label: 'Dîmes'),
    FundSource(code: 'offrande', label: 'Offrandes'),
    FundSource(code: 'don_local', label: 'Don Local'),
    FundSource(
      code: 'don_etranger',
      label: 'Don Étranger',
      requiresForeignDeclaration: true,
      requiresNif: true,
    ),
    FundSource(code: 'subvention', label: 'Subvention'),
    FundSource(code: 'autre', label: 'Autre'),
  ];
}