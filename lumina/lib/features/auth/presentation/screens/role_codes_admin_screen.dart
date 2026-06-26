// lib/features/auth/presentation/screens/role_codes_admin_screen.dart
// Écran d'administration des codes de rôle — Clean Architecture compliant
// Accès aux données via RoleCodesAdminNotifier (Riverpod AsyncNotifier)

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptic_helper.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/role_codes_admin_provider.dart';

class RoleCodesAdminScreen extends ConsumerStatefulWidget {
  const RoleCodesAdminScreen({super.key});

  @override
  ConsumerState<RoleCodesAdminScreen> createState() =>
      _RoleCodesAdminScreenState();
}

class _RoleCodesAdminScreenState extends ConsumerState<RoleCodesAdminScreen> {
  String _searchQuery = '';

  List<RoleCodeEntry> _filterCodes(List<RoleCodeEntry> codes) {
    if (_searchQuery.isEmpty) return codes;
    final query = _searchQuery.toLowerCase();
    return codes.where((c) => c.roleCode.toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final codesAsync = ref.watch(roleCodesAdminNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Codes'),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: context.colors.brandGradient),
        ),
      ),
      body: Column(
        children: [
          _buildSearchHeader(),
          Expanded(
            child: codesAsync.when(
              loading: () => Center(child: LoadingState()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline,
                          color: context.colors.errorText, size: LuminaIcon.xxl),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        'Impossible de charger les codes',
                        style: AppTypography.titleSmall
                            .copyWith(color: context.colors.errorText),
                      ),
                      SizedBox(height: AppSpacing.md),
                      ElevatedButton.icon(
                        onPressed: () => ref
                            .invalidate(roleCodesAdminNotifierProvider),
                        icon: Icon(Icons.refresh),
                        label: Text('Réessayer'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (codes) {
                final filtered = _filterCodes(codes);
                return _buildCodesList(filtered);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: 'Rechercher un rôle...',
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: context.colors.bgSecondary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCodesList(List<RoleCodeEntry> codes) {
    if (codes.isEmpty) {
      return Center(child: Text('Aucun code trouvé'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: codes.length,
      itemBuilder: (context, index) {
        final code = codes[index];
        return AnimatedEntrance.fromRight(
          delay: Duration(milliseconds: index * 50),
          child: _buildCodeCard(code),
        );
      },
    );
  }

  Widget _buildCodeCard(RoleCodeEntry data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: GlassCard(
        child: ListTile(
          title: Text(
            data.roleCode.replaceAll('_', ' ').toUpperCase(),
            style:
                AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    data.rawCode,
                    style: TextStyle(
                      fontFamily: LuminaFont.body,
                      color:
                          data.isUsed ? context.colors.textDisabled : context.colors.brandPrimary,
                      fontWeight: FontWeight.bold,
                      decoration:
                          data.isUsed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Spacer(),
                  if (!data.isUsed)
                    IconButton(
                      icon: Icon(Icons.copy, size: 18),
                      onPressed: () => _copyToClipboard(data.rawCode),
                    ),
                ],
              ),
              if (data.isUsed)
                Text(
                  'DÉJÀ UTILISÉ',
                  style: TextStyle(
                      color: context.colors.errorText,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
            ],
          ),
          trailing: Icon(
            data.isUsed ? Icons.check_circle : Icons.pending_outlined,
            color: data.isUsed ? context.colors.successIcon : context.colors.warningIcon,
          ),
        ),
      ),
    );
  }

  void _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    await HapticHelper.success();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Code copié !'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
