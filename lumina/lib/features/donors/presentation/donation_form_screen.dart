import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/donor_providers.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';
import '../data/models/donor_models.dart';
import '../../../core/providers/auth_provider.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/theme/app_spacing.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class DonationFormScreen extends ConsumerStatefulWidget {
  final String? donorId;
  const DonationFormScreen({this.donorId, super.key});

  @override
  ConsumerState<DonationFormScreen> createState() => _DonationFormScreenState();
}

class _DonationFormScreenState extends ConsumerState<DonationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDonorId;
  String? _selectedCampaignId;
  late String _donationType;
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _donationDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDonorId = widget.donorId;
    _donationType = 'tithe';
  }

  @override
  Widget build(BuildContext context) {
    final donorsAsync = ref.watch(donorsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Enregistrer un Don')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            donorsAsync.when(
              data: (donors) => DropdownButtonFormField<String>(
                value: _selectedDonorId,
                decoration: const InputDecoration(labelText: 'Donateur'),
                items: donors
                    .map(
                      (d) => DropdownMenuItem(
                        value: d.id,
                        child: Text(d.displayName),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedDonorId = val),
                validator: (val) => val == null ? 'Champ requis' : null,
              ),
              loading: () => const AppProgressBar(),
              error: (_, __) => Text('Erreur chargement donateurs'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _donationType,
              decoration: const InputDecoration(labelText: 'Type de Don'),
              items: const [
                DropdownMenuItem(value: 'tithe', child: Text('Dîme')),
                DropdownMenuItem(value: 'offering', child: Text('Offrande')),
                DropdownMenuItem(
                  value: 'special_offering',
                  child: Text('Offrande Spéciale'),
                ),
                DropdownMenuItem(
                  value: 'thanksgiving',
                  child: Text('Action de Grâce'),
                ),
                DropdownMenuItem(
                  value: 'project',
                  child: Text('Projet/Bâtiment'),
                ),
                DropdownMenuItem(value: 'mission', child: Text('Mission')),
              ],
              onChanged: (val) => setState(() => _donationType = val!),
            ),
            SizedBox(height: 16),
            ref.watch(donationCampaignsProvider).when(
                  data: (campaigns) => campaigns.isEmpty
                      ? const SizedBox.shrink()
                      : DropdownButtonFormField<String>(
                          value: _selectedCampaignId,
                          decoration: const InputDecoration(
                            labelText: 'Campagne spécialisée',
                            helperText: 'Optionnel',
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('Aucune'),
                            ),
                            ...campaigns.map(
                              (c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(c.title),
                              ),
                            ),
                          ],
                          onChanged: (val) =>
                              setState(() => _selectedCampaignId = val),
                        ),
                  loading: () => const AppProgressBar(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
            SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Montant (FCFA)',
                prefixIcon: Icon(Icons.monetization_on),
              ),
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Champ requis';
                if (double.tryParse(val) == null) return 'Montant invalide';
                return null;
              },
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Date du Don'),
              subtitle: Text(
                '${_donationDate.day}/${_donationDate.month}/${_donationDate.year}',
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes / Particularités',
              ),
              maxLines: 2,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.brandPrimary,
                foregroundColor: context.colors.textOnBrand,
              ),
              onPressed: _save,
              child: Text('Confirmer le Don'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _donationDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('fr', 'FR'),
      helpText: 'Sélectionner la date du don',
      cancelText: 'Annuler',
      confirmText: 'Confirmer',
    );
    if (picked != null) setState(() => _donationDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final donation = Donation(
      id: '',
      donorId: _selectedDonorId!,
      campaignId: _selectedCampaignId,
      amount: double.parse(_amountController.text),
      donationType: _donationType,
      donationDate: _donationDate,
      notes: _notesController.text,
    );

    try {
      final churchId = ref.read(activeChurchIdProvider);
      await ref.read(donorRepositoryProvider).saveDonation(donation, churchId);
      if (mounted) {
        context.pop();
        ref.invalidate(donorDonationsProvider(_selectedDonorId!));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Don enregistré avec succès'),
            backgroundColor: context.colors.successText,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text('Impossible d\'enregistrer le don'),
            backgroundColor: context.colors.errorText,
          ),
        );
      }
    }
  }
}
