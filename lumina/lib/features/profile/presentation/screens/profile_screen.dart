import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/profile_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileStateProvider);

    return LuminaPage(
      title: "Mon Profil",
      body: profileAsync.when(
        data: (profile) => profile == null 
          ? Center(child: Text("Profil non trouvé"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(LuminaDesign.paddingLg),
              child: Column(
                children: [
                  _buildHeader(context, profile),
                  SizedBox(height: 32),
                  _buildSection(context, "Informations", [
                    _InfoRow(label: "Nom", value: profile.displayName, icon: Icons.person),
                    _InfoRow(label: "Email", value: profile.email ?? "Non renseigné", icon: Icons.email),
                    _InfoRow(label: "Rôle", value: profile.roleLevel.toUpperCase(), icon: Icons.security),
                  ]),
                  SizedBox(height: 24),
                  _buildSection(context, "Sécurité", [
                    _InfoRow(label: "Onboarding", value: profile.needsOnboarding ? "À faire" : "Complété", icon: Icons.check_circle, color: profile.needsOnboarding ? Colors.orange : Colors.green),
                  ]),
                  SizedBox(height: 48),
                  LuminaButton(
                    label: "Modifier mes infos",
                    onPressed: () => context.push(AppRoutes.profileEdit),
                  ),
                ],
              ),
            ),
        loading: () => const LoadingState(),
        error: (e, _) => Center(child: Text("Erreur : $e")),
      ),
    );
  }

  Widget _buildHeader(context, BuildContext context, var profile) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: LuminaDesign.primary.withOpacity(0.1),
          child: Text(profile.initials, style: LuminaDesign.h1Of(context).copyWith(color: LuminaDesign.primary)),
        ),
        SizedBox(height: 16),
        Text(profile.displayName, style: LuminaDesign.h2Of(context)),
        Text(profile.email ?? "", style: LuminaDesign.labelOf(context)),
      ],
    );
  }

  Widget _buildSection(context, BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: LuminaDesign.labelOf(context)),
        SizedBox(height: 12),
        LuminaCard(
          padding: EdgeInsets.zero,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _InfoRow({required this.label, required this.value, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? LuminaDesign.primary, size: 20),
      title: Text(label, style: LuminaDesign.labelOf(context)),
      subtitle: Text(value, style: LuminaDesign.bodyLargeOf(context).copyWith(fontWeight: FontWeight.w600)),
    );
  }
}
