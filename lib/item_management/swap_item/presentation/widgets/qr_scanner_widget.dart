import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerWidget extends StatefulWidget {
  final void Function(String itemId) onScanned;

  const QrScannerWidget({super.key, required this.onScanned});

  @override
  State<QrScannerWidget> createState() => _QrScannerWidgetState();
}

class _QrScannerWidgetState extends State<QrScannerWidget> {
  bool hasScanned = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          onDetect: (barcodeCapture) {
            if (hasScanned) return;
            final barcode = barcodeCapture.barcodes.first;
            final itemId = barcode.rawValue;
            if (itemId != null && itemId.isNotEmpty) {
              hasScanned = true;
              widget.onScanned(itemId);
            }
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black54,
            child: const Text(
              'Scan item QR to transfer',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
