import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'providers/approval_providers.dart';
import 'widgets/approval_card.dart';
import '../../../core/extensions/context_extension.dart';

class ApprovalTaskboardScreen extends ConsumerWidget {
  const ApprovalTaskboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingApprovalsProvider);

    return LuminaPage(
      title: "Circuit d'Approbation",
      onRefresh: () async => ref.invalidate(pendingApprovalsProvider),
      body: pendingAsync.when(
        data: (requests) {
          if (requests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user_outlined, size: 64, color: context.colors.textTertiary),
                  SizedBox(height: 16),
                  Text("Tout est en règle !", style: LuminaDesign.h2Of(context)),
                  Text("Aucune demande en attente."),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(LuminaDesign.paddingMd),
            itemCount: requests.length,
            itemBuilder: (ctx, i) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ApprovalCard(request: requests[i]),
            ),
          );
        },
        loading: () => const LoadingState(),
        error: (e, _) => Center(child: Text("Erreur : $e")),
      ),
    );
  }
}
