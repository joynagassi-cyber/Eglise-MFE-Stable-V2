import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import '../../../finance/domain/entities/financial_account.dart';
import '../../../finance/domain/entities/finance_transaction.dart';
import '../../../finance/domain/entities/enums/transaction_type.dart';
import '../../../finance/domain/entities/enums/payment_method.dart';
import '../../../finance/presentation/providers/finance_providers.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';
import '../providers/group_providers.dart';

class GroupMemberPaymentList extends ConsumerWidget {
  final String groupId;

  const GroupMemberPaymentList({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(groupMembersProvider(groupId));

    return membersAsync.when(
      data: (members) {
        if (members.isEmpty) {
          return const Center(child: Text('Aucun membre dans ce groupe.'));
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: members.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final membership = members[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: context.colors.brandPrimaryContainer,
                child: Icon(Icons.person, color: context.colors.brandPrimary),
              ),
              title: Text(
                membership.memberName ??
                    'Membre #${membership.memberId.substring(0, 5)}',
                style: const TextStyle(fontFamily: LuminaFont.body, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Rôle: ${membership.role.name}',
                style: TextStyle(fontFamily: LuminaFont.body, color: context.colors.textSecondary),
              ),
              trailing: FilledButton(
                onPressed: () =>
                    _showPaymentDialog(context, ref, membership.memberId),
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.brandPrimary,
                  foregroundColor: context.colors.textInverse,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Encaisser'),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: LoadingState()),
      error: (e, st) => const Center(child: Text('Impossible de charger les paiements')),
    );
  }

  void _showPaymentDialog(
    BuildContext context,
    WidgetRef ref,
    String memberId,
  ) {
    final amountController = TextEditingController(text: '1000');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Enregistrer un versement',
          style: TextStyle(
            fontFamily: LuminaFont.display,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Montant (F)',
                labelStyle: TextStyle(fontFamily: LuminaFont.body, fontSize: 13, color: context.colors.textSecondary),
                suffixText: 'FCFA',
                suffixStyle: TextStyle(fontFamily: LuminaFont.body, fontSize: 12, color: context.colors.textTertiary),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Ce versement sera ajouté à la caisse du groupe.',
              style: TextStyle(
                fontFamily: LuminaFont.body,
                fontSize: 12,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text) ?? 0;
              if (amount <= 0) return;

              await HapticHelper.medium();

              // logic to save transaction
              final repository = ref.read(financeRepositoryProvider);
              final accounts = await ref.read(accountsProvider.future);

              if (accounts.isEmpty) {
                if (context.mounted) {
                  Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Aucun compte financier configuré.', style: TextStyle(fontFamily: LuminaFont.body)),
                        backgroundColor: context.colors.errorBg,
                      ),
                    );
                }
                return;
              }

              // Find the account linked to this group
              final groupAccount = accounts.firstWhere(
                (acc) => acc.groupId == groupId,
                orElse: () => accounts.firstWhere(
                  (acc) => acc.type == FinancialAccountType.cash,
                  orElse: () => accounts.first,
                ),
              );

              final transaction = FinanceTransaction(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                amount: amount,
                type: TransactionType.income,
                category: 'COTISATION_GROUPE',
                description: 'Cotisation membre $memberId',
                date: DateTime.now(),
                accountId: groupAccount.id,
                paymentMethod: PaymentMethod.cash,
                groupId: groupId,
                relatedMemberId: memberId,
              );

              await repository.saveTransaction(transaction);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Paiement enregistré avec succès !'),
                  ),
                );
              }
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}
