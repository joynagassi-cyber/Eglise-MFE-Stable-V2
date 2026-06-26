// lib/features/finance/presentation/widgets/invoice_upload_widget.dart
import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/providers/drive_service_provider.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../../core/providers/auth_provider.dart';

class InvoiceUploadWidget extends ConsumerStatefulWidget {
  final String transactionId;
  final String churchId;
  final VoidCallback? onUploadSuccess;

  const InvoiceUploadWidget({
    super.key,
    required this.transactionId,
    required this.churchId,
    this.onUploadSuccess,
  });

  @override
  ConsumerState<InvoiceUploadWidget> createState() =>
      _InvoiceUploadWidgetState();
}

class _InvoiceUploadWidgetState extends ConsumerState<InvoiceUploadWidget> {
  bool _uploading = false;
  String? _uploadedFileId;
  bool _canSeal = false;

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result == null) return;

    setState(() => _uploading = true);

    try {
      final file = result.files.first;
      final authToken = ref.read(authProvider).value?.accessToken;

      if (authToken == null) throw Exception('Not authenticated');

      final uploadResult = await ref.read(driveServiceProvider).uploadFile(
            entityType: 'invoice',
            entityId: widget.transactionId,
            churchId: widget.churchId,
            fileBytes: file.bytes!,
            filename: file.name,
            mimeType: 'application/pdf',
            authToken: authToken,
            encrypt: true,
          );

      setState(() {
        _uploadedFileId = uploadResult.fileId;
        _canSeal = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Facture uploadée'),
            backgroundColor: context.colors.successText,
          ),
        );
        widget.onUploadSuccess?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Impossible de télécharger la facture'),
            backgroundColor: context.colors.errorText,
          ),
        );
      }
    } finally {
      setState(() => _uploading = false);
    }
  }

  Future<void> _sealInvoice() async {
    if (_uploadedFileId == null) return;

    setState(() => _uploading = true);

    try {
      final authToken = ref.read(authProvider).value?.accessToken;
      if (authToken == null) throw Exception('Not authenticated');

      await ref
          .read(driveServiceProvider)
          .sealInvoice(fileId: _uploadedFileId!, authToken: authToken);

      setState(() => _canSeal = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Facture scellée'),
            backgroundColor: context.colors.successText,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur scellement: $e'),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: _uploading ? null : _pickAndUpload,
          icon: _uploading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: LoadingDots(),
                )
              : Icon(Icons.upload_file),
          label: Text(_uploading ? 'Upload...' : 'Joindre facture'),
        ),
        if (_uploadedFileId != null) ...[
          SizedBox(height: 8),
          Text('Facture uploadée',
            style: TextStyle(color: context.colors.successText),
          ),
          if (_canSeal) ...[
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _uploading ? null : _sealInvoice,
              icon: Icon(Icons.lock),
              label: Text('Sceller facture'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.warningText,
              ),
            ),
          ],
        ],
      ],
    );
  }
}
