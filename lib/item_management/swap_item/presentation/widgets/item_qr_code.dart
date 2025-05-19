import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class ItemQrCode extends StatelessWidget {
  final String itemId;

  const ItemQrCode({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return BarcodeWidget(
      barcode: Barcode.qrCode(), // You can also use Barcode.code128(), etc.
      data: itemId,              // The item ID from your fetch logic
      width: 200,
      height: 200,
      errorBuilder: (context, error) => Text('QR Error: $error'),
    );
  }
}
