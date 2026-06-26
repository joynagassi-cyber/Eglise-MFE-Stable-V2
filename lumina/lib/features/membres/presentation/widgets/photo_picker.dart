// lib/features/membres/presentation/widgets/photo_picker.dart
// Widget pour sélectionner/uploader une photo de membre

import 'dart:io';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:lumina/core/widgets/widgets.dart';
class PhotoPicker extends StatefulWidget {
  final String? currentPhotoUrl;
  final File? currentLocalPhoto;
  final Function(File photo) onPhotoPicked;
  final double size;

  const PhotoPicker({
    super.key,
    this.currentPhotoUrl,
    this.currentLocalPhoto,
    required this.onPhotoPicked,
    this.size = 100.0,
  });

  @override
  State<PhotoPicker> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  File? _localPhoto;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _localPhoto = widget.currentLocalPhoto;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Avatar circulaire
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.bgCardLight,
              border: Border.all(
                color: context.colors.brandPrimary.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(child: _buildImageWidget()),
          ),
        ),

        // Loading indicator
        if (_isLoading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.5),
              ),
              child: const Center(
                child: LoadingDots(color: Colors.white, size: 28),
              ),
            ),
          ),

        // Bouton caméra
        if (!_isLoading)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.colors.brandPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageWidget() {
    // Photo locale sélectionnée
    if (_localPhoto != null) {
      return Image.file(
        _localPhoto!,
        fit: BoxFit.cover,
        width: widget.size,
        height: widget.size,
      );
    }

    // Photo depuis URL (Supabase)
    if (widget.currentPhotoUrl != null && widget.currentPhotoUrl!.isNotEmpty) {
      return CachedImageWidget(
        imageUrl: widget.currentPhotoUrl!,
        fit: BoxFit.cover,
        width: widget.size,
        height: widget.size,
        memCacheWidth: widget.size.toInt(),
        memCacheHeight: widget.size.toInt(),
      );
    }

    // Placeholder par défaut
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: context.colors.brandPrimaryContainer.withValues(alpha: 0.3),
      child: Icon(
        Icons.person,
        size: widget.size * 0.5,
        color: context.colors.brandPrimary.withValues(alpha: 0.5),
      ),
    );
  }

  Future<void> _pickImage() async {
    // Afficher dialogue de sélection source
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir une photo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: context.colors.brandPrimary),
              title: const Text('Appareil photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library,
                color: context.colors.brandPrimary,
              ),
              title: const Text('Galerie'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );

    if (source == null) return;

    setState(() => _isLoading = true);

    try {
      // 1. Sélectionner l'image
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 90,
      );

      if (pickedFile == null) {
        setState(() => _isLoading = false);
        return;
      }

      if (!mounted) return;

      // 2. Recadrage carré
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recadrer la photo',
            toolbarColor: context.colors.brandPrimary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Recadrer la photo',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile == null) {
        setState(() => _isLoading = false);
        return;
      }

      // 3. Compression
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        croppedFile.path,
        minWidth: 400,
        minHeight: 400,
        quality: 85,
      );

      if (compressedBytes == null) {
        throw Exception('Échec de la compression');
      }

      // Sauvegarder le fichier compressé
      final compressedFile = File(croppedFile.path)
        ..writeAsBytesSync(compressedBytes);

      // Mettre à jour l'UI
      setState(() {
        _localPhoto = compressedFile;
        _isLoading = false;
      });

      // Callback
      widget.onPhotoPicked(compressedFile);
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sélection: $e'),
            backgroundColor: context.colors.errorText,
          ),
        );
      }
    }
  }
}
