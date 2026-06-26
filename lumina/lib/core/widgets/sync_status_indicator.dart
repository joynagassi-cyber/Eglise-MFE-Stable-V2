import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';

class SyncStatusIndicator extends StatelessWidget {
  final bool isSynced;
  final String? lastSync;
  final bool compact;

  const SyncStatusIndicator({
    super.key,
    required this.isSynced,
    this.lastSync,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Tooltip(
        message: isSynced ? 'Synchronisé' : 'Synchronisation en attente',
        child: Icon(
          isSynced ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
          size: 16,
          color: isSynced 
              ? context.colors.successText.withOpacity(0.7)
              : context.colors.errorText,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isSynced 
            ? context.colors.successText.withOpacity(0.1)
            : context.colors.errorText.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSynced 
              ? context.colors.successText.withOpacity(0.2)
              : context.colors.errorText.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSynced ? Icons.cloud_done_rounded : Icons.sync_problem_rounded,
            size: 14,
            color: isSynced ? context.colors.successText : context.colors.errorText,
          ),
          const SizedBox(width: 6),
          Text(
            isSynced ? 'Synchronisé' : 'Hors ligne',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSynced ? context.colors.successText : context.colors.errorText,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

