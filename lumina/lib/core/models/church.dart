// ============================================================
// FICHIER : lib/core/models/church.dart
// DESCRIPTION : Modèle Church mappé depuis la table 'churches'
// DÉPENDANCES : aucune (pur Dart)
// ============================================================

class Church {
  final String id;
  final String name;
  final String? address;
  final String? logoUrl;
  final String currency;
  final int fiscalYearStart;
  final DateTime createdAt;

  const Church({
    required this.id,
    required this.name,
    this.address,
    this.logoUrl,
    this.currency = 'XOF',
    this.fiscalYearStart = 1,
    required this.createdAt,
  });

  factory Church.fromJson(Map<String, dynamic> json) {
    return Church(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      address: json['address'] as String?,
      logoUrl: json['logo_url'] as String?,
      currency: json['currency'] as String? ?? 'XOF',
      fiscalYearStart: json['fiscal_year_start'] as int? ?? 1,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'logo_url': logoUrl,
      'currency': currency,
      'fiscal_year_start': fiscalYearStart,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Church copyWith({
    String? id,
    String? name,
    String? address,
    String? logoUrl,
    String? currency,
    int? fiscalYearStart,
    DateTime? createdAt,
  }) {
    return Church(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      logoUrl: logoUrl ?? this.logoUrl,
      currency: currency ?? this.currency,
      fiscalYearStart: fiscalYearStart ?? this.fiscalYearStart,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Church && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Church($name)';
}
