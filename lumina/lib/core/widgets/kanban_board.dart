import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/widgets/glass_card.dart';

class KanbanColumn extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color? accentColor;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.children,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: context.colors.bgElevated.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: context.colors.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (accentColor != null)
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                if (accentColor != null) const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: context.colors.bgCard,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    children.length.toString(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: context.colors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class KanbanCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final String? priority;
  final String? dueDate;
  final String? assigneeAvatar;
  final Widget? trailing;
  final VoidCallback? onTap;

  const KanbanCard({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.priority,
    this.dueDate,
    this.assigneeAvatar,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.colors.textTertiary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (description != null && description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (priority != null || dueDate != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (priority != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(context, priority!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        priority!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.colors.textOnBrand,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  if (priority != null && dueDate != null)
                    const SizedBox(width: 8),
                  if (dueDate != null)
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 12, color: context.colors.textTertiary),
                        const SizedBox(width: 4),
                        Text(
                          dueDate!,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: context.colors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(BuildContext context, String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'haute':
        return context.colors.errorText;
      case 'medium':
      case 'moyenne':
        return context.colors.warningIcon; // warningIcon often used for yellow/amber
      case 'low':
      case 'basse':
        return context.colors.successIcon;
      default:
        return context.colors.brandPrimary;
    }
  }
}
