import 'dart:io';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/ocr_service.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'widgets/camera_viewfinder.dart';
import 'widgets/image_preview_card.dart';

class InvoiceCaptureScreen extends StatefulWidget {
  final Function(File, InvoiceData?) onImageSelected;

  const InvoiceCaptureScreen({super.key, required this.onImageSelected});

  @override
  State<InvoiceCaptureScreen> createState() => _InvoiceCaptureScreenState();
}

class _InvoiceCaptureScreenState extends State<InvoiceCaptureScreen> {
  File? _capturedImage;
  InvoiceData? _extractedData;
  bool _isExtracting = false;
  final ImagePicker _picker = ImagePicker();
  final OcrService _ocrService = OcrService();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _capturedImage = File(pickedFile.path);
        _extractedData = null;
      });
      await _extractInvoiceData();
    }
  }

  Future<void> _extractInvoiceData() async {
    if (_capturedImage == null) return;

    setState(() => _isExtracting = true);

    try {
      final data = await _ocrService.extractInvoiceData(_capturedImage!);
      setState(() {
        _extractedData = data;
        _isExtracting = false;
      });

      if (data != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Données extraites avec succès'),
            backgroundColor: context.colors.successText,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Extraction échouée, saisie manuelle requise'),
            backgroundColor: context.colors.warningText,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isExtracting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Impossible de traiter la facture'),
            backgroundColor: context.colors.errorText,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _confirmImage() {
    if (_capturedImage != null) {
      widget.onImageSelected(_capturedImage!, _extractedData);
    }
  }

  void _retakeImage() {
    setState(() {
      _capturedImage = null;
      _extractedData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_capturedImage != null) {
      return Stack(
        children: [
          ImagePreviewCard(
            imageFile: _capturedImage!,
            onRetake: _retakeImage,
            onConfirm: _confirmImage,
            extractedData: _extractedData,
          ),
          if (_isExtracting)
            Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoadingState(
                      message: '🤖 Extraction AI en cours...',
                      useShimmer: true,
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          SectionHeader(title: 'Capture de Facture',
            subtitle: 'Prenez une photo pour extraire les données',
            icon: Icons.document_scanner_rounded,
            iconColor: context.colors.brandPrimary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: context.colors.borderSubtle.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: CameraViewfinder(
                  onImageCaptured: (xfile) {
                    setState(() {
                      _capturedImage = File(xfile.path);
                    });
                    _extractInvoiceData();
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: GradientButton(
                  text: 'Appareil Photo',
                  icon: Icons.camera_alt_rounded,
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: GradientButton(
                  text: 'Galerie',
                  icon: Icons.photo_library_rounded,
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
