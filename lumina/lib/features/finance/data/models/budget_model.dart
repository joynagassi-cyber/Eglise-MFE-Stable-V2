// lib/features/finance/data/models/budget_model.dart
// Modèle Isar pour Budget (offline-first)

import 'package:isar/isar.dart';
import '../../domain/entities/enums/budget_period.dart';
import '../../domain/entities/budget.dart';

part 'budget_model.g.dart';

@collection
class BudgetModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id; // ID métier (UUID)

  @Index()
  String churchId;

  @Index()
  String categoryId;

  @Enumerated(EnumType.name)
  BudgetPeriod period;

  @Index()
  int year;

  int? month;
  int? quarter;

  double plannedAmount;
  double actualAmount;

  bool isApproved;
  String? approvedBy;
  DateTime? approvedAt;

  String? notes;

  // Sérialisation complète pour hydratation
  String? jsonData;

  // Indicateur de synchronisation
  bool isSynced;

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? lastSyncedAt;

  int version = 1;
  String deviceId = 'unknown';
  String createdBy = 'unknown';
  String updatedBy = 'unknown';

  bool isDeleted = false;
  DateTime? deletedAt;
  String? deletedBy;

  BudgetModel({
    required this.id,
    required this.churchId,
    required this.categoryId,
    required this.period,
    required this.year,
    this.month,
    this.quarter,
    required this.plannedAmount,
    this.actualAmount = 0.0,
    this.isApproved = false,
    this.approvedBy,
    this.approvedAt,
    this.notes,
    this.jsonData,
    this.isSynced = false,
    this.createdAt,
    this.updatedAt,
    this.lastSyncedAt,
  });

  /// Mapper vers le domaine
  Budget toDomain() {
    return Budget(
      id: id,
      churchId: churchId,
      categoryId: categoryId,
      period: period,
      year: year,
      month: month,
      quarter: quarter,
      plannedAmount: plannedAmount,
      actualAmount: actualAmount,
      status: isApproved ? 'approved' : 'active',
      isApproved: isApproved,
      approvedBy: approvedBy,
      approvedAt: approvedAt,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Mapper depuis le domaine
  static BudgetModel fromDomain(Budget budget) {
    return BudgetModel(
      id: budget.id,
      churchId: budget.churchId,
      categoryId: budget.categoryId,
      period: budget.period,
      year: budget.year,
      month: budget.month,
      quarter: budget.quarter,
      plannedAmount: budget.plannedAmount,
      actualAmount: budget.actualAmount,
      isApproved: budget.isApproved,
      approvedBy: budget.approvedBy,
      approvedAt: budget.approvedAt,
      notes: budget.notes,
      createdAt: budget.createdAt,
      updatedAt: budget.updatedAt,
    );
  }
}