import 'dart:io';
import 'package:lumina/core/extensions/context_extension.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
class BibleShareStudio extends ConsumerStatefulWidget {
  final String book;
  final List<int> verses;
  final String content;

  const BibleShareStudio({
    super.key,
    required this.book,
    required this.verses,
    required this.content,
  });

  @override
  ConsumerState<BibleShareStudio> createState() => _BibleShareStudioState();
}

class _BibleShareStudioState extends ConsumerState<BibleShareStudio> {
  final GlobalKey _repaintKey = GlobalKey();
  double _fontSize = 24.0;
  TextAlign _textAlign = TextAlign.center;
  Color? _textColor; // Initiated in didChangeDependencies using context.colors.textOnBrand
  String _bgImageUrl =
      'https://images.unsplash.com/photo-1507502707541-f369a3b18502?q=80&w=1000'; // Default cinematic bg
  final List<String> _backgroundImages = [
    'https://images.unsplash.com/photo-1507502707541-f369a3b18502?q=80&w=1000', // Mountains
    'https://images.unsplash.com/photo-1470813740244-df37b8c1edcb?q=80&w=1000', // Nature / Leaf
    'https://images.unsplash.com/photo-1494548162494-384bba4ab999?q=80&w=1000', // Sunrise / Dawn
    'https://images.unsplash.com/photo-1478147427282-58a87a120781?q=80&w=1000', // Minimal Dark Texture
    'https://images.unsplash.com/photo-1604871000636-074fa5117945?q=80&w=1000', // Abstract Fire
  ];
  int _bgIndex = 0;
  double _overlayOpacity = 0.4;
  bool _isGoldTheme = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textColor ??= context.colors.textOnBrand;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgPrimary,
      appBar: GlassAppBar(
        title: Text('STUDIO CREATIF'),
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle_rounded,
                color: context.colors.accent),
            onPressed: _shareImage,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: _buildPreviewCard(),
            ),
          ),
          _buildEditorTools(),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    return RepaintBoundary(
      key: _repaintKey,
      child: AspectRatio(
        aspectRatio: 1, // Square for Instagram/Social
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: context.colors.accent.withOpacity(0.3),
                blurRadius: 12.0,
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Background Image
              Image.network(
                _bgImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) =>
                    Container(color: context.colors.bgSecondary),
              ),

              // 2. Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(_overlayOpacity),
                      Colors.black.withOpacity(_overlayOpacity + 0.2),
                    ],
                  ),
                ),
              ),

              // 3. Content
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isGoldTheme)
                      Icon(Icons.auto_awesome,
                          color: context.colors.accent, size: 24),
                    SizedBox(height: 16),
                    Text(
                      widget.content,
                      textAlign: _textAlign,
                      style: AppTypography.editorialDisplay.copyWith(
                        color: _textColor,
                        fontSize: _fontSize,
                        height: 1.4,
                        shadows: [
                          Shadow(
                              color: context.colors.bgScrim.withOpacity(0.15),
                              blurRadius: 10),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      '${widget.book} ${widget.verses.join(', ')}',
                      style: AppTypography.editorialSection.copyWith(
                        color: _isGoldTheme
                            ? context.colors.accent
                            : context.colors.accent,
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                    ),
                    Spacer(),
                    Text(
                      ' ',
                      style: AppTypography.editorialSection.copyWith(
                        color: context.colors.textOnBrand.withOpacity(0.5),
                        fontSize: 10,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditorTools() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
      backgroundColor: context.colors.bgSecondary.withOpacity(0.95),
      borderRadius: 0,
      showShine: true,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildToolItem(Icons.text_fields, 'Taille', () {
                setState(() => _fontSize =
                    _fontSize == 24 ? 18 : (_fontSize == 18 ? 32 : 24));
              }),
              _buildToolItem(Icons.format_align_center, 'Align', () {
                setState(() => _textAlign = _textAlign == TextAlign.center
                    ? TextAlign.left
                    : TextAlign.center);
              }),
              _buildToolItem(Icons.image, 'Image', () {
                setState(() {
                  _bgIndex = (_bgIndex + 1) % _backgroundImages.length;
                  _bgImageUrl = _backgroundImages[_bgIndex];
                });
              }),
              _buildToolItem(Icons.palette, 'Thème', () {
                setState(() {
                  _isGoldTheme = !_isGoldTheme;
                  _textColor =
                      _isGoldTheme ? context.colors.accent : context.colors.textOnBrand;
                });
              }),
              _buildToolItem(Icons.layers, 'Ombre', () {
                setState(() =>
                    _overlayOpacity = _overlayOpacity == 0.4 ? 0.7 : 0.4);
              }),
            ],
          ),
          SizedBox(height: AppSpacing.xl),
          GradientButton(
            text: 'PARTAGER LA PAROLE',
            onPressed: _shareImage,
            gradient: context.colors.brandGradient,
            height: 56,
          ),
        ],
      ),
    );
  }

  Widget _buildToolItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.colors.textPrimary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: context.colors.textPrimary, size: 20),
            ),
            SizedBox(height: 6),
            Text(label,
                style: AppTypography.labelSmall.copyWith(
                  color: context.colors.textSecondary,
                  fontSize: 10,
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _shareImage() async {
    try {
      // 1. Capture the image using RepaintBoundary
      RenderRepaintBoundary boundary = _repaintKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      // We might need to handle the case where the boundary is not yet built
      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 20));
        boundary = _repaintKey.currentContext!.findRenderObject()
            as RenderRepaintBoundary;
      }

      // 2. Convert to UI Image (scale 3.0 for better quality)
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // 3. Convert to Bytes
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // 4. Save to temporary file
      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/sacred_share_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(pngBytes);

      // 5. Share via share_plus
      final textComponent =
          ' ${widget.content}\\n\\n— ${widget.book} ${widget.verses.join(', ')}\\nVia Lumina App';
      await Share.shareXFiles([XFile(imagePath)], text: textComponent);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du partage : $e'),
            backgroundColor: context.colors.errorText,
          ),
        );
      }
    }
  }
}
