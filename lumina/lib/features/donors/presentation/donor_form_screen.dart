import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/donor_providers.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';
import '../data/models/donor_models.dart';
import '../../../core/providers/auth_provider.dart';
import 'package:lumina/core/theme/app_spacing.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class DonorFormScreen extends ConsumerStatefulWidget {
  final String? donorId;
  const DonorFormScreen({this.donorId, super.key});

  @override
  ConsumerState<DonorFormScreen> createState() => _DonorFormScreenState();
}

class _DonorFormScreenState extends ConsumerState<DonorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _orgNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _wantsReceipt = true;

  @override
  void initState() {
    super.initState();
    _type = 'individual';
  }

  bool _isDataLoaded = false;

  void _loadDonorData(Donor donor) {
    if (_isDataLoaded) return;
    _isDataLoaded = true;

    // Utiliser microtask pour éviter les erreurs setState pendant le build
    Future.microtask(() {
      if (!mounted) return;
      setState(() {
        _type = donor.type;
        _firstNameController.text = donor.firstName ?? '';
        _lastNameController.text = donor.lastName ?? '';
        _orgNameController.text = donor.organizationName ?? '';
        _emailController.text = donor.email ?? '';
        _phoneController.text = donor.phone ?? '';
        _addressController.text = donor.address ?? '';
        _wantsReceipt = donor.wantsReceipt;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.donorId != null) {
      ref.listen<AsyncValue<Donor?>>(donorProvider(widget.donorId!),
          (prev, next) {
        next.whenData((donor) {
          if (donor != null) _loadDonorData(donor);
        });
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.donorId == null ? 'Nouveau Donateur' : 'Modifier Donateur',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(labelText: 'Type de Donateur'),
              items: const [
                DropdownMenuItem(
                  value: 'individual',
                  child: Text('Individuel'),
                ),
                DropdownMenuItem(
                  value: 'organization',
                  child: Text('Organisation'),
                ),
                DropdownMenuItem(value: 'anonymous', child: Text('Anonyme')),
              ],
              onChanged: (val) => setState(() => _type = val!),
            ),
            if (_type == 'organization') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _orgNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom de l'
                      'Organisation',
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Champ requis' : null,
              ),
            ],
            if (_type == 'individual') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: 'Prénom'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Nom'),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Champ requis' : null,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Téléphone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Adresse'),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Désire un reçu fiscal'),
              value: _wantsReceipt,
              onChanged: (val) => setState(() => _wantsReceipt = val),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.brandPrimary,
                foregroundColor: context.colors.textOnBrand,
              ),
              onPressed: _save,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final donor = Donor(
      id: widget.donorId ?? '',
      type: _type,
      firstName: _type == 'individual' ? _firstNameController.text : null,
      lastName: _type == 'individual' ? _lastNameController.text : null,
      organizationName:
          _type == 'organization' ? _orgNameController.text : null,
      displayName: _type == 'organization'
          ? _orgNameController.text
          : '${_firstNameController.text} ${_lastNameController.text}'.trim(),
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      wantsReceipt: _wantsReceipt,
    );

    try {
      final churchId = ref.read(activeChurchIdProvider);
      await ref.read(donorRepositoryProvider).saveDonor(donor, churchId);
      if (mounted) {
        context.pop();
        ref.invalidate(donorsProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: const Text('Impossible d\'enregistrer le donateur'),
            backgroundColor: context.colors.errorText,
          ),
        );
      }
    }
  }
}
