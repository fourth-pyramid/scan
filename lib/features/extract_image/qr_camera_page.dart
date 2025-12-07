// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class QrCameraPage extends StatefulWidget {
  const QrCameraPage({super.key});

  static Future<XFile?> capture(BuildContext context) {
    return Navigator.of(
      context,
      rootNavigator: true,
    ).push<XFile?>(MaterialPageRoute(builder: (_) => const QrCameraPage()));
  }

  @override
  State<QrCameraPage> createState() => _QrCameraPageState();
}

class _QrCameraPageState extends State<QrCameraPage> {
  CameraController? _controller;
  bool _isLoading = true;
  String? _error;
  bool _isFlashOn = false;
  bool _isProcessing = false;

  final GlobalKey _previewContainerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        setState(() {
          _error = 'يرجى السماح باستخدام الكاميرا';
          _isLoading = false;
        });
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _error = 'لا توجد كاميرا متاحة';
          _isLoading = false;
        });
        return;
      }

      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await controller.initialize();

      if (!mounted) return;

      setState(() {
        _controller = controller;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        debugPrint(e.toString());
        _error = 'خطأ في تشغيل الكاميرا: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _toggleFlash() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    try {
      _isFlashOn = !_isFlashOn;
      setState(() {});

      await controller.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    } catch (e) {
      _isFlashOn = false;
      setState(() {});
    }
  }

  Future<void> _captureImage() async {
    if (_isProcessing) return;

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    _isProcessing = true;
    setState(() {});

    try {
      final XFile imageFile = await controller.takePicture();

      final File sourceFile = File(imageFile.path);
      final imageBytes = await sourceFile.readAsBytes();

      final previewBox =
          _previewContainerKey.currentContext?.findRenderObject() as RenderBox?;

      // نمرر كل البيانات إلى compute لعزل المعالجة
      final processed = await compute(_processImage, {
        'imageBytes': imageBytes,
        'previewWidth': previewBox?.size.width,
        'previewHeight': previewBox?.size.height,
        'previewDx': previewBox?.localToGlobal(Offset.zero).dx,
        'previewDy': previewBox?.localToGlobal(Offset.zero).dy,
        'screenWidth': MediaQuery.of(context).size.width,
        'screenHeight': MediaQuery.of(context).size.height,
      });

      final dir = await getApplicationDocumentsDirectory();
      final savePath =
          '${dir.path}/qr_card_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await File(savePath).writeAsBytes(processed);

      if (mounted) Navigator.of(context).pop(XFile(savePath));
    } catch (e) {
      _isProcessing = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            _error!,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1 / controller.value.aspectRatio,
                child: Container(
                  key: _previewContainerKey,
                  color: Colors.black,
                  child: CameraPreview(controller),
                ),
              ),
            ),
          ),

          const Positioned.fill(child: _CardFrameOverlay()),

          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: IconButton(
              icon: Icon(
                _isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
                size: 32,
              ),
              onPressed: _toggleFlash,
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 70,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'ضع الكارت داخل المربع',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isFlashOn ? 'الفلاش مفعل' : 'استخدم الفلاش للإضاءة',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _isProcessing ? null : _captureImage,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isProcessing ? Colors.grey : Colors.white,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: _isProcessing
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<int> _processImage(Map data) {
  final raw = data['imageBytes'];
  final Uint8List bytes = raw is Uint8List
      ? raw
      : Uint8List.fromList(raw as List<int>);
  img.Image? image = img.decodeImage(bytes);

  if (image == null) return bytes;

  // تصغير الصورة للنصف — بدون تأثير بصري
  image = img.copyResize(image, width: image.width ~/ 2);

  final previewW = data['previewWidth'];
  final previewH = data['previewHeight'];
  final dx = data['previewDx'];
  final dy = data['previewDy'];
  final screenW = data['screenWidth'];
  final screenH = data['screenHeight'];

  // fallback لو مفيش preview
  if (previewW == null || previewH == null) {
    final size =
        (image.width < image.height ? image.width : image.height) * 0.7;
    final crop = img.copyCrop(
      image,
      x: ((image.width - size) / 2).toInt(),
      y: ((image.height - size) / 2).toInt(),
      width: size.toInt(),
      height: size.toInt(),
    );
    return img.encodeJpg(crop, quality: 85);
  }

  final overlaySize = screenW * 0.70;
  final left = (screenW - overlaySize) / 2;
  final top = (screenH - overlaySize) / 2;

  final relLeft = left - dx;
  final relTop = top - dy;

  final scaleX = image.width / previewW;
  final scaleY = image.height / previewH;

  final int cropX = (relLeft * scaleX).clamp(0, image.width).toInt();
  final int cropY = (relTop * scaleY).clamp(0, image.height).toInt();
  int cropW = (overlaySize * scaleX).toInt();
  int cropH = (overlaySize * scaleY).toInt();

  if (cropX + cropW > image.width) cropW = image.width - cropX;
  if (cropY + cropH > image.height) cropH = image.height - cropY;

  final cropped = img.copyCrop(
    image,
    x: cropX,
    y: cropY,
    width: cropW,
    height: cropH,
  );

  return img.encodeJpg(cropped, quality: 85);
}

// ======== Overlay ========

class _CardFrameOverlay extends StatelessWidget {
  const _CardFrameOverlay();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CardFramePainter());
  }
}

class _CardFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..color = Colors.black.withAlpha((0.6 * 255).toInt())
      ..style = PaintingStyle.fill;

    final square = size.width * 0.70;

    final left = (size.width - square) / 2;
    final top = (size.height - square) / 2;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, square, square),
          const Radius.circular(20),
        ),
      )
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, bg);

    final frame = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, square, square),
        const Radius.circular(20),
      ),
      frame,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
