import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../domain/services/audit_service.dart';

class AuditFiltersBar extends ConsumerWidget {
  const AuditFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final startDate = ref.watch(auditFilterStartDateProvider);
    final endDate = ref.watch(auditFilterEndDateProvider);
    final actorId = ref.watch(auditFilterActorProvider);
    final action = ref.watch(auditFilterActionProvider);

    final hasFilters =
        startDate != null || endDate != null || actorId != null || action != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(
              Icons.filter_list_rounded,
              size: 20,
              color: isDark ? Colors.white70 : context.colors.textSecondaryLight,
            ),
            SizedBox(width: AppSpacing.sm),
            Text(
              "Filtres",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : context.colors.textSecondaryLight,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: _formatDateLabel(startDate, endDate),
                      icon: Icons.calendar_today_rounded,
                      isActive: startDate != null || endDate != null,
                      onTap: () => _selectDateRange(context, ref),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    _FilterChip(
                      label: actorId ?? 'Tous les utilisateurs',
                      icon: Icons.person_outline_rounded,
                      isActive: actorId != null,
                      onTap: () => _selectUser(context, ref),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    _FilterChip(
                      label: action ?? 'Toutes les actions',
                      icon: Icons.layers_outlined,
                      isActive: action != null,
                      onTap: () => _selectAction(context, ref),
                    ),
                  ],
                ),
              ),
            ),
            if (hasFilters) ...[
              SizedBox(width: AppSpacing.sm),
              IconButton(
                icon: Icon(Icons.close_rounded, size: 18),
                onPressed: () {
                  ref.read(auditFilterStartDateProvider.notifier).state = null;
                  ref.read(auditFilterEndDateProvider.notifier).state = null;
                  ref.read(auditFilterActorProvider.notifier).state = null;
                  ref.read(auditFilterActionProvider.notifier).state = null;
                },
                tooltip: 'Réinitialiser',
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateLabel(DateTime? start, DateTime? end) {
    if (start == null && end == null) return 'Toutes les dates';
    final df = DateFormat('dd/MM');
    if (start != null && end != null) return '${df.format(start)} - ${df.format(end)}';
    if (start != null) return 'Depuis ${df.format(start)}';
    return 'Jusqu\'au ${df.format(end!)}';
  }

  Future<void> _selectDateRange(BuildContext context, WidgetRef ref) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: ref.read(auditFilterStartDateProvider) != null
          ? DateTimeRange(
              start: ref.read(auditFilterStartDateProvider)!,
              end: ref.read(auditFilterEndDateProvider) ?? DateTime.now(),
            )
          : null,
    );

    if (picked != null) {
      ref.read(auditFilterStartDateProvider.notifier).state = picked.start;
      ref.read(auditFilterEndDateProvider.notifier).state = picked.end;
    }
  }

  Future<void> _selectUser(BuildContext context, WidgetRef ref) async {
    // Dans une version réelle, on ouvrirait un dialogue avec recherche d'utilisateurs.
    // Pour l'instant, on simule avec un simple InputDialog.
    final controller = TextEditingController(text: ref.read(auditFilterActorProvider));
    final res = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filtrer par utilisateur'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'ID de l\'utilisateur (ou Email)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Tous')),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: Text('Filtrer')),
        ],
      ),
    );
    ref.read(auditFilterActorProvider.notifier).state = (res == null || res.isEmpty) ? null : res;
  }

  Future<void> _selectAction(BuildContext context, WidgetRef ref) async {
    final actions = ['insert', 'update', 'delete', 'login', 'logout'];
    final res = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Choisir une action'),
        children: [
          SimpleDialogOption(onPressed: () => Navigator.pop(context, ''), child: Text('Toutes')),
          ...actions.map((a) => SimpleDialogOption(
            onPressed: () => Navigator.pop(context, a),
            child: Text(a),
          )),
        ],
      ),
    );
    ref.read(auditFilterActionProvider.notifier).state = (res == null || res.isEmpty) ? null : res;
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive 
              ? context.colors.brandPrimary.withOpacity(0.15)
              : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive 
                ? context.colors.brandPrimary 
                : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isActive ? context.colors.brandPrimary : (isDark ? Colors.white60 : Colors.black54)),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive 
                    ? (isDark ? Colors.white : context.colors.brandPrimary)
                    : (isDark ? Colors.white60 : context.colors.textSecondaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
