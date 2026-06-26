import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';

import '../../domain/entities/transaction_category.dart';

/// Widget chip pour sélection rapide d'une catégorie
///
/// Utilisé dans les formulaires de transactions pour sélectionner une catégorie
class CategoryChip extends StatelessWidget {
  final TransactionCategory category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _hexToColor(context, category.color);

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIconData(category.iconName),
            size: 16,
            color: isSelected ? Colors.white : color,
          ),
          SizedBox(width: 4),
          Text(category.name),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) => onTap?.call(),
      selectedColor: color,
      backgroundColor: color.withValues(alpha: 0.1),
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Color _hexToColor(BuildContext context, String hex) {
    try {
      final hexCode = hex.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    } catch (e) {
      return context.colors.textTertiary;
    }
  }

  IconData _getIconData(String iconName) {
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

/// Widget sélecteur de catégorie (dropdown ou dialog)
class CategorySelector extends StatelessWidget {
  final TransactionCategory? selectedCategory;
  final List<TransactionCategory> categories;
  final ValueChanged<TransactionCategory?> onChanged;
  final String? labelText;

  const CategorySelector({
    super.key,
    this.selectedCategory,
    required this.categories,
    required this.onChanged,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCategory?.id,
      decoration: InputDecoration(
        labelText: labelText ?? 'Catégorie',
        prefixIcon: Icon(Icons.category),
        border: const OutlineInputBorder(),
      ),
      items: categories.map((category) {
        return DropdownMenuItem<String>(
          value: category.id,
          child: Row(
            children: [
              Icon(
                _getIconData(category.iconName),
                size: 20,
                color: _hexToColor(context, category.color),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(category.name, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) {
          onChanged(null);
        } else {
          final category = categories.firstWhere((c) => c.id == value);
          onChanged(category);
        }
      },
    );
  }

  Color _hexToColor(BuildContext context, String hex) {
    try {
      final hexCode = hex.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    } catch (e) {
      return context.colors.textTertiary;
    }
  }

  IconData _getIconData(String iconName) {
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
