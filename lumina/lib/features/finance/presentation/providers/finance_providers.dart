import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:io';

import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';
import 'package:lumina/core/services/storage_service.dart';
import 'package:lumina/core/providers/auth_provider.dart';

import 'package:lumina/features/finance/domain/entities/finance_transaction.dart';
import 'package:lumina/features/finance/domain/entities/financial_account.dart';
import 'package:lumina/features/finance/domain/services/reconciliation_service.dart';
import 'package:lumina/features/reports/data/services/excel_report_service.dart';
import 'package:lumina/features/reports/data/services/enhanced_pdf_service.dart';
import 'package:lumina/features/finance/domain/entities/enums/transaction_status.dart';
import 'package:lumina/features/finance/domain/entities/enums/payment_method.dart';
import 'package:lumina/core/domain/entities/enums/audit_action.dart';
import 'package:lumina/core/providers/user_context_provider.dart';
import 'package:lumina/features/churches/presentation/providers/church_providers.dart';
import 'package:lumina/features/finance/domain/entities/approval.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lumina/features/finance/presentation/providers/approval_providers.dart';

part 'finance_providers.g.dart';

/// Provider pour gérer le masquage des données sensibles (Mode "Oil")
@riverpod
class DataMasking extends _$DataMasking {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

/// Provider pour la liste des transactions (Future - déprécié, préférer transactionsProvider)
final transactionListProvider = FutureProvider<List<FinanceTransaction>>((
  ref,
) async {
  final repository = ref.watch(financeRepositoryProvider);
  final result = await repository.getAllTransactions();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (transactions) => transactions,
  );
});

/// Provider pour la liste des transactions (Stream)
final transactionsProvider = StreamProvider<List<FinanceTransaction>>((ref) {
  final repository = ref.watch(financeRepositoryProvider);
  return repository.watchTransactions();
});

/// Provider pour les approbations d'une transaction
final transactionApprovalsProvider =
    FutureProvider.family<List<Approval>, String>((ref, transactionId) async {
  final repository = ref.watch(financeRepositoryProvider);
  final result = await repository.getApprovals(transactionId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (rawApprovals) =>
        rawApprovals.map((json) => Approval.fromJson(json)).toList(),
  );
});

/// Provider pour la liste des comptes
final accountsProvider = StreamProvider<List<FinancialAccount>>((ref) {
  final repository = ref.watch(financeRepositoryProvider);
  return repository.watchAccounts();
});

/// Provider pour le solde total consolidé de tous les comptes
final totalBalanceProvider = StreamProvider<double>((ref) {
  final accountsAsync = ref.watch(accountsProvider);

  return accountsAsync.when(
    data: (accounts) {
      final total = accounts.fold(0.0, (sum, a) => sum + a.balance);
      return Stream.value(total);
    },
    loading: () => Stream.value(0.0),
    error: (e, s) => Stream.value(0.0),
  );
});

/// Provider pour les statistiques mensuelles (Revenus, Dépenses) - RÉACTIF
final financeStatsProvider = StreamProvider<Map<String, double>>((ref) {
  final repository = ref.watch(financeRepositoryProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0);

  // On écoute les transactions pour mettre à jour les stats en temps réel
  return repository.watchTransactions().asyncMap((_) async {
    final incomeResult =
        await repository.getTotalIncome(startOfMonth, endOfMonth);
    final expenseResult =
        await repository.getTotalExpense(startOfMonth, endOfMonth);

    final income = incomeResult.fold((_) => 0.0, (v) => v);
    final expense = expenseResult.fold((_) => 0.0, (v) => v);

    return {'income': income, 'expense': expense, 'balance': income - expense};
  });
});

/// Provider pour filtrer les transactions par type ou compte
final filteredTransactionsProvider =
    Provider.family<AsyncValue<List<FinanceTransaction>>, String?>((
  ref,
  category,
) {
  final allTransactions = ref.watch(transactionsProvider);

  return allTransactions.whenData((list) {
    if (category == null || category.isEmpty) return list;
    return list.where((t) => t.category == category).toList();
  });
});

/// Provider pour les transactions en attente de validation
final pendingTransactionsProvider = FutureProvider<List<FinanceTransaction>>((
  ref,
) async {
  final repository = ref.watch(financeRepositoryProvider);
  final result = await repository.getAllTransactions();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (transactions) => transactions
        .where((t) =>
            t.status == TransactionStatus.pending ||
            t.status == TransactionStatus.draft)
        .toList(),
  );
});

