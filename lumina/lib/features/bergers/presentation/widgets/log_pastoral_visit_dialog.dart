import "package:lumina/core/widgets/widgets.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:lumina/features/churches/presentation/providers/church_providers.dart';
import '../../../membres/domain/entities/member.dart';
import '../../../membres/presentation/providers/member_list_provider.dart';
import '../../domain/entities/shepherd.dart';
import '../../domain/entities/pastoral_visit.dart';
import '../providers/shepherd_providers.dart';
import '../../../../core/widgets/loading_state.dart';

class LogPastoralVisitDialog extends ConsumerStatefulWidget {
  final Shepherd shepherd;

  const LogPastoralVisitDialog({super.key, required this.shepherd});

  @override
  ConsumerState<LogPastoralVisitDialog> createState() =>
      _LogPastoralVisitDialogState();
}

class _LogPastoralVisitDialogState
    extends ConsumerState<LogPastoralVisitDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  DateTime _visitDate = DateTime.now();
  DateTime? _nextVisitDate;
  Member? _selectedMember;
  String _status = 'NORMAL';

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedMember == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs obligatoires'),
        ),
      );
      return;
    }

    final activeChurch = await ref.read(activeChurchProvider.future);
    if (activeChurch == null) return;

    final visit = PastoralVisit(
      id: const Uuid().v4(),
      churchId: activeChurch.id,
      shepherdId: widget.shepherd.id,
      memberId: _selectedMember!.id,
      date: _visitDate,
      notes: _notesController.text,
      status: _status,
      nextVisitDate: _nextVisitDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await ref.read(shepherdControllerProvider.notifier).logVisit(visit);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Une erreur est survenue lors de l\'enregistrement')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Loger une visite pastorale'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMemberPicker(),
              const SizedBox(height: 16),
              _buildDatePicker(
                'Date de la visite',
                _visitDate,
                (date) => setState(() => _visitDate = date),
              ),
              const SizedBox(height: 16),
              _buildStatusPicker(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes / Résumé de l\'entretien',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              _buildDatePicker(
                'Prochaine visite suggérée (facultatif)',
                _nextVisitDate,
                (date) => setState(() => _nextVisitDate = date),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Enregistrer')),
      ],
    );
  }

  Widget _buildMemberPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Membre visité',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showMemberPicker,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_search),
                const SizedBox(width: 8),
                Text(_selectedMember?.fullName ?? 'Sélectionner un membre'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showMemberPicker() {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final membersAsync = ref.watch(memberListProvider);
          return AlertDialog(
            title: const Text('Choisir un membre'),
            content: SizedBox(
              width: double.maxFinite,
              child: membersAsync.when(
                data: (members) => ListView.builder(
                  shrinkWrap: true,
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return ListTile(
                      title: Text(member.fullName),
                      onTap: () {
                        setState(() => _selectedMember = member);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
                loading: () => const Center(child: LoadingState()),
                error: (err, _) => const Text('Impossible de charger les membres'),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime? selectedDate,
    Function(DateTime) onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              locale: const Locale('fr', 'FR'),
              helpText: 'Sélectionner la date',
              cancelText: 'Annuler',
              confirmText: 'Confirmer',
            );
            if (date != null) onSelected(date);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 8),
                Text(
                  selectedDate == null
                      ? 'Non défini'
                      : DateFormat('dd/MM/yyyy').format(selectedDate),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusPicker() {
    return DropdownButtonFormField<String>(
      value: _status,
      decoration: const InputDecoration(
        labelText: 'Status de la visite',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'NORMAL', child: Text('Normal')),
        DropdownMenuItem(value: 'URGENT', child: Text('Urgent (Aide requise)')),
        DropdownMenuItem(value: 'SUIVI', child: Text('Suivi nécessaire')),
      ],
      onChanged: (v) => setState(() => _status = v!),
    );
  }
}