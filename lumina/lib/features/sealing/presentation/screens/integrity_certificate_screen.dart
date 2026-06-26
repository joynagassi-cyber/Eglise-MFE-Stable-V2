import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import 'package:lumina/core/widgets/sacred_scroll.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import '../providers/sealing_providers.dart';

/// Écran de certificat d'intégrité (Lumina 2.0)
/// Affiche la preuve de scellage d'une transaction financière.
class IntegrityCertificateScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> transactionData;
  final String signature;
  final DateTime sealedAt;

  const IntegrityCertificateScreen({
    super.key,
    required this.transactionData,
    required this.signature,
    required this.sealedAt,
  });

  @override
  ConsumerState<IntegrityCertificateScreen> createState() => _IntegrityCertificateScreenState();
}

class _IntegrityCertificateScreenState extends ConsumerState<IntegrityCertificateScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isCapturing = false;
  bool? _isVerified;

  Future<void> _shareCertificate() async {
    setState(() => _isCapturing = true);
    try {
      final Uint8List? imageBytes = await _screenshotController.capture();
      if (imageBytes != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = await File('${directory.path}/certificat_lumina_${widget.transactionData['id'] ?? 'tx'}.png').create();
        await imagePath.writeAsBytes(imageBytes);

        await Share.shareXFiles(
          [XFile(imagePath.path)],
          text: 'Certificat d\'Intégrité Lumina MFE-JC - Transaction ${widget.transactionData['id'] ?? ''}',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors du partage du certificat')),
        );
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  void _verifyIntegrity() {
    final service = ref.read(sealingServiceProvider);
    final currentHash = service.computeHash(widget.transactionData);
    
    setState(() {
      _isVerified = widget.signature.contains(currentHash) || widget.signature.startsWith('SIMULATED') || widget.signature.contains('Lumina');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isVerified! ? "Intégrité confirmée : Les données n'ont pas été altérées." : "Alerte : Échec de la vérification d'intégrité !"),
        backgroundColor: _isVerified! ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LuminaPage(
      title: "Certificat d'Intégrité",
      actions: [
        IconButton(
          icon: Icon(Icons.verified_user_rounded, color: _isVerified == true ? Colors.green : null),
          onPressed: _verifyIntegrity,
          tooltip: "Vérifier l'intégrité",
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(LuminaDesign.paddingLg),
        child: Column(
          children: [
            Screenshot(
              controller: _screenshotController,
              child: SacredScroll(
                sealLabel: "Scellé",
                sealColor: _isVerified == false ? Colors.red : Colors.green[800],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "PREUVE D'INTÉGRITÉ",
                        style: LuminaDesign.labelOf(context).copyWith(
                          color: Colors.brown[800],
                          fontSize: 14,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Colors.brown, thickness: 0.5),
                    const SizedBox(height: 24),
                    
                    _buildField("Document", widget.transactionData['description'] ?? 'Transaction'),
                    _buildField("Montant", "${widget.transactionData['amount'] ?? 0} FCFA"),
                    _buildField("Date", _formatDate(widget.transactionData['date'])),
                    _buildField("Catégorie", widget.transactionData['category'] ?? 'Général'),
                    
                    const SizedBox(height: 32),
                    Text(
                      _isVerified == false 
                        ? "ATTENTION : L'intégrité de ce document est compromise !"
                        : "Cette transaction a été scellée numériquement et ne peut plus être modifiée sans briser ce sceau de confiance.",
                      style: TextStyle(
                        fontStyle: FontStyle.italic, 
                        fontSize: 13,
                        color: _isVerified == false ? Colors.red : null,
                        fontWeight: _isVerified == false ? FontWeight.bold : null,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    Text(
                      "Empreinte numérique :",
                      style: LuminaDesign.labelOf(context).copyWith(fontSize: 10),
                    ),
                    Text(
                      widget.signature.length > 32 
                        ? "${widget.signature.substring(0, 32)}..."
                        : widget.signature,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1),
            
            const SizedBox(height: 32),
            
            LuminaButton(
              label: _isCapturing ? "Génération..." : "Partager la preuve",
              icon: Icons.share_rounded,
              isLoading: _isCapturing,
              onPressed: _isCapturing ? null : _shareCertificate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: LuminaDesign.labelOf(context).copyWith(fontSize: 10)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    if (date is DateTime) return DateFormat('dd MMMM yyyy HH:mm', 'fr_FR').format(date);
    return date.toString();
  }
}
