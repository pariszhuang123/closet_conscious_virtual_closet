import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utilities/app_router.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../core/utilities/helper_functions/permission_helper/camera_permission_helper.dart';
import '../bloc/qr_scan_bloc.dart';
import '../widgets/qr_scanner_widget.dart';
import '../../../../generated/l10n.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> with WidgetsBindingObserver {
  final _cameraPermissionHelper = CameraPermissionHelper();

  // remember if we've popped up the dialog
  bool _dialogUp = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // initial check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QrScanBloc>().add(CheckQrCameraPermission());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // re‐check when coming back
      context.read<QrScanBloc>().add(CheckQrCameraPermission());
    }
  }

  void _onPermissionClose() {
    context.goNamed(AppRoutesName.myCloset);
  }

  void _showDialogOnce() {
    if (!_dialogUp) {
      _dialogUp = true;
      _cameraPermissionHelper.checkAndRequestPermission(
        context: context,
        theme: Theme.of(context),
        cameraContext: CameraPermissionContext.qrScan,
        onClose: _onPermissionClose,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(s.scanToReceiveItem)),
      body: BlocConsumer<QrScanBloc, QrScanState>(
        listenWhen: (prev, curr) =>
        curr is QrCameraPermissionDenied ||
            curr is QrCameraPermissionGranted ||
            curr is QrTransferSuccess ||
            curr is QrTransferFailed,
        listener: (context, state) {
          if (state is QrCameraPermissionDenied) {
            // show dialog once
            _showDialogOnce();
          }
          else if (state is QrCameraPermissionGranted && _dialogUp) {
            // permission granted ─ pop the dialog
            _dialogUp = false;
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
          else if (state is QrTransferSuccess) {
            context.goNamed(AppRoutesName.myCloset);
          }
          else if (state is QrTransferFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(s.transferFailed)),
            );
          }
        },
        builder: (context, state) {
          if (state is QrCameraPermissionGranted) {
            // show the scanner
            return QrScannerWidget(
              onScanned: (itemId) {
                context.read<QrScanBloc>().add(QrCodeScanned(itemId));
              },
            );
          }
          // otherwise show the loader
          return const Center(child: ClosetProgressIndicator());
        },
      ),
    );
  }
}
