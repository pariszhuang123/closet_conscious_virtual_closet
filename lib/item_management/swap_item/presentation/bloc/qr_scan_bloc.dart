import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';  // provides RealtimeChannel

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
  }

  // 1️⃣ Handle actual QR scan → perform the transfer RPC
  Future<void> _onQrCodeScanned(
      QrCodeScanned event,
      Emitter<QrScanState> emit,
      ) async {
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

  // 2️⃣ Start listening only for INSERTs where from_user=current user
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

    // Cleanup any previous channel
    if (_transferChannel != null) {
      await SupabaseConfig.client.removeChannel(_transferChannel!);
    }

    // Create a channel scoped to INSERT events on your table+filter
    _transferChannel = SupabaseConfig.client
        .realtime
        .channel('public:item_transfers')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,   // only INSERTs :contentReference[oaicite:0]{index=0}
      schema: 'public',
      table: 'item_transfers',
        filter: PostgresChangeFilter(               // ✅ Use the object
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

  // 3️⃣ When we detect the transfer, emit the away state
  Future<void> _onTransferDetected(
      TransferDetectedEvent event,
      Emitter<QrScanState> emit,
      ) async {
    logger.i('Emitting QrItemTransferredAway');
    emit(QrItemTransferredAway());
  }

  // 4️⃣ Unsubscribe when dialog closes or bloc is torn down
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

  @override
  Future<void> close() async {
    logger.i('Closing QrScanBloc; cleaning up channel');
    if (_transferChannel != null) {
      await SupabaseConfig.client.removeChannel(_transferChannel!);
    }
    return super.close();
  }
}
