import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utilities/app_router.dart';
import '../bloc/qr_scan_bloc.dart';
import '../widgets/qr_scanner_widget.dart';
import '../../../../generated/l10n.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context); // ✅

    return Scaffold(
      appBar: AppBar(title: Text(s.scanToReceiveItem)), // ✅ localized
      body: BlocListener<QrScanBloc, QrScanState>(
        listener: (context, state) {
          if (state is QrTransferSuccess) {
            context.goNamed(AppRoutesName.myCloset);
          } else if (state is QrTransferFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(s.transferFailed)), // ✅ localized
            );
          }
        },
        child: QrScannerWidget(
          onScanned: (itemId) {
            context.read<QrScanBloc>().add(QrCodeScanned(itemId));
          },
        ),
      ),
    );
  }
}
