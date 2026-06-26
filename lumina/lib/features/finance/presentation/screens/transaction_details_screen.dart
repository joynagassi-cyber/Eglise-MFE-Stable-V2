import "package:lumina/core/widgets/widgets.dart";
import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../domain/entities/finance_transaction.dart';
import '../../domain/entities/enums/transaction_status.dart';
import '../../domain/entities/enums/transaction_type.dart';
import '../utils/finance_enums_ui_extensions.dart';
import '../providers/finance_providers.dart';
import 'package:lumina/features/sealing/presentation/providers/sealing_providers.dart';
import 'package:lumina/core/auth/domain/entities/enums/role_level.dart';
import 'package:lumina/core/providers/user_context_provider.dart';

import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/features/membres/presentation/providers/member_detail_provider.dart';



class TransactionDetailsScreen extends ConsumerStatefulWidget {
  final FinanceTransaction transaction;

  const TransactionDetailsScreen({super.key, required this.transaction});

  @override
  ConsumerState<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState
    extends ConsumerState<TransactionDetailsScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.transaction;
    final isIncome = t.type == TransactionType.income;
    final color = isIncome ? context.colors.successText : context.colors.errorText;

    // Role & Permissions
    final userContext = ref.watch(userContextNotifierProvider).valueOrNull;
    final userRole = userContext?.role.level;

    final isValidator = userRole == RoleLevel.staff ||
        userRole == RoleLevel.finance ||
        userRole == RoleLevel.adminTotal ||
        userRole == RoleLevel.superadmin;

    final canValidate = isValidator && t.status == TransactionStatus.pending;

