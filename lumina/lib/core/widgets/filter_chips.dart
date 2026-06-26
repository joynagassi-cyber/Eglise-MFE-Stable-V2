// lib/core/widgets/filter_chips.dart
// Chips de filtrage réutilisables

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';

/// Chip de filtre avec gradient
class FilterChipButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? icon;
  final int? count;

  const FilterChipButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? context.colors.brandPrimaryGradient : null,
          color: isSelected
              ? null
              : (isDark ? context.colors.bgCard : context.colors.bgCardLight),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(
                  color: context.colors.borderSubtle,
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Text(
                icon!,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : null,
                ),
              ),
              SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : context.colors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
            if (count != null) ...[
              SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withValues(alpha: 0.2)
                      : context.colors.brandPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : context.colors.brandPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Groupe de chips de filtre horizontaux
class FilterChipsRow extends StatelessWidget {
  final List<String> labels;
  final List<String>? icons;
  final List<int>? counts;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final EdgeInsetsGeometry? padding;

  const FilterChipsRow({
    super.key,
    required this.labels,
    this.icons,
    this.counts,
    required this.selectedIndex,
    required this.onSelected,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(labels.length, (index) {
          return Padding(
            padding: EdgeInsets.only(right: index < labels.length - 1 ? 8 : 0),
            child: FilterChipButton(
              label: labels[index],
              icon:
                  icons != null && index < icons!.length ? icons![index] : null,
              count: counts != null && index < counts!.length
                  ? counts![index]
                  : null,
              isSelected: index == selectedIndex,
              onTap: () => onSelected(index),
            ),
          );
        }),
      ),
    );
  }
}
