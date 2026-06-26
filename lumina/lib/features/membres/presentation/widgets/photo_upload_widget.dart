// lib/features/membres/presentation/widgets/photo_upload_widget.dart
import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/providers/drive_service_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import 'package:lumina/core/widgets/widgets.dart';
class PhotoUploadWidget extends ConsumerStatefulWidget {
  final String memberId;
  final String churchId;
  final VoidCallback? onUploadSuccess;

  const PhotoUploadWidget({
    super.key,
    required this.memberId,
    required this.churchId,
    this.onUploadSuccess,
  });

  @override
  ConsumerState<PhotoUploadWidget> createState() => _PhotoUploadWidgetState();
}

class _PhotoUploadWidgetState extends ConsumerState<PhotoUploadWidget> {
  bool _uploading = false;
  String? _uploadedFileId;

  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() => _uploading = true);

    try {
      final bytes = await image.readAsBytes();
      final authToken = ref.read(authProvider).value?.accessToken;

      if (authToken == null) throw Exception('Not authenticated');

      final result = await ref.read(driveServiceProvider).uploadFile(
            entityType: 'member_photo',
            entityId: widget.memberId,
            churchId: widget.churchId,
            fileBytes: bytes,
            filename: 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
            mimeType: 'image/jpeg',
            authToken: authToken,
            encrypt: true,
          );

      setState(() => _uploadedFileId = result.fileId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Photo uploadée avec succès'),
            backgroundColor: context.colors.successText,
          ),
        );
        widget.onUploadSuccess?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Impossible de télécharger la photo'),
            backgroundColor: context.colors.errorText,
          ),
        );
      }
    } finally {
      setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _uploading ? null : _pickAndUpload,
          icon: _uploading
              ? const LoadingDots(size: 24)
              : Icon(Icons.upload_file),
          label: Text(_uploading ? 'Upload en cours...' : 'Choisir photo'),
        ),
        if (_uploadedFileId != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Photo uploadée',
              style: TextStyle(color: context.colors.successText),
            ),
          ),
      ],
    );
  }
}
