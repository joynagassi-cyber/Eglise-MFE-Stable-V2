import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../providers/bilan_providers.dart';

class BilanOilModeBanner extends ConsumerWidget {
  const BilanOilModeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOilMode = ref.watch(bilanOilModeProvider);
    
    if (!isOilMode) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: context.colors.warningText.withOpacity(0.9),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.visibility_off, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            'Mode Onction activé : Les noms des donateurs sont masqués',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
