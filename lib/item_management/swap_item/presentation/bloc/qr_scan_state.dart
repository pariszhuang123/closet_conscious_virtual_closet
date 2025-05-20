part of 'qr_scan_bloc.dart';

abstract class QrScanState extends Equatable {
  const QrScanState();

  @override
  List<Object?> get props => [];
}

class QrScanInitial extends QrScanState {}

class QrTransferInProgress extends QrScanState {}

class QrTransferSuccess extends QrScanState {}

class QrTransferFailed extends QrScanState {}

class QrItemTransferredAway extends QrScanState {}

class QrCameraPermissionChecking extends QrScanState {}

class QrCameraPermissionGranted extends QrScanState {}

class QrCameraPermissionDenied extends QrScanState {}
