// lib/features/finance/presentation/providers/compliance_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/finance_transaction.dart';
import '../../domain/services/compliance_engine.dart';
import '../../domain/services/validation_workflow_service.dart';
import '../../domain/services/fec_export_service.dart';

/// Provider pour le moteur de conformité
final complianceEngineProvider = Provider<ComplianceEngine>((ref) {
  return ComplianceEngine();
});

/// Provider pour le service de workflow de validation
final validationWorkflowProvider = Provider<ValidationWorkflowService>((ref) {
  return ValidationWorkflowService();
});

/// Provider pour le service d'export FEC
final fecExportServiceProvider = Provider<FECExportService>((ref) {
  return FECExportService();
});

/// Provider pour évaluer la conformité d'une transaction
final transactionComplianceProvider =
    Provider.family<ComplianceSummary, FinanceTransaction>((ref, transaction) {
  final engine = ref.watch(complianceEngineProvider);
  return engine.getSummary(transaction);
});

/// Provider pour les actions de workflow disponibles
final workflowActionsProvider = Provider.family<List<WorkflowAction>,
    ({String userRole, FinanceTransaction transaction})>((ref, params) {
  final workflow = ref.watch(validationWorkflowProvider);
  return workflow.getAvailableActions(params.userRole, params.transaction);
});