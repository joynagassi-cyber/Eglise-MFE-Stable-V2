import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/member_view_mode_provider.dart';

class MemberViewSwitchButton extends ConsumerWidget {
  const MemberViewSwitchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMemberViewMode = ref.watch(memberViewModeProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: isMemberViewMode 
          ? context.colors.brandPrimary.withOpacity(0.1) 
          : context.colors.textInverse.withOpacity(0.1),
        borderRadius: BorderRadius.circular(LuminaRadius.xl),
        border: Border.all(
          color: isMemberViewMode ? context.colors.brandPrimary : Colors.transparent,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(LuminaRadius.xl),
          onTap: () {
            ref.read(memberViewModeProvider.notifier).state = !isMemberViewMode;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isMemberViewMode ? Icons.person : Icons.admin_panel_settings,
                  size: 16,
                  color: isMemberViewMode ? context.colors.brandPrimary : null,
                ),
                SizedBox(width: 8),
                Text(
                  isMemberViewMode ? 'Vue Membre' : 'Vue Pro',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isMemberViewMode ? context.colors.brandPrimary : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
