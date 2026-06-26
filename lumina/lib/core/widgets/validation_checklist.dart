import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_animations.dart';
import 'package:lumina/core/utils/haptic_helper.dart';

class ValidationChecklistItem extends StatefulWidget {
  final String label;
  final bool initialValue;
  final Function(bool) onChanged;

  const ValidationChecklistItem({
    super.key,
    required this.label,
    this.initialValue = false,
    required this.onChanged,
  });

  @override
  State<ValidationChecklistItem> createState() =>
      _ValidationChecklistItemState();
}

class _ValidationChecklistItemState extends State<ValidationChecklistItem> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  void _toggle() async {
    setState(() {
      _isChecked = !_isChecked;
    });
    await HapticHelper.medium();
    widget.onChanged(_isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: _isChecked
              ? context.colors.brandPrimary.withOpacity(0.05)
              : Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isChecked
                ? context.colors.brandPrimary.withOpacity(0.2)
                : Colors.white.withOpacity(0.05),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: AppAnimations.fast,
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isChecked
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
                gradient: _isChecked ? context.colors.fireFusionGradient : null,
              ),
              child: _isChecked
                  ? Center(
                      child: Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.label,
                style: AppTypography.bodySmallStyle.copyWith(
                  color: _isChecked
                      ? Colors.white.withOpacity(0.9)
                      : Colors.white.withOpacity(0.5),
                  decoration: _isChecked ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ValidationChecklist extends StatelessWidget {
  final String title;
  final List<String> items;
  final List<bool>? initialValues;
  final Function(int, bool) onItemChanged;

  const ValidationChecklist({
    super.key,
    required this.title,
    required this.items,
    this.initialValues,
    required this.onItemChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              title,
              style: AppTypography.titleSmall.copyWith(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ...List.generate(items.length, (index) {
          return ValidationChecklistItem(
            label: items[index],
            initialValue: initialValues != null && initialValues!.length > index
                ? initialValues![index]
                : false,
            onChanged: (value) => onItemChanged(index, value),
          );
        }),
      ],
    );
  }
}