/// State pour le rapprochement bancaire
class ReconciliationState {
  final List<ImportedTransaction> imported;
  final List<FinanceTransaction> matched;
  final bool isLoading;
  final String? error;

  const ReconciliationState({
    this.imported = const [],
    this.matched = const [],
    this.isLoading = false,
    this.error,
  });

  ReconciliationState copyWith({
    List<ImportedTransaction>? imported,
    List<FinanceTransaction>? matched,
    bool? isLoading,
    String? error,
  }) {
    return ReconciliationState(
      imported: imported ?? this.imported,
      matched: matched ?? this.matched,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier pour le rapprochement bancaire (Généré)
@riverpod
class ReconciliationActions extends _$ReconciliationActions {
  @override
  ReconciliationState build() => const ReconciliationState();

  Future<void> importFromFile(String filePath) async {
    state = state.copyWith(isLoading: true);
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Fichier non trouvé');
      }
      final content = await file.readAsString();
      await importCsv(content);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> pickAndImport() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        await importFromFile(result.files.single.path!);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> confirmImport(List<ImportedTransaction> transactions) async {
    state = state.copyWith(isLoading: true);
    try {
      final repository = ref.read(financeRepositoryProvider);
      for (final imported in transactions) {
        final tx = FinanceTransaction(
          id: '',
          amount: imported.amount,
          type: imported.type,
          date: imported.date,
          description: imported.description,
          paymentMethod: PaymentMethod.bankTransfer,
          status: TransactionStatus.pending,
          category: 'Import CSV',
          notes: 'Import rapprochement bancaire',
        );
        await repository.saveTransaction(tx);
      }
      ref.invalidate(transactionListProvider);
      ref.invalidate(pendingTransactionsProvider);
      state = state.copyWith(isLoading: false, imported: []);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> importCsv(String content) async {
    if (content.trim().isEmpty) {
      state = state.copyWith(error: 'Le fichier CSV est vide');
      return;
    }
    state = state.copyWith(isLoading: true);
    try {
      final service = ReconciliationService();
      final imported = service.parseCsv(content);

      if (imported.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'Aucune transaction trouvée dans le fichier CSV',
        );
        return;
      }

      final existingTransactions = await ref.read(
        transactionListProvider.future,
      );
      service.matchTransactions(imported, existingTransactions);

      state = state.copyWith(isLoading: false, imported: imported, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// State pour les rapports financiers
class ReportState {
  final bool isGenerating;
  final String? reportPath;
  final String? error;

  const ReportState({this.isGenerating = false, this.reportPath, this.error});

  /// Getters pour la compatibilité avec les écrans
  bool get isLoading => isGenerating;
  bool get hasError => error != null;

  // Alias pour la compatibilité avec l'écran FinanceDashboard
  File? get generatedFile => reportPath != null ? File(reportPath!) : null;

  ReportState copyWith({
    bool? isGenerating,
    String? reportPath,
    String? error,
  }) {
    return ReportState(
      isGenerating: isGenerating ?? this.isGenerating,
      reportPath: reportPath,
      error: error,
    );
  }
}

/// Notifier pour les rapports financiers (Généré)
@riverpod
class ReportActions extends _$ReportActions {
  @override
  ReportState build() => const ReportState();

  Future<void> generatePdfReport({
    required DateTime startDate,
    required DateTime endDate,
    required String churchName,
    required String reportType,
    bool showCharts = true,
  }) async {
    state = state.copyWith(isGenerating: true);
    try {
      final repository = ref.read(financeRepositoryProvider);
      final result = await repository.getAllTransactions();
      final transactions = result.fold(
        (failure) => throw Exception(failure.message),
        (txs) => txs,
      );

      // Charger le logo
      Uint8List? logoBytes;
      try {
        final byteData = await rootBundle.load('assets/images/app_icon.png');
        logoBytes = byteData.buffer.asUint8List();
      } catch (e) {
        debugPrint('Error loading logo: $e');
      }

      final storageService = ref.read(storageServiceProvider);
      final session = ref.read(authProvider).valueOrNull;
      final activeChurchId = ref.read(activeChurchIdProvider);

      final filteredTxs = transactions
          .where(
            (t) =>
                t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
                t.date.isBefore(endDate.add(const Duration(days: 1))),
          )
          .toList();

      final registreResult = await repository.getRegistreCulte();
      final registreData =
          registreResult.fold((_) => <Map<String, dynamic>>[], (v) => v);

      final service = EnhancedPdfService();
      final pdfBytes = await service.generateEnhancedReport(
        startDate: startDate,
        endDate: endDate,
        transactions: filteredTxs,
        registreCulte: registreData,
        churchName: churchName,
        reportType: 'Financier',
        showCharts: showCharts,
        logoBytes: logoBytes,
      );

      final fileName =
          'Rapport_${churchName}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';

      final file = await storageService.saveAndProcessReport(
        fileName: fileName,
        bytes: pdfBytes,
        uploadToCloud: true,
        entityType: 'finance_report',
        entityId: 'rep_${DateTime.now().millisecondsSinceEpoch}',
        churchId: activeChurchId,
        token: session?.accessToken,
      );

      state = state.copyWith(isGenerating: false, reportPath: file.path);
    } catch (e) {
      state = state.copyWith(isGenerating: false, error: e.toString());
    }
  }

  Future<void> generateExcelReport({
    required DateTime startDate,
    required DateTime endDate,
    required String churchName,
  }) async {
    state = state.copyWith(isGenerating: true);
    try {
      final repository = ref.read(financeRepositoryProvider);
      final result = await repository.getAllTransactions();
      final transactions = result.fold(
        (failure) => throw Exception(failure.message),
        (txs) => txs,
      );
      final storageService = ref.read(storageServiceProvider);
      final session = ref.read(authProvider).valueOrNull;
      final activeChurchId = ref.read(activeChurchIdProvider);

      final filteredTxs = transactions
          .where(
            (t) =>
                t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
                t.date.isBefore(endDate.add(const Duration(days: 1))),
          )
          .toList();

      final registreResult = await repository.getRegistreCulte();
      final registreData =
          registreResult.fold((_) => <Map<String, dynamic>>[], (v) => v);

      final service = ExcelReportService();
      final excelBytes = await service.generateFinancialReport(
        startDate: startDate,
        endDate: endDate,
        transactions: filteredTxs,
        registreCulte: registreData,
        churchName: churchName,
      );

      final fileName =
          'Expert_${churchName}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';

      final file = await storageService.saveAndProcessReport(
        fileName: fileName,
        bytes: excelBytes,
        uploadToCloud: true,
        entityType: 'finance_excel_report',
        entityId: 'rep_xl_${DateTime.now().millisecondsSinceEpoch}',
        churchId: activeChurchId,
        token: session?.accessToken,
      );

      state = state.copyWith(isGenerating: false, reportPath: file.path);
    } catch (e) {
      state = state.copyWith(isGenerating: false, error: e.toString());
    }
  }

  Future<void> openLastReport() async {
    if (state.reportPath != null) {
      final storageService = ref.read(storageServiceProvider);
      await storageService.openFile(File(state.reportPath!));
    }
  }

  Future<void> shareLastReport(BuildContext context, String fileName) async {
    if (state.reportPath != null) {
      final storageService = ref.read(storageServiceProvider);
      await storageService.shareFile(
        File(state.reportPath!),
        subject: 'Rapport Financier - $fileName',
      );
    }
  }

  Future<void> generateMonthlyReport(
    DateTime month, {
    bool isPdf = true,
  }) async {
    final activeChurch = ref.read(activeChurchProvider).valueOrNull;
    final churchName = activeChurch?.name ?? "Mon Église";

    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0);
    if (isPdf) {
      await generatePdfReport(
        startDate: start,
        endDate: end,
        churchName: churchName,
        reportType: "Mensuel",
      );
    } else {
      await generateExcelReport(
        startDate: start,
        endDate: end,
        churchName: churchName,
      );
    }
  }
}

/// Notifier pour l'approbation des transactions (Généré)
@riverpod
class TransactionApprovalActions extends _$TransactionApprovalActions {
  @override
  FutureOr<void> build() => null;

  Future<void> approve(String transactionId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // 1. Create Approval Record
      final userContext = ref.read(userContextNotifierProvider).valueOrNull;
      final approverName = userContext?.user.email.split('@').first ?? 'Utilisateur';

      await ref.read(financeApprovalRepoProvider).createApproval(
            transactionId: transactionId,
            roleUsed: userContext?.role.label ?? 'Finance',
            decision: ApprovalDecision.approved,
            approverName: approverName,
          );

      // 2. Update Transaction Status
      final repository = ref.read(financeRepositoryProvider);
      final result = await repository.getAllTransactions();
      final transactions = result.fold(
        (failure) => throw Exception(failure.message),
        (txs) => txs,
      );
      final tx = transactions.firstWhere((t) => t.id == transactionId);

      await repository.saveTransaction(
        tx.copyWith(
          status: TransactionStatus.validated,
          validatedAt: DateTime.now(),
        ),
      );

      // Invalidate related providers for UI refresh
      ref.invalidate(pendingTransactionsProvider);
      ref.invalidate(transactionListProvider);
      ref.invalidate(transactionApprovalsProvider(transactionId));

      // Audit Log
      if (userContext != null) {
        await ref.read(auditRepositoryProvider).logAction(
              action: AuditAction.seal,
              entityType: 'finance_transaction',
              entityId: transactionId,
              newData: {'status': TransactionStatus.validated.name},
              actorId: userContext.user.id,
              metadata: {
                'actor_name': approverName,
                'role_used': userContext.role.label,
                'dashboard_source': 'Admin',
                'church_id': userContext.churchId,
              },
            );
      }
    });
  }

  Future<void> reject(String transactionId, String reason) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userContext = ref.read(userContextNotifierProvider).valueOrNull;
      final approverName = userContext?.user.email.split('@').first ?? 'Utilisateur';

      // 1. Create Approval Record (Rejection)
      await ref.read(financeApprovalRepoProvider).createApproval(
            transactionId: transactionId,
            roleUsed: userContext?.role.label ?? 'Finance',
            decision: ApprovalDecision.rejected,
            approverName: approverName,
            comment: reason,
          );

      // 2. Update Transaction Status
      final repository = ref.read(financeRepositoryProvider);
      final result = await repository.getAllTransactions();
      final transactions = result.fold(
        (failure) => throw Exception(failure.message),
        (txs) => txs,
      );
      final tx = transactions.firstWhere((t) => t.id == transactionId);

      await repository.saveTransaction(
        tx.copyWith(
          status: TransactionStatus.rejected,
          notes: '${tx.notes ?? ''}\n[REJETÉ]: $reason',
        ),
      );

      // Invalidate related providers for UI refresh
      ref.invalidate(pendingTransactionsProvider);
      ref.invalidate(transactionListProvider);
      ref.invalidate(transactionApprovalsProvider(transactionId));

      // Audit Log
      if (userContext != null) {
        await ref.read(auditRepositoryProvider).logAction(
              action: AuditAction.update,
              entityType: 'finance_transaction',
              entityId: transactionId,
              newData: {
                'status': TransactionStatus.rejected.name,
                'reason': reason,
              },
              actorId: userContext.user.id,
              metadata: {
                'actor_name': approverName,
                'role_used': userContext.role.label,
                'dashboard_source': 'Admin',
                'church_id': userContext.churchId,
              },
            );
      }
    });
  }
}

/// Provider pour le registre des collectes (pivoted view)
final registreCulteProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(financeRepositoryProvider);
  final result = await repository.getRegistreCulte();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

/// Provider pour calculer les tendances dynamiques (Jan-Mar 2026)
final financeTrendProvider = Provider<AsyncValue<Map<String, dynamic>>>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);

