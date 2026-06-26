import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/core/widgets/widgets.dart';
class MemberTransferScreen extends ConsumerStatefulWidget {
  final String groupId;

  const MemberTransferScreen({
    super.key,
    required this.groupId,
  });

  @override
  ConsumerState<MemberTransferScreen> createState() =>
      _MemberTransferScreenState();
}

class _MemberTransferScreenState extends ConsumerState<MemberTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedMemberId;
  String? _destinationGroupId;
  final _reasonController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submitTransfer() async {
    if (!_formKey.currentState!.validate() ||
        _selectedMemberId == null ||
        _destinationGroupId == null) {
      await HapticHelper.error();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await HapticHelper.selection();

    try {
      // Simulation d'envoi (le repository a déjà été mis à jour dans la phase précédente)
      await Future.delayed(const Duration(seconds: 1));

      await HapticHelper.success();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Demande de transfert envoyée avec succès.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      await HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'effectuer le transfert')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfert de Membre'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: context.colors.brandPrimaryGradient,
          ),
        ),
        foregroundColor: context.colors.textInverse,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedEntrance.fromTop(
                child: Text(
                  'Déplacer un membre vers un autre groupe.',
                  style: TextStyle(
                    fontFamily: LuminaFont.body,
                    fontSize: 16,
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Sélection du membre
              AnimatedEntrance.fromLeft(
                child: GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_outline, color: context.colors.brandPrimary, size: LuminaIcon.sm),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Membre à transférer',
                            style: TextStyle(
                              fontFamily: LuminaFont.display,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Dropdown simulé pour le moment
                      Semantics(
                        label: 'Sélectionner le membre à transférer',
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            hintText: 'Sélectionner un membre',
                            hintStyle: TextStyle(
                              fontFamily: LuminaFont.body,
                              fontSize: 14,
                              color: context.colors.textSecondary,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'm1', child: Text('Jean Dupont')),
                            DropdownMenuItem(
                                value: 'm2', child: Text('Marie Koum')),
                          ],
                          onChanged: (val) =>
                              setState(() => _selectedMemberId = val),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Destination
              AnimatedEntrance.fromRight(
                child: GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.groups_outlined,
                              color: context.colors.brandSecondary,
                              size: LuminaIcon.sm),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Groupe de destination',
                            style: TextStyle(
                              fontFamily: LuminaFont.display,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Semantics(
                        label: 'Sélectionner le groupe de destination',
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            hintText: 'Sélectionner le groupe cible',
                            hintStyle: TextStyle(
                              fontFamily: LuminaFont.body,
                              fontSize: 14,
                              color: context.colors.textSecondary,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'g2', child: Text('Groupe Canaan')),
                            DropdownMenuItem(
                                value: 'g3', child: Text('Groupe Ebenezer')),
                          ],
                          onChanged: (val) =>
                              setState(() => _destinationGroupId = val),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Motif
              AnimatedEntrance.fromBottom(
                child: GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description_outlined,
                              color: context.colors.textSecondary),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Motif du transfert',
                            style: TextStyle(
                              fontFamily: LuminaFont.display,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Expliquez brièvement la raison...',
                          hintStyle: TextStyle(
                            fontFamily: LuminaFont.body,
                            fontSize: 14,
                            color: context.colors.textSecondary,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Champ requis' : null,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl * 2),

              // Bouton Submit
              Semantics(
                label: 'Soumettre la demande de transfert',
                button: true,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitTransfer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.brandPrimary,
                      foregroundColor: context.colors.textInverse,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSubmitting
                        ? LoadingDots(color: context.colors.textInverse, size: 24)
                        : const Text(
                            'Soumettre la demande',
                            style: TextStyle(
                                fontFamily: LuminaFont.display,
                                fontSize: 18, 
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
