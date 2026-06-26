// lib/features/rubriques/presentation/screens/category_form_screen.dart

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../domain/entities/transaction_category.dart';
import '../../domain/entities/enums/category_type.dart';
import '../providers/category_providers.dart';

class CategoryFormScreen extends ConsumerStatefulWidget {
  final TransactionCategory? category;
  final CategoryType type;

  const CategoryFormScreen({super.key, this.category, required this.type});

  @override
  ConsumerState<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends ConsumerState<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _iconController;
  late Color _selectedColor;
  String? _parentId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name);
    _iconController = TextEditingController(text: widget.category?.iconName);
    _selectedColor = _parseColor(widget.category?.color);
    _parentId = widget.category?.parentId;
  }

  Color _parseColor(String? colorHex) {
    if (colorHex == null) return context.colors.infoText;
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return context.colors.infoText;
    }
  }

  String _toHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      await HapticHelper.warning();
      return;
    }

    await HapticHelper.medium();
    setState(() => _isLoading = true);

    try {
      final actions = ref.read(categoryActionsProvider);
      final churchId = ref.read(activeChurchIdProvider);

      final category = TransactionCategory(
        id: widget.category?.id ?? '',
        churchId: churchId,
        name: _nameController.text.trim(),
        type: widget.type,
        parentId: _parentId,
        iconName: _iconController.text.trim().isEmpty
            ? 'category'
            : _iconController.text.trim(),
        color: _toHex(_selectedColor),
        isActive: widget.category?.isActive ?? true,
        createdAt: widget.category?.createdAt,
        updatedAt: DateTime.now(),
      );

      if (widget.category == null) {
        await actions.createCategory(category);
      } else {
        await actions.updateCategory(category);
      }

      await HapticHelper.success();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.category == null
                  ? 'Catégorie créée avec succès'
                  : 'Catégorie mise à jour',
            ),
            backgroundColor: context.colors.successText,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      await HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Une erreur est survenue lors de l\'enregistrement'),
            backgroundColor: context.colors.errorText,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Semantics(
          label: 'Retour',
          button: true,
          child: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () async {
              await HapticHelper.light();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ).withTouchTarget(),
        ),
        title: Text(
          widget.category == null ? 'Nouvelle Catégorie' : 'Édition Catégorie',
          style: AppTypography.h3.copyWith(fontFamily: 'Outfit'),
        ),
      ),
      body: _isLoading
          ? Center(child: LoadingDots())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AnimatedEntrance.fromBottom(
                delay: const Duration(milliseconds: 100),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: 'Nom de la catégorie *',
                        icon: Icons.label_rounded,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Champ requis' : null,
                      ),
                      SizedBox(height: AppSpacing.md),
                      _buildTextField(
                        controller: _iconController,
                        label: 'Nom de l\'icône (ex: payments)',
                        icon: Icons.category_rounded,
                      ),
                      SizedBox(height: AppSpacing.md),
                      _buildParentSelector(),
                      SizedBox(height: AppSpacing.xl),
                      Semantics(
                        label: widget.category == null
                            ? 'Créer la catégorie'
                            : 'Enregistrer les modifications',
                        button: true,
                        enabled: !_isLoading,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.brandPrimary,
                            foregroundColor: context.colors.textOnBrand,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            widget.category == null ? 'CRÉER' : 'ENREGISTRER',
                            style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ).withTouchTarget(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: context.colors.brandPrimary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
      validator: validator,
      onTap: () => HapticHelper.light(),
    );
  }

  Widget _buildParentSelector() {
    final rootCategoriesAsync = ref.watch(rootCategoriesProvider(widget.type));

    return rootCategoriesAsync.when(
      data: (categories) {
        // Filtrer la catégorie actuelle si on est en édition
        final availableCategories = widget.category != null
            ? categories.where((c) => c.id != widget.category!.id).toList()
            : categories;

        if (availableCategories.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.colors.borderSubtle),
            ),
            child: Text(
              'Aucune catégorie parente disponible',
              style: AppTypography.bodySmall.copyWith(color: context.colors.textSecondary),
            ),
          );
        }

        return DropdownButtonFormField<String>(
          value: _parentId,
          decoration: InputDecoration(
            labelText: 'Catégorie Parente',
            prefixIcon: Icon(Icons.account_tree_outlined, color: context.colors.brandPrimary),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: AppTypography.bodyMedium.copyWith(color: context.colors.textPrimary),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('Aucune (Catégorie Racine)'),
            ),
            ...availableCategories.map(
              (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
            ),
          ],
          onChanged: (value) async {
            await HapticHelper.selection();
            if (mounted) {
              setState(() => _parentId = value);
            }
          },
        );
      },
      loading: () => Center(child: LoadingDots()),
      error: (e, _) => Text('Erreur chargement parents: $e', 
          style: TextStyle(color: context.colors.errorText)),
    );
  }
}
