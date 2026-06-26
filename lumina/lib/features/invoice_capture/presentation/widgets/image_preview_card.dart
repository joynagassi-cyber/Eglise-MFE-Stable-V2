// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/services/ocr_service.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class ImagePreviewCard extends StatelessWidget {
  final File imageFile;
  final VoidCallback onRetake;
  final VoidCallback onConfirm;
  final InvoiceData? extractedData;

  const ImagePreviewCard({
    super.key,
    required this.imageFile,
    required this.onRetake,
    required this.onConfirm,
    this.extractedData,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(imageFile, fit: BoxFit.cover),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: const Text(
                        'Aperçu de la capture',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (extractedData != null)
            AnimatedEntrance(
              child: GlassCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                borderColor: context.colors.successText,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome_rounded,
                            color: context.colors.successText, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'DONNÉES EXTRAITES PAR AI',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                            color: isDark
                                ? Colors.white70
                                : context.colors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildDataRow(context, Icons.business_rounded, 'Fournisseur',
                        extractedData!.vendor),
                    _buildDataRow(context, Icons.calendar_today_rounded, 'Date',
                        extractedData!.date?.toString() ?? "N/A"),
                    _buildDataRow(
                      context,
                      Icons.payments_rounded,
                      'Montant',
                      '${extractedData!.total} ${extractedData!.currency}',
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: GradientButton(
                  text: 'Reprendre',
                  icon: Icons.refresh_rounded,
                  onPressed: onRetake,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: GradientButton(
                  text: extractedData != null ? 'Utiliser' : 'Confirmer',
                  icon: Icons.check_circle_rounded,
                  onPressed: onConfirm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(BuildContext context, IconData icon, String label, String value,
      {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: context.colors.brandPrimary.withValues(alpha: 0.7)),
          const SizedBox(width: 8),
          Text(
            '$label : ',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}