import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lumina/core/widgets/widgets.dart';
class CameraViewfinder extends StatefulWidget {
  final Function(XFile) onImageCaptured;

  const CameraViewfinder({super.key, required this.onImageCaptured});

  @override
  State<CameraViewfinder> createState() => _CameraViewfinderState();
}

class _CameraViewfinderState extends State<CameraViewfinder> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _controller = CameraController(_cameras.first, ResolutionPreset.high);
      await _controller!.initialize();
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: LoadingState());
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CameraPreview(_controller!),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: FloatingActionButton(
            onPressed: () async {
              try {
                final image = await _controller!.takePicture();
                widget.onImageCaptured(image);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Erreur capture: $e')));
                }
              }
            },
            child: const Icon(Icons.camera_alt),
          ),
        ),
      ],
    );
  }
}