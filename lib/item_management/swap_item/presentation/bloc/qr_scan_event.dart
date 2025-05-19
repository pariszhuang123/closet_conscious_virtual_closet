part of 'qr_scan_bloc.dart';

abstract class QrScanEvent extends Equatable {
  const QrScanEvent();

  @override
  List<Object?> get props => [];
}

class QrCodeScanned extends QrScanEvent {
  final String itemId;

  const QrCodeScanned(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class StartListeningForTransferEvent extends QrScanEvent {}

class StopListeningForTransferEvent extends QrScanEvent {}
