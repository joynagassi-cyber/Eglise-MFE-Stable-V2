import 'package:equatable/equatable.dart';

/// Status of a bilan period
enum BilanPeriodStatus {
  open,
  pendingReview,
  sealed,
  archived;

  static BilanPeriodStatus fromString(String value) {
    switch (value) {
      case 'pending_review':
        return BilanPeriodStatus.pendingReview;
      case 'sealed':
        return BilanPeriodStatus.sealed;
      case 'archived':
        return BilanPeriodStatus.archived;
      default:
        return BilanPeriodStatus.open;
    }
  }

  String toDbString() {
    switch (this) {
      case BilanPeriodStatus.pendingReview:
        return 'pending_review';
      case BilanPeriodStatus.sealed:
        return 'sealed';
      case BilanPeriodStatus.archived:
        return 'archived';
      case BilanPeriodStatus.open:
        return 'open';
    }
  }
}

/// Represents a sealed/open bilan period (month) persisted in Supabase
class BilanPeriod extends Equatable {
  final String id;
  final String churchId;
  final int year;
  final int month;
  final BilanPeriodStatus status;
  final DateTime? sealedAt;
  final String? sealedBy;
  final String? sealHash;
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  final Map<String, dynamic> categoryBreakdown;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BilanPeriod({
    required this.id,
    required this.churchId,
    required this.year,
    required this.month,
    required this.status,
    this.sealedAt,
    this.sealedBy,
    this.sealHash,
    this.totalIncome = 0,
    this.totalExpense = 0,
    this.netBalance = 0,
    this.categoryBreakdown = const {},
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isSealed => status == BilanPeriodStatus.sealed;
  bool get isOpen => status == BilanPeriodStatus.open;
  bool get isPendingReview => status == BilanPeriodStatus.pendingReview;

  /// Month label in French
  String get monthLabel {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
    ];
    return months[month - 1];
  }

  /// Short month label
  String get monthShortLabel {
    const months = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
      'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc',
    ];
    return months[month - 1];
  }

  factory BilanPeriod.fromJson(Map<String, dynamic> json) => BilanPeriod(
        id: json['id'] as String? ?? '',
        churchId: json['church_id'] as String? ?? '',
        year: json['year'] as int? ?? DateTime.now().year,
        month: json['month'] as int? ?? 1,
        status: BilanPeriodStatus.fromString(json['status'] as String? ?? 'open'),
        sealedAt: json['sealed_at'] != null
            ? DateTime.tryParse(json['sealed_at'] as String)
            : null,
        sealedBy: json['sealed_by'] as String?,
        sealHash: json['seal_hash'] as String?,
        totalIncome: (json['total_income'] as num?)?.toDouble() ?? 0,
        totalExpense: (json['total_expense'] as num?)?.toDouble() ?? 0,
        netBalance: (json['net_balance'] as num?)?.toDouble() ?? 0,
        categoryBreakdown:
            (json['category_breakdown'] as Map<String, dynamic>?) ?? {},
        notes: json['notes'] as String?,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : DateTime.now(),
      );

  BilanPeriod copyWith({
    String? id,
    String? churchId,
    int? year,
    int? month,
    BilanPeriodStatus? status,
    DateTime? sealedAt,
    String? sealedBy,
    String? sealHash,
    double? totalIncome,
    double? totalExpense,
    double? netBalance,
    Map<String, dynamic>? categoryBreakdown,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BilanPeriod(
      id: id ?? this.id,
      churchId: churchId ?? this.churchId,
      year: year ?? this.year,
      month: month ?? this.month,
      status: status ?? this.status,
      sealedAt: sealedAt ?? this.sealedAt,
      sealedBy: sealedBy ?? this.sealedBy,
      sealHash: sealHash ?? this.sealHash,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      netBalance: netBalance ?? this.netBalance,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'church_id': churchId,
        'year': year,
        'month': month,
        'status': status.toDbString(),
        'sealed_at': sealedAt?.toIso8601String(),
        'sealed_by': sealedBy,
        'seal_hash': sealHash,
        'total_income': totalIncome,
        'total_expense': totalExpense,
        'net_balance': netBalance,
        'category_breakdown': categoryBreakdown,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id, churchId, year, month, status,
        sealedAt, sealedBy, sealHash,
        totalIncome, totalExpense, netBalance,
        categoryBreakdown, notes, createdAt, updatedAt,
      ];
}