  return transactionsAsync.whenData((txs) {
    if (txs.isEmpty) {
      return {
        'data': [0.0],
        'growth': 0.0
      };
    }

    // Filtrer pour la période Jan-Mar 2026
    final periods =
        txs.where((t) => t.date.year == 2026 && t.date.month <= 3).toList();
    periods.sort((a, b) => a.date.compareTo(b.date));

    // Aggréger par semaine pour le graphique (7 points)
    final points = <double>[];
    if (periods.isNotEmpty) {
      // Simplification: On prend les 7 dernières transactions ou agrégats
      int startIdx = periods.length - 7;
      if (startIdx < 0) startIdx = 0;
      for (var i = startIdx; i < periods.length; i++) {
        points.add(periods[i].amount);
      }
    }

    // Calculer la croissance (Mars 2026 vs Février 2026)
    final febSum = periods
        .where((t) => t.date.month == 2)
        .fold(0.0, (sum, t) => sum + t.amount);
    final marSum = periods
        .where((t) => t.date.month == 3)
        .fold(0.0, (sum, t) => sum + t.amount);

    final growth = febSum > 0 ? ((marSum - febSum) / febSum) * 100 : 0.0;

    return {
      'data': points.isEmpty ? [0.0] : points,
      'growth': growth,
    };
  });
});
