import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transaction_category.dart';
import '../providers/category_providers.dart';

/// Widget pour afficher une catégorie avec sa hiérarchie (arbre)
///
/// Affiche la catégorie et ses enfants de manière récursive avec indentation
class CategoryTreeWidget extends ConsumerStatefulWidget {
  final TransactionCategory category;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final int level; // Niveau d'indentation

  const CategoryTreeWidget({
    super.key,
    required this.category,
    this.onTap,
    this.onDelete,
    this.level = 0,
  });

  @override
  ConsumerState<CategoryTreeWidget> createState() => _CategoryTreeWidgetState();
}

class _CategoryTreeWidgetState extends ConsumerState<CategoryTreeWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final childrenAsync = ref.watch(
      childCategoriesProvider(widget.category.id),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Catégorie actuelle
        Padding(
          padding: EdgeInsets.only(left: widget.level * 24.0),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Icône expand/collapse si a des enfants
                    childrenAsync.when(
                      data: (children) => children.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                _isExpanded
                                    ? Icons.expand_more
                                    : Icons.chevron_right,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            )
                          : const SizedBox(width: 20),
                      loading: () => const SizedBox(width: 20),
                      error: (_, __) => const SizedBox(width: 20),
                    ),
                    const SizedBox(width: 8),

                    // Icône catégorie
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _hexToColor(
                          widget.category.color,
                        ).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getIconData(widget.category.iconName),
                        color: _hexToColor(widget.category.color),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Nom et détails
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (!widget.category.isBudgetable)
                            Text(
                              'Non budgétable',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Badge type
                    Chip(
                      label: Icon(
                        widget.category.type.value == 'income'
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 16,
                        color: widget.category.type.value == 'income'
                            ? context.colors.successText
                            : context.colors.errorText,
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),

                    // Menu actions
                    if (widget.onDelete != null)
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'delete') {
                            widget.onDelete?.call();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: context.colors.errorText),
                                const SizedBox(width: 8),
                                const Text('Supprimer'),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Enfants (récursif)
        if (_isExpanded)
          childrenAsync.when(
            data: (children) {
              if (children.isEmpty) return const SizedBox.shrink();

              return Column(
                children: children.map((child) {
                  return CategoryTreeWidget(
                    category: child,
                    onTap: widget.onTap,
                    onDelete: widget.onDelete,
                    level: widget.level + 1,
                  );
                }).toList(),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
      ],
    );
  }

  Color _hexToColor(String hex) {
    try {
      final hexCode = hex.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  IconData _getIconData(String iconName) {
    // Mapping des noms d'icônes Material les plus courants
    const iconMap = {
      'payments': Icons.payments,
      'volunteer_activism': Icons.volunteer_activism,
      'church': Icons.church,
      'redeem': Icons.redeem,
      'construction': Icons.construction,
      'event': Icons.event,
      'badge': Icons.badge,
      'home_repair_service': Icons.home_repair_service,
      'groups_2': Icons.groups_2,
      'favorite': Icons.favorite,
      'perm_media': Icons.perm_media,
      'business_center': Icons.business_center,
      'public': Icons.public,
      'category': Icons.category,
      'attach_money': Icons.attach_money,
      'shopping_cart': Icons.shopping_cart,
    };

    return iconMap[iconName] ?? Icons.category;
  }
}
