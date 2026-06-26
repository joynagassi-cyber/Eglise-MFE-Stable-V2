/// Admin Settings Screen for BILAN configuration
library;

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../bilan/presentation/providers/bilan_providers.dart';

class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  ConsumerState<AdminSettingsScreen> createState() =>
      _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {
  final _nameController = TextEditingController();
  final _logoUrlController = TextEditingController();
  int _fontSize = 18;
  String _fontWeight = 'bold';
  Color _nameColor = Colors.black;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadBranding();
  }

  BilanFinancialSettings? _financialSettings;

  Future<void> _loadBranding() async {
    final branding = await ref.read(churchBrandingProvider.future);
    final finSettings = await ref.read(financialSettingsProvider.future);
    setState(() {
      _nameController.text = branding.name;
      _logoUrlController.text = branding.logoUrl ?? '';
      _fontSize = branding.fontSize;
      _fontWeight = branding.fontWeight;
      _nameColor = _parseColor(branding.color);
      _financialSettings = finSettings;
      _isLoading = false;
    });
  }

  Color _parseColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  Future<void> _saveAll() async {
    setState(() => _isSaving = true);

    try {
      final repo = ref.read(bilanRepositoryProvider);

      // Save Branding
      await repo.updateChurchBranding(ChurchBranding(
        name: _nameController.text,
        logoUrl:
            _logoUrlController.text.isEmpty ? null : _logoUrlController.text,
        fontSize: _fontSize,
        fontWeight: _fontWeight,
        color: _colorToHex(_nameColor),
      ));

      // Save Financial Settings
      if (_financialSettings != null) {
        await repo.updateFinancialSettings(_financialSettings!);
      }

      ref.invalidate(churchBrandingProvider);
      ref.invalidate(financialSettingsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Configuration sauvegardée')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible de sauvegarder les paramètres')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _logoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Paramètres Admin')),
        body: Center(child: LoadingState()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres Admin'),
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _saveAll,
            icon: _isSaving
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: LoadingDots(size: 24),
                  )
                : Icon(Icons.save),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Church Identity Section
          Text('Identité de l\'Église', style: theme.textTheme.titleMedium),
          SizedBox(height: 16),

          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nom de l\'église',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),

          TextField(
            controller: _logoUrlController,
            decoration: const InputDecoration(
              labelText: 'URL du logo (optionnel)',
              border: OutlineInputBorder(),
              hintText: 'https://...',
            ),
          ),
          SizedBox(height: 24),

          // Name Style Section
          Text('Style du nom (PDF)', style: theme.textTheme.titleMedium),
          SizedBox(height: 16),

          // Font size slider
          Row(
            children: [
              Text('Taille:'),
              Expanded(
                child: Slider(
                  value: _fontSize.toDouble(),
                  min: 12,
                  max: 32,
                  divisions: 10,
                  label: '$_fontSize',
                  onChanged: (value) =>
                      setState(() => _fontSize = value.toInt()),
                ),
              ),
              Text('$_fontSize px'),
            ],
          ),

          // Font weight dropdown
          DropdownButtonFormField<String>(
            value: _fontWeight,
            decoration: const InputDecoration(
              labelText: 'Épaisseur',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'normal', child: Text('Normal')),
              DropdownMenuItem(value: 'bold', child: Text('Gras')),
            ],
            onChanged: (value) => setState(() => _fontWeight = value ?? 'bold'),
          ),
          SizedBox(height: 16),

          // Color picker (simple)
          ListTile(
            title: Text('Couleur du nom'),
            trailing: GestureDetector(
              onTap: _showColorPicker,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _nameColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
              ),
            ),
          ),
          SizedBox(height: 32),

          // Financial Settings Section
          Text('Paramètres Experts (BILAN)',
              style: theme.textTheme.titleMedium),
          SizedBox(height: 16),

          if (_financialSettings != null) ...[
            // Sigma threshold
            Row(
              children: [
                Text('Seuil anomalies (σ):'),
                Expanded(
                  child: Slider(
                    value: _financialSettings!.anomalySigmaThreshold,
                    min: 1.0,
                    max: 5.0,
                    divisions: 40,
                    label: _financialSettings!.anomalySigmaThreshold
                        .toStringAsFixed(1),
                    onChanged: (value) => setState(() {
                      _financialSettings = _financialSettings!
                          .copyWith(anomalySigmaThreshold: value);
                    }),
                  ),
                ),
                Text(
                    '${_financialSettings!.anomalySigmaThreshold.toStringAsFixed(1)} σ'),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Un multiplicateur d\'écart-type plus élevé réduit le nombre d\'alerte d\'anomalies.',
              style: theme.textTheme.bodySmall,
            ),

            SizedBox(height: 16),

            SwitchListTile(
              title: Text('Consolidation automatique'),
              subtitle: Text(
                  'Éliminer les transferts internes dans le total Église'),
              value: _financialSettings!.eliminateInternalTransfers,
              onChanged: (value) => setState(() {
                _financialSettings = _financialSettings!
                    .copyWith(eliminateInternalTransfers: value);
              }),
            ),
          ],
          SizedBox(height: 32),

          // Preview Section
          Text('Aperçu', style: theme.textTheme.titleMedium),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    _nameController.text,
                    style: TextStyle(
                      fontSize: _fontSize.toDouble(),
                      fontWeight: _fontWeight == 'bold'
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _nameColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'BILAN FINANCIER',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPicker() {
    final colors = [
      Colors.black,
      context.colors.infoText,
      context.colors.brandPrimary,
      context.colors.successText,
      context.colors.errorText,
      context.colors.brandSecondary,
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () {
                setState(() => _nameColor = color);
                Navigator.pop(context);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _nameColor == color ? Colors.blue : Colors.grey,
                    width: _nameColor == color ? 3 : 1,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
