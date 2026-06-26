import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/widgets/widgets.dart';
class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _isProcessing = false;

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      final code = barcodes.first.rawValue!;
      setState(() => _isProcessing = true);

      // Feedback visuel ou traitement (ex: rediriger vers le profil du membre)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Code scanné: $code'),
          backgroundColor: context.colors.successText,
        ),
      );

      // TO DO : Utiliser le usecase `getMemberById` ou scanner une présence
      // Pour l'instant on simule l'action puis on ferme
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        context.pop(code); // Retourner le code lu
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for camera
      appBar: AppBar(
        title: Text('Scanner QR'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: ValueListenableBuilder<MobileScannerState>(
              valueListenable: controller,
              builder: (context, state, child) {
                switch (state.torchState) {
                  case TorchState.off:
                    return Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return Icon(Icons.flash_on, color: Colors.yellow);
                  case TorchState.unavailable:
                    return Icon(Icons.flash_off, color: Colors.red);
                  case TorchState.auto:
                    return Icon(Icons.flash_auto, color: Colors.blue);
                }
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder<MobileScannerState>(
              valueListenable: controller,
              builder: (context, state, child) {
                switch (state.cameraDirection) {
                  case CameraFacing.front:
                    return Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return Icon(Icons.camera_rear);
                }
              },
            ),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _onDetect,
          ),
          // Scanner Overlay effect (Target Box)
          CustomPaint(
            painter: ScannerOverlayPainter(focusColor: context.colors.brandPrimary),
            child: Container(),
          ),
          if (_isProcessing)
            Center(child: LoadingDots(
                size: 32,
                color: context.colors.brandPrimary,
              ),
            ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Centrez le QR Code dans le cadre',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Color focusColor;

  ScannerOverlayPainter({required this.focusColor});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    // Cadre central (transparent)
    final double rectSize = size.width * 0.7;
    final Rect rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: rectSize,
      height: rectSize,
    );

    // Dessin du fond opaque avec un "trou" au centre
    final Path backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(backgroundPath, backgroundPaint);

    // Dessin des angles du focus
    final borderPaint = Paint()
      ..color = focusColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    const cornerLength = 30.0;

    // Top-Left
    canvas.drawLine(
        rect.topLeft, rect.topLeft.translate(cornerLength, 0), borderPaint);
    canvas.drawLine(
        rect.topLeft, rect.topLeft.translate(0, cornerLength), borderPaint);

    // Top-Right
    canvas.drawLine(
        rect.topRight, rect.topRight.translate(-cornerLength, 0), borderPaint);
    canvas.drawLine(
        rect.topRight, rect.topRight.translate(0, cornerLength), borderPaint);

    // Bottom-Left
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft.translate(cornerLength, 0),
        borderPaint);
    canvas.drawLine(rect.bottomLeft,
        rect.bottomLeft.translate(0, -cornerLength), borderPaint);

    // Bottom-Right
    canvas.drawLine(rect.bottomRight,
        rect.bottomRight.translate(-cornerLength, 0), borderPaint);
    canvas.drawLine(rect.bottomRight,
        rect.bottomRight.translate(0, -cornerLength), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
