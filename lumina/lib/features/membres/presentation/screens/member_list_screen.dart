import "package:lumina/core/widgets/widgets.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import 'package:lumina/features/membres/presentation/providers/member_list_provider.dart';
import 'package:lumina/features/membres/presentation/widgets/member_card.dart';
import 'package:lumina/core/router/app_routes.dart';

class MemberListScreen extends ConsumerStatefulWidget {
  const MemberListScreen({super.key});

  @override
  ConsumerState<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends ConsumerState<MemberListScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFilter = ref.watch(memberFilterProvider);
    final paginationState = ref.watch(paginatedMembersProvider);
    final filteredMembers = ref.watch(filteredMembersProvider);

    return LuminaPage(
      title: _isSearching ? null : "Annuaire des Brebis",
      onRefresh: () => ref.read(paginatedMembersProvider.notifier).refresh(),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                ref.read(memberSearchProvider.notifier).state = '';
              }
            });
          },
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.brebisNouveau),
        label: const Text("Nouveau"),
        icon: const Icon(Icons.person_add),
        backgroundColor: LuminaDesign.primary,
      ),
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.all(LuminaDesign.paddingMd),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Rechercher par nom, ville, rôle...",
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) => ref.read(memberSearchProvider.notifier).state = v,
              ),
            ),
          
          _buildFilterPills(ref, currentFilter),
          
          Expanded(
            child: paginationState.members.isEmpty && paginationState.isLoading
              ? const LoadingState()
              : ListView.builder(
                  padding: const EdgeInsets.all(LuminaDesign.paddingMd),
                  itemCount: filteredMembers.length,
                  itemBuilder: (ctx, i) => MemberCard(member: filteredMembers[i]),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPills(WidgetRef ref, MemberFilter current) {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: LuminaDesign.paddingMd),
        children: MemberFilter.values.map((f) {
          final selected = f == current;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(f.label),
              selected: selected,
              onSelected: (_) => ref.read(memberFilterProvider.notifier).state = f,
              selectedColor: LuminaDesign.primary.withOpacity(0.2),
            ),
          );
        }).toList(),
      ),
    );
  }
}