    // Load Approvals
    final approvalsAsync = ref.watch(transactionApprovalsProvider(t.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Détails Transaction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Amount
            Center(
              child: Column(
                children: [
                  Text(
                    '${isIncome ? '+' : '-'}${NumberFormat.currency(locale: 'fr_FR', symbol: '').format(t.amount)} FCFA',
                    style: AppTypography.h1.copyWith(color: color),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: t.status.getColor(context).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      border: Border.all(color: t.status.getColor(context)),
                    ),
                    child: Text(
                      t.status.label,
                      style: TextStyle(
                        color: t.status.getColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Details Review
            _buildDetailRow('Description', t.description),
            _buildDetailRow('Catégorie', t.category ?? 'N/A'),
            _buildDetailRow(
              'Compte',
              t.accountId ?? 'N/A',
            ), // Should resolve name
            _buildDetailRow('Date', DateFormat('dd/MM/yyyy').format(t.date)),

            if (t.relatedMemberId != null) ...[
              const SizedBox(height: 16),
              Text('Membre Lié',
                  style: TextStyle(
                      color: context.colors.textTertiary, fontSize: 12)),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, _) {
                  final memberAsync =
                      ref.watch(memberDetailProvider(t.relatedMemberId!));
                  return memberAsync.when(
                    data: (member) => member != null
                        ? ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundImage: member.photoUrl != null
                                  ? NetworkImage(member.photoUrl!)
                                  : null,
                              child: member.photoUrl == null
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            title:
                                Text('${member.firstName} ${member.lastName}'),
                            subtitle: const Text('Voir le profil'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push(AppRoutes.brebisDetailsWithId(member.id)),
                          )
                        : const Text('Membre introuvable'),
                    loading: () => const AppProgressBar(),
                    error: (e, _) => Text('Erreur chargement membre: $e'),
                  );
                },
              ),
            ],

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            // Proof Image
            if (t.proofImages.isNotEmpty) ...[
              Text('Preuve / Reçu', style: AppTypography.h3),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: t.proofImages
                    .map((url) => ClipRRect(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          child: Image.network(
                            url,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Workflow / Approvals
            Text('Flux d\'approbation', style: AppTypography.h3),
            const SizedBox(height: 12),
            approvalsAsync.when(
              data: (approvals) => Column(
                children: approvals
                    .map((approval) => ListTile(
                          title: Text(approval.roleUsed),
                          subtitle: Text(
                              '${approval.decision.label}${approval.approverName != null ? " par ${approval.approverName}" : ""}'),
                        ))
                    .toList(),
              ),
              loading: () => Column(
                children: List.generate(
                    2,
                    (i) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: FireSkeletonAtom.rect(
                              context: context, height: 50, radius: 8),
                        )),
              ),
              error: (e, _) => const Text('Impossible de charger les détails'),
            ),

            const SizedBox(height: 32),

            if (!t.canBeModified) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.errorText.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border:
                      Border.all(color: context.colors.errorText.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock_clock_rounded,
                        color: context.colors.errorText, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Cette transaction date de plus de 30 jours et ne peut plus être modifiée ou validée.',
                        style: TextStyle(
                          color: context.colors.errorText.withValues(alpha: 0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            if (canValidate && t.canBeModified) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _validateAndSeal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.successText,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: LoadingDots(size: 24),
                            )
                          : Text('Valider & Sceller',
                              style: TextStyle(
                                  color: context.colors.textOnBrand)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isProcessing ? null : _reject,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colors.errorText,
                        side: BorderSide(color: context.colors.errorText),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Rejeter'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }


  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: context.colors.textTertiary),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Future<void> _validateAndSeal() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la validation'),
        content: const Text(
            'Voulez-vous vraiment valider et sceller cette transaction ? Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.successText),
            child: Text('Valider',
                style: TextStyle(color: context.colors.textOnBrand)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);
    try {
      final sealingService = ref.read(sealingServiceProvider);
      final sealRepository = ref.read(sealRepositoryProvider);
      final financeRepo = ref.read(financeRepositoryProvider);

      // 1. Compute Hash
      final payload = {
        'id': widget.transaction.id,
        'amount': widget.transaction.amount,
        'date': widget.transaction.date.toIso8601String(),
        'beneficiary': widget.transaction.description,
        'proofs': widget.transaction.proofImages,
      };

      final hash = sealingService.computeHash(payload);

      // 2. Sign (Lumina 2026 Sealing)
      final signature = sealingService.signPayload(payload);

      // 3. Update Status first
      final updatedTransaction = widget.transaction.copyWith(
        status: TransactionStatus
            .sealed, // Or validated, then sealed? Logic says sealed implies validated.
        updatedAt: DateTime.now(),
      );
      await financeRepo
          .saveTransaction(updatedTransaction); // First save status

      // 4. Seal Record
      await sealRepository.sealTransaction(
        transactionId: widget.transaction.id,
        payloadHash: hash,
        signature: signature,
      );

      // 5. Update Local State & Refresh
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Transaction validée et scellée avec succès'),
          backgroundColor: context.colors.successText,
        ),
      );

      ref.invalidate(transactionsProvider);
      ref.invalidate(transactionApprovalsProvider(widget.transaction.id));

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Impossible de mettre à jour la transaction'), backgroundColor: context.colors.errorText),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _reject() async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rejeter la transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Veuillez indiquer le motif du rejet :'),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Motif (ex: manque justificatif)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, true),
            style: OutlinedButton.styleFrom(foregroundColor: context.colors.errorText),
            child: const Text('Rejeter'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);
    try {
      final financeRepo = ref.read(financeRepositoryProvider);

      final updatedTransaction = widget.transaction.copyWith(
        status: TransactionStatus.rejected,
        notes: reasonController.text.isNotEmpty 
            ? 'REJET: ${reasonController.text}' 
            : widget.transaction.notes,
        updatedAt: DateTime.now(),
      );

      await financeRepo.saveTransaction(updatedTransaction);

      ref.invalidate(transactionsProvider);
      ref.invalidate(transactionApprovalsProvider(widget.transaction.id));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Transaction rejetée'),
          backgroundColor: context.colors.errorText,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Impossible de supprimer la transaction'), backgroundColor: context.colors.errorText),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }
}
