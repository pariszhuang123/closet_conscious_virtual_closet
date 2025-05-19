import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

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
  StreamSubscription<List<Map<String, dynamic>>>? _transferSubscription;

  QrScanBloc({
    required this.itemSaveService,
    required this.authBloc,
  }) : super(QrScanInitial()) {
    on<QrCodeScanned>(_onQrCodeScanned);
    on<StartListeningForTransferEvent>(_onStartListeningForTransfer);
    on<StopListeningForTransferEvent>(_onStopListeningForTransfer);
  }

  Future<void> _onQrCodeScanned(QrCodeScanned event, Emitter<QrScanState> emit) async {
    final newOwnerId = authBloc.userId;

    if (newOwnerId == null) {
      logger.e('No authenticated user found.');
      emit(QrTransferFailed());
      return;
    }

    emit(QrTransferInProgress());

    final success = await itemSaveService.transferItemOwnership(
      itemId: event.itemId,
      newOwnerId: newOwnerId,
    );

    if (success) {
      logger.i('Transfer succeeded for item: ${event.itemId}');
      emit(QrTransferSuccess());
    } else {
      logger.e('Transfer failed for item: ${event.itemId}');
      emit(QrTransferFailed());
    }
  }

  Future<void> _onStartListeningForTransfer(
      StartListeningForTransferEvent event, Emitter<QrScanState> emit) async {
    final fromUserId = authBloc.userId;
    if (fromUserId == null) return;

    _transferSubscription?.cancel();

    _transferSubscription = SupabaseConfig.client
        .from('item_transfers')
        .stream(primaryKey: ['id'])
        .eq('from_user', fromUserId)
        .listen((payload) {
      if (payload.isNotEmpty) {
        logger.i('Detected transfer away from current user');
        emit(QrItemTransferredAway());
      }
    });
  }

  Future<void> _onStopListeningForTransfer(
      StopListeningForTransferEvent event, Emitter<QrScanState> emit) async {
    logger.i('Stopping transfer listener');
    await _transferSubscription?.cancel();
    _transferSubscription = null;
  }

  @override
  Future<void> close() async {
    await _transferSubscription?.cancel();
    return super.close();
  }
}
