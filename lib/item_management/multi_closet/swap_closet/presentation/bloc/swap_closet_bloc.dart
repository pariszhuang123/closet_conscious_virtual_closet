import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/services/item_save_service.dart';
import '../../../core/data/models/multi_closet_minimal.dart';
import '../../../../../core/data/services/core_fetch_services.dart';
import '../../../../core/data/items_enums.dart';

part 'swap_closet_event.dart';
part 'swap_closet_state.dart';

class SwapClosetBloc extends Bloc<SwapClosetEvent, SwapClosetState> {
  final CoreFetchService fetchService;
  final ItemSaveService itemSaveService;
  final CustomLogger logger;

  SwapClosetBloc({required this.itemSaveService, required this.fetchService})
      : logger = CustomLogger('SwapClosetBloc'),
        super(SwapClosetInitial()) {
    on<FetchAllClosetsEvent>(_onFetchAllClosets);
    on<SelectNewClosetIdEvent>(_onSelectNewClosetId);
    on<ConfirmClosetSwapEvent>(_onConfirmClosetSwap);
  }

  Future<void> _onFetchAllClosets(
      FetchAllClosetsEvent event,
      Emitter<SwapClosetState> emit,
      ) async {
    logger.i('Fetching all closets...');
    emit(state.copyWith(status: ClosetSwapStatus.loading));

    try {
      final closetData = await fetchService.fetchAllClosets();
      final closets = closetData.map((closetMap) => MultiClosetMinimal.fromMap(closetMap)).toList();

      logger.i('Fetched ${closets.length} all closets.');
      emit(state.copyWith(
        closets: closets,
        status: ClosetSwapStatus.initial,
      ));
    } catch (error) {
      logger.e('Error fetching all closets: $error');
      emit(state.copyWith(
        status: ClosetSwapStatus.failure,
        error: error.toString(),
      ));
    }
  }

  Future<void> _onSelectNewClosetId(
      SelectNewClosetIdEvent event,
      Emitter<SwapClosetState> emit,
      ) async {
    logger.i('New closet selected: ${event.newClosetId}');
    emit(state.copyWith(selectedClosetId: event.newClosetId));
  }

  Future<void> _onConfirmClosetSwap(
      ConfirmClosetSwapEvent event,
      Emitter<SwapClosetState> emit,
      ) async {
    logger.i('Confirming closet swap...');
    emit(state.copyWith(status: ClosetSwapStatus.loading));

    try {
      // Call the ItemSaveService to edit the closet
      final response = await itemSaveService.editMultiCloset(
        closetId: event.currentClosetId,
        closetName: event.closetName,
        closetType: event.closetType,
        validDate: event.validDate, // Pass directly if it's already a DateTime
        isPublic: event.isPublic,
        itemIds: event.selectedItemIds,
        newClosetId: event.newClosetId,
      );

      // Handle successful response
      if (response['status'] == 'success') {
        logger.i('Closet swap successful with new Closet ID: ${response['closet_id']}');
        emit(state.copyWith(status: ClosetSwapStatus.success));

        // Emit navigation state
        emit(SwapClosetNavigateToMyClosetState());
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      logger.e('Error during closet swap: $e');
      emit(state.copyWith(
        status: ClosetSwapStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
