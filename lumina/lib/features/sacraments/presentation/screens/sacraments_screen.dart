import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:intl/intl.dart';
import '../providers/sacrament_providers.dart';
import '../../domain/entities/sacrament.dart';
import '../../domain/entities/sacrament_type.dart';


class SacramentsScreen extends ConsumerStatefulWidget {
  const SacramentsScreen({super.key});

  @override
  ConsumerState<SacramentsScreen> createState() => _SacramentsScreenState();
}

class _SacramentsScreenState extends ConsumerState<SacramentsScreen> {
  String _searchQuery = '';
  SacramentType? _selectedType;

  @override
  Widget build(BuildContext context) {
    final sacramentsAsync = _selectedType != null
        ? ref.watch(sacramentsByTypeProvider(_selectedType!))
        : _searchQuery.isNotEmpty
            ? ref.watch(sacramentSearchProvider(_searchQuery))
            : ref.watch(sacramentsProvider);

    return LuminaPage(
      title: "Sacrements",
      onRefresh: () async => ref.invalidate(sacramentsProvider),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSacrament(context),
        label: const Text("Nouveau"),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: LuminaDesign.primary,
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: sacramentsAsync.when(
              data: (list) {
                if (list.isEmpty) return const Center(child: Text("Aucun sacrement trouvé."));
                return ListView.builder(
                  padding: const EdgeInsets.all(LuminaDesign.paddingMd),
                  itemCount: list.length,
                  itemBuilder: (ctx, i) => _SacramentCard(sacrament: list[i]),
                );
              },
              loading: () => const LoadingState(),
              error: (e, _) => Center(child: Text("Erreur : $e")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.all(LuminaDesign.paddingMd),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: "Rechercher un membre...",
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(label: "Tous", isSelected: _selectedType == null, onTap: () => setState(() => _selectedType = null)),
                ...SacramentTypeX.allTypes.map((t) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _FilterChip(label: t.label, isSelected: _selectedType == t, onTap: () => setState(() => _selectedType = t)),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSacrament(BuildContext context) {
    showDialog(context: context, builder: (ctx) => const AddSacramentDialog());
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: LuminaDesign.primary.withOpacity(0.2),
    );
  }
}

class _SacramentCard extends StatelessWidget {
  final Sacrament sacrament;
  const _SacramentCard({required this.sacrament});

  @override
  Widget build(BuildContext context) {
    return LuminaCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: LuminaDesign.primary.withOpacity(0.1),
            child: Text(sacrament.type.icon),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sacrament.type.label, style: LuminaDesign.bodyLargeOf(context).copyWith(fontWeight: FontWeight.bold)),
                Text("${sacrament.memberFirstName} ${sacrament.memberLastName}", style: LuminaDesign.labelOf(context)),
              ],
            ),
          ),
          Text(DateFormat('dd/MM/yyyy').format(sacrament.date), style: LuminaDesign.labelOf(context)),
        ],
      ),
    );
  }
}

// FIX pour le nom du widget importé qui semble différer
class AddSacramentDialog extends StatelessWidget {
  const AddSacramentDialog({super.key});
  @override
  Widget build(BuildContext context) => const AddSacramentDialog();
}
