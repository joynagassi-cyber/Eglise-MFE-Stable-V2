// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../domain/services/audit_service.dart';
import '../domain/models/audit_log.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class AuditDetailScreen extends ConsumerWidget {
  final String logId;

  const AuditDetailScreen({required this.logId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logAsync = ref.watch(auditLogByIdProvider(logId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Détail de l\'action'),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined),
            onPressed: () {
              // Optionnel: Copier le log complet au presse-papier
            },
          ),
        ],
      ),
      body: logAsync.when(
        data: (log) => log == null
            ? Center(child: Text('Log introuvable'))
            : _buildContent(context, log, isDark),
        loading: () => Center(child: LoadingState()),
        error: (e, _) => Center(child: Text('Impossible de charger les détails')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AuditLog log, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryHeader(context, log, isDark),
          SizedBox(height: AppSpacing.lg),
          _buildSectionTitle(context, 'Informations de l\'Action'),
          _buildActionDetails(context, log, isDark),
          SizedBox(height: AppSpacing.lg),
          _buildSectionTitle(context, 'Acteur & Contexte'),
          _buildActorDetails(context, log, isDark),
          if (log.oldData != null || log.newData != null) ...[
            SizedBox(height: AppSpacing.lg),
            _buildSectionTitle(context, 'Modifications de données'),
            _buildDataDiff(context, log, isDark),
          ],
          if (log.metadata != null && log.metadata!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.lg),
            _buildSectionTitle(context, 'Métadonnées Supplémentaires'),
            _buildJsonBlock(log.metadata!, isDark),
          ],
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(BuildContext context, AuditLog log, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.brandPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history, color: context.colors.brandPrimary, size: 30),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.action.label.toUpperCase(),
                  style: TextStyle(fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: context.colors.brandPrimary,
                  ),
                ),
                Text(
                  log.entityType,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm:ss').format(log.occurredAt),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.brandPrimary,
            ),
      ),
    );
  }

  Widget _buildActionDetails(BuildContext context, AuditLog log, bool isDark) {
    return GlassCard(
      child: Column(
        children: [
          _buildInfoRow('Entité ID', log.entityId, Icons.fingerprint),
          Divider(height: 1),
          _buildInfoRow('Type d\'entité', log.entityType, Icons.category_outlined),
          Divider(height: 1),
          _buildInfoRow('Action', log.action.label, Icons.bolt),
        ],
      ),
    );
  }

  Widget _buildActorDetails(BuildContext context, AuditLog log, bool isDark) {
    return GlassCard(
      child: Column(
        children: [
          _buildInfoRow('Acteur', log.actorName, Icons.person_outline),
          Divider(height: 1),
          _buildInfoRow('Rôle utilisé', log.roleUsed, Icons.admin_panel_settings_outlined),
          Divider(height: 1),
          _buildInfoRow('Source Dashboard', log.dashboardSource, Icons.dashboard_outlined),
          if (log.ipAddress != null) ...[
            Divider(height: 1),
            _buildInfoRow('Adresse IP', log.ipAddress!, Icons.network_check_outlined),
          ],
          if (log.userAgent != null) ...[
            Divider(height: 1),
            _buildInfoRow('Terminal', _shortenUserAgent(log.userAgent!), Icons.devices_outlined),
          ],
        ],
      ),
    );
  }

  Widget _buildDataDiff(BuildContext context, AuditLog log, bool isDark) {
    return Column(
      children: [
        if (log.oldData != null) ...[
          Text('ANCIENNE VALEUR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red)),
          SizedBox(height: 4),
          _buildJsonBlock(log.oldData!, isDark, borderColor: Colors.red.withOpacity(0.2)),
          SizedBox(height: AppSpacing.md),
        ],
        if (log.newData != null) ...[
          Text('NOUVELLE VALEUR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
          SizedBox(height: 4),
          _buildJsonBlock(log.newData!, isDark, borderColor: Colors.green.withOpacity(0.2)),
        ],
      ],
    );
  }

  Widget _buildJsonBlock(Map<String, dynamic> data, bool isDark, {Color? borderColor}) {
    const encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(data);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: borderColor ?? (isDark ? Colors.white10 : Colors.black12)),
      ),
      child: SelectableText(
        jsonString,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          SizedBox(width: AppSpacing.md),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String _shortenUserAgent(String ua) {
    if (ua.contains('iPhone')) return 'iPhone (iOS)';
    if (ua.contains('Android')) return 'Android Device';
    if (ua.contains('Windows')) return 'Windows Desktop';
    if (ua.contains('Macintosh')) return 'macOS Desktop';
    return ua.length > 30 ? '${ua.substring(0, 27)}...' : ua;
  }
}