import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/data/services/item_save_service.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/items_enums.dart';


part 'create_multi_closet_event.dart';
part 'create_multi_closet_state.dart';

class CreateMultiClosetBloc extends Bloc<CreateMultiClosetEvent, CreateMultiClosetState> {
  final ItemSaveService itemSaveService;
  final CustomLogger logger = CustomLogger('CreateMultiClosetBloc');

  CreateMultiClosetBloc(this.itemSaveService) : super(const CreateMultiClosetState()) {
    logger.i('Initializing CreateMultiClosetBloc');
    on<CreateMultiClosetRequested>(_onCreateMultiClosetRequested);
  }

  Future<void> _onCreateMultiClosetRequested(
      CreateMultiClosetRequested event, Emitter<CreateMultiClosetState> emit) async {
    logger.i('Creating multi-closet:');
    logger.i('Closet Name: ${event.closetName}');
    logger.i('Closet Type: ${event.closetType}');
    logger.i('Item IDs: ${event.itemIds}');
    logger.i('Months Later: ${event.monthsLater}');
    logger.i('Is Public: ${event.isPublic}');

    // Start loading state
    emit(state.copyWith(status: ClosetStatus.loading));

    // Perform the saving operation
    try {
      await itemSaveService.addMultiCloset(
        closetName: event.closetName,
        closetType: event.closetType,
        itemIds: event.itemIds,
        monthsLater: event.monthsLater,
        isPublic: event.isPublic,
      );
      logger.i('Closet created successfully');
      emit(state.copyWith(status: ClosetStatus.success));
    } catch (e) {
      logger.e('Error creating closet: $e');
      emit(state.copyWith(
        status: ClosetStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
