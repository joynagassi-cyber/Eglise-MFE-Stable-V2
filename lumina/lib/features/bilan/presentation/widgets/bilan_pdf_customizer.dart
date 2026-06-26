import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';

import '../../../../core/services/pdf_export_service.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
class BilanPdfCustomizer extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(PdfExportOptions) onConfirm;

  const BilanPdfCustomizer({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  State<BilanPdfCustomizer> createState() => _BilanPdfCustomizerState();
}

class _BilanPdfCustomizerState extends State<BilanPdfCustomizer> {
  late TextEditingController _titleController;
  bool _showKpis = true;
  bool _showBreakdown = true;
  bool _showFooter = true;
  bool _showLogo = true;
  String? _selectedColor;

  final List<Map<String, dynamic>> _colorOptions = [
    {'name': 'Défaut', 'color': null},
    {'name': 'Élégant Bleu', 'color': '#1A237E'},
    {'name': 'Naturel Vert', 'color': '#1B5E20'},
    {'name': 'Chaleureux Orange', 'color': '#E65100'},
    {'name': 'Royal Pourpre', 'color': '#4A148C'},
    {'name': 'Gris Sombre', 'color': '#212121'},
  ];

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: 'Rapport de Bilan Financier');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: GlassCard(
        margin: const EdgeInsets.all(AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune_rounded, color: context.colors.brandPrimary),
                SizedBox(width: AppSpacing.sm),
                Text(
                  'Personnaliser le Rapport',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre du Rapport',
                prefixIcon: Icon(Icons.title_rounded),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text('Couleur de l\'en-tête',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _colorOptions.length,
                separatorBuilder: (context, index) => SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final option = _colorOptions[index];
                  final hex = option['color'] as String?;
                  final isSelected = _selectedColor == hex;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = hex),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: hex != null
                            ? Color(int.parse(hex.substring(1), radix: 16) |
                                0xFF000000)
                            : Colors.grey.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: context.colors.brandPrimary, width: 3)
                            : null,
                      ),
                      child: hex == null
                          ? Icon(Icons.palette_outlined, size: 20)
                          : isSelected
                              ? Icon(Icons.check,
                                  color: Colors.white, size: 20)
                              : null,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            SwitchListTile.adaptive(
              title: Text('Afficher les KPIs'),
              subtitle:
                  Text('Résumé financier (Revenus, Dépenses, Solde)'),
              value: _showKpis,
              onChanged: (v) => setState(() => _showKpis = v),
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile.adaptive(
              title: Text('Afficher la répartition'),
              subtitle: Text('Tableau détaillé par catégories'),
              value: _showBreakdown,
              onChanged: (v) => setState(() => _showBreakdown = v),
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile.adaptive(
              title: Text('Afficher le logo'),
              value: _showLogo,
              onChanged: (v) => setState(() => _showLogo = v),
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile.adaptive(
              title: Text('Afficher le pied de page'),
              value: _showFooter,
              onChanged: (v) => setState(() => _showFooter = v),
              contentPadding: EdgeInsets.zero,
            ),
            SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    child: Text('Annuler'),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final options = PdfExportOptions(
                        title: _titleController.text,
                        showKpis: _showKpis,
                        showBreakdown: _showBreakdown,
                        showFooter: _showFooter,
                        showLogo: _showLogo,
                        customColor: _selectedColor,
                      );
                      widget.onConfirm(options);
                    },
                    icon: Icon(Icons.picture_as_pdf_rounded),
                    label: Text('Exporter'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
