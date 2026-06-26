import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:pdfx/pdfx.dart';

import '../../../../core/widgets/skeletons/fire_skeleton_system.dart';
import '../../../../core/theme/lumina_colors_extension.dart';

/// Secure PDF viewer for unlocked reading plan rewards.
/// Renders PDFs from local file paths or asset bundles.
class PdfRewardReader extends StatefulWidget {
  final String title;
  final String pdfPath;
  final bool isAsset;

  const PdfRewardReader({
    super.key,
    required this.title,
    required this.pdfPath,
    this.isAsset = false,
  });

  @override
  State<PdfRewardReader> createState() => _PdfRewardReaderState();
}

class _PdfRewardReaderState extends State<PdfRewardReader> {
  late PdfControllerPinch _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initPdf();
  }

  void _initPdf() {
    try {
      final document = widget.isAsset
          ? PdfDocument.openAsset(widget.pdfPath)
          : PdfDocument.openFile(widget.pdfPath);
      _controller = PdfControllerPinch(document: document);
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = 'Impossible d\'ouvrir le PDF: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bgPage,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: colors.textPrimary, fontSize: 16),
        ),
        backgroundColor: colors.bgSecondary,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.iconPrimary),
      ),
      body: _buildBody(colors),
    );
  }

  Widget _buildBody(LuminaColorsExtension colors) {
    if (_isLoading) {
      return const _PdfSkeleton();
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: colors.errorText, size: 48),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return PdfViewPinch(
      controller: _controller,
      builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
        options: const DefaultBuilderOptions(),
        documentLoaderBuilder: (_) => const _PdfSkeleton(),
        pageLoaderBuilder: (_) => const _PdfSkeleton(),
        errorBuilder: (_, error) => Center(
          child: Text(
            error.toString(),
            style: TextStyle(color: colors.errorText),
          ),
        ),
      ),
    );
  }
}

class _PdfSkeleton extends StatelessWidget {
  const _PdfSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: List.generate(3, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FireSkeletonAtom.rect(
            context: context,
            height: 200,
            radius: 12,
          ),
        )),
      ),
    );
  }
}
