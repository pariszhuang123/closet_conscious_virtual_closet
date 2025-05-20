import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/utilities/logger.dart';
import '../../../../../core/config/supabase_config.dart';
import '../../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../core/data/services/item_save_service.dart';

part 'qr_scan_event.dart';
part 'qr_scan_state.dart';

class QrScanBloc extends Bloc<QrScanEvent, QrScanState> {
  final ItemSaveService itemSaveService;
  final AuthBloc authBloc;
  final CustomLogger logger = CustomLogger('QrScanBloc');

  RealtimeChannel? _transferChannel;

  QrScanBloc({
    required this.itemSaveService,
    required this.authBloc,
  }) : super(QrScanInitial()) {
    logger.i('QrScanBloc initialized');

    on<QrCodeScanned>(_onQrCodeScanned);
    on<StartListeningForTransferEvent>(_onStartListeningForTransfer);
    on<TransferDetectedEvent>(_onTransferDetected);
    on<StopListeningForTransferEvent>(_onStopListeningForTransfer);
    on<CheckQrCameraPermission>(_onCheckQrCameraPermission);
  }

  Future<void> _onQrCodeScanned(QrCodeScanned event, Emitter<QrScanState> emit) async {
    logger.i('Received QrCodeScanned(event.itemId=${event.itemId})');
    final newOwnerId = authBloc.userId;

    if (newOwnerId == null) {
      logger.e('No authenticated user.');
      emit(QrTransferFailed());
      return;
    }

    logger.i('Transferring item ${event.itemId} → user $newOwnerId');
    emit(QrTransferInProgress());

    final success = await itemSaveService.transferItemOwnership(
      itemId: event.itemId,
      newOwnerId: newOwnerId,
    );

    if (success) {
      logger.i('Transfer succeeded for ${event.itemId}');
      emit(QrTransferSuccess());
    } else {
      logger.e('Transfer failed for ${event.itemId}');
      emit(QrTransferFailed());
    }
  }

  Future<void> _onStartListeningForTransfer(
      StartListeningForTransferEvent event,
      Emitter<QrScanState> emit,
      ) async {
    final fromUserId = authBloc.userId;
    if (fromUserId == null) {
      logger.e('Cannot listen: no authenticated user.');
      return;
    }

    logger.i('Subscribing to INSERTs on item_transfers for $fromUserId');

    if (_transferChannel != null) {
      await SupabaseConfig.client.removeChannel(_transferChannel!);
    }

    _transferChannel = SupabaseConfig.client
        .realtime
        .channel('public:item_transfers')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'item_transfers',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'from_user',
        value: fromUserId,
      ),
      callback: (payload) {
        logger.i('Realtime INSERT detected: ${payload.newRecord}');
        add(TransferDetectedEvent());
      },
    )
        .subscribe();
  }

  Future<void> _onTransferDetected(
      TransferDetectedEvent event,
      Emitter<QrScanState> emit,
      ) async {
    logger.i('Emitting QrItemTransferredAway');
    emit(QrItemTransferredAway());
  }

  Future<void> _onStopListeningForTransfer(
      StopListeningForTransferEvent event,
      Emitter<QrScanState> emit,
      ) async {
    logger.i('Unsubscribing from realtime channel');
    if (_transferChannel != null) {
      await SupabaseConfig.client.removeChannel(_transferChannel!);
      _transferChannel = null;
    }
  }

  Future<void> _onCheckQrCameraPermission(
      CheckQrCameraPermission event,
      Emitter<QrScanState> emit,
      ) async {
    emit(QrCameraPermissionChecking());

    await Future.delayed(const Duration(milliseconds: 250));
    final status = await Permission.camera.status;

    if (status.isGranted) {
      emit(QrCameraPermissionGranted());
    } else {
      emit(QrCameraPermissionDenied());
    }
  }

  @override
  Future<void> close() async {
    logger.i('Closing QrScanBloc; cleaning up channel');
    if (_transferChannel != null) {
      await SupabaseConfig.client.removeChannel(_transferChannel!);
    }
    return super.close();
  }
}
