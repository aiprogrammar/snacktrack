import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../services/product_service.dart';
import 'product_details_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _isProcessing = false;
  MobileScannerController controller = MobileScannerController();

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null) return;

    setState(() => _isProcessing = true);

    try {
      final product =
          await context.read<ProductService>().getProductFromQrCode(code);
      if (mounted) {
        if (product != null) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsScreen(product: product),
            ),
          );
          controller.start();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid product QR code')),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off);
                  case TorchState.on:
                    return const Icon(Icons.flash_on);
                }
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
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
          // Scan overlay
          CustomPaint(
            painter: ScanOverlayPainter(),
            child: const SizedBox.expand(),
          ),
          // Loading indicator
          if (_isProcessing)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          // Scanning instructions
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Text(
              'Point your camera at a product QR code',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
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

class ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    const scanAreaSize = 250.0;
    final scanAreaRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanAreaSize,
      height: scanAreaSize,
    );

    // Draw the semi-transparent overlay
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(
              RRect.fromRectAndRadius(scanAreaRect, const Radius.circular(12))),
      ),
      paint,
    );

    // Draw the scanning area border
    paint
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanAreaRect, const Radius.circular(12)),
      paint,
    );

    // Draw corner markers
    const markerLength = 24.0;
    paint.strokeWidth = 4;

    // Top left corner
    canvas.drawLine(
      scanAreaRect.topLeft.translate(0, markerLength),
      scanAreaRect.topLeft,
      paint,
    );
    canvas.drawLine(
      scanAreaRect.topLeft.translate(markerLength, 0),
      scanAreaRect.topLeft,
      paint,
    );

    // Top right corner
    canvas.drawLine(
      scanAreaRect.topRight.translate(0, markerLength),
      scanAreaRect.topRight,
      paint,
    );
    canvas.drawLine(
      scanAreaRect.topRight.translate(-markerLength, 0),
      scanAreaRect.topRight,
      paint,
    );

    // Bottom left corner
    canvas.drawLine(
      scanAreaRect.bottomLeft.translate(0, -markerLength),
      scanAreaRect.bottomLeft,
      paint,
    );
    canvas.drawLine(
      scanAreaRect.bottomLeft.translate(markerLength, 0),
      scanAreaRect.bottomLeft,
      paint,
    );

    // Bottom right corner
    canvas.drawLine(
      scanAreaRect.bottomRight.translate(0, -markerLength),
      scanAreaRect.bottomRight,
      paint,
    );
    canvas.drawLine(
      scanAreaRect.bottomRight.translate(-markerLength, 0),
      scanAreaRect.bottomRight,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
