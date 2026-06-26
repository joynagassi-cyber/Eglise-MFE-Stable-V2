// lib/core/widgets/app_text_field.dart
// Champ de texte standardisé accessible

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/services.dart';
import 'package:lumina/core/theme/app_spacing.dart';
/// Champ de texte accessible avec styling uniforme
class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.autovalidateMode,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _isObscured = widget.obscureText;
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: hasError
                      ? context.colors.errorText
                      : _isFocused
                          ? context.colors.brandPrimary
                          : context.colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
        ],

        // Text Field avec animation de focus
        AnimatedContainer(
          duration: AppSpacing.animationFast,
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: AppSpacing.borderRadiusLg,
            boxShadow: _isFocused && !hasError
                ? [
                    BoxShadow(
                      color: context.colors.brandPrimary.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText && _isObscured,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            inputFormatters: widget.inputFormatters,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            onTap: widget.onTap,
            autovalidateMode: widget.autovalidateMode,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: context.colors.textPrimary,
                ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: context.colors.textTertiary,
                  ),
              errorText: widget.errorText,
              helperText: widget.helperText,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused
                          ? context.colors.brandPrimary
                          : context.colors.iconSecondary,
                    )
                  : null,
              suffixIcon: _buildSuffix(),
              filled: true,
              fillColor: _isFocused
                  ? context.colors.bgCard
                  : context.colors.bgSecondary,
              contentPadding: AppSpacing.inputPadding,
              border: OutlineInputBorder(
                borderRadius: AppSpacing.borderRadiusLg,
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppSpacing.borderRadiusLg,
                borderSide: BorderSide(
                  color: context.colors.borderSubtle,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppSpacing.borderRadiusLg,
                borderSide: BorderSide(
                  color: context.colors.brandPrimary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: AppSpacing.borderRadiusLg,
                borderSide: BorderSide(
                  color: context.colors.errorBorder,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: AppSpacing.borderRadiusLg,
                borderSide: BorderSide(
                  color: context.colors.errorBorder,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffix() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _isObscured
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: _isFocused
              ? context.colors.brandPrimary
              : context.colors.iconSecondary,
        ),
        onPressed: () => setState(() => _isObscured = !_isObscured),
        splashRadius: 20,
      );
    }
    return widget.suffix;
  }
}

/// Champ de recherche avec icône
class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;

  const AppSearchField({
    super.key,
    this.controller,
    this.hint = 'Rechercher...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hint: hint,
      prefixIcon: Icons.search_rounded,
      suffix: controller?.text.isNotEmpty == true
          ? IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                controller?.clear();
                onClear?.call();
              },
              splashRadius: 20,
            )
          : null,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      textInputAction: TextInputAction.search,
    );
  }
}
