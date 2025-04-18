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
    on<CreateMultiClosetValidate>(_onCreateMultiClosetValidate); // Handle validation
    on<CreateMultiClosetRequested>(_onCreateMultiClosetRequested); // Handle closet creation
  }

  // Handle Validation Event
  Future<void> _onCreateMultiClosetValidate(
      CreateMultiClosetValidate event, Emitter<CreateMultiClosetState> emit) async {
    logger.i('Validating multi-closet data.');

    final errors = _validateClosetData(
      closetName: event.closetName,
      closetType: event.closetType,
      monthsLater: event.monthsLater,
      isPublic: event.isPublic,
    );

    if (errors.isNotEmpty) {
      logger.e('Validation failed: $errors');
      emit(state.copyWith(
        status: ClosetStatus.failure,
        validationErrors: errors,
      ));
    } else {
      logger.i('Validation succeeded.');
      emit(state.copyWith(
        status: ClosetStatus.valid,
        validationErrors: null, // Clear previous errors
      ));
    }
  }

  // Handle Closet Creation Event
  Future<void> _onCreateMultiClosetRequested(
      CreateMultiClosetRequested event, Emitter<CreateMultiClosetState> emit) async {
    logger.i('Creating multi-closet with data: $event');

    emit(state.copyWith(status: ClosetStatus.loading));

    try {
      await itemSaveService.addMultiCloset(
        closetName: event.closetName,
        closetType: event.closetType,
        itemIds: event.itemIds,
        monthsLater: event.monthsLater != null ? int.tryParse(event.monthsLater!) : null,
        isPublic: event.isPublic,
      );
      logger.i('Closet created successfully.');
      emit(state.copyWith(status: ClosetStatus.success));
    } catch (e) {
      logger.e('Error creating closet: $e');
      emit(state.copyWith(
        status: ClosetStatus.failure,
        error: e.toString(),
      ));
    }
  }

  // Validation Logic
  Map<String, String> _validateClosetData({
    required String? closetName,
    required String closetType,
    required String? monthsLater,
    required bool? isPublic,
  }) {
    final errors = <String, String>{};

    // Validate closetName
    if (closetName == null || closetName.isEmpty) {
      errors['closetName'] = 'closetNameCannotBeEmpty'; // Key for empty closet name
    } else if (closetName == 'cc_closet') {
      errors['closetName'] = 'reservedClosetNameError'; // Key for reserved key
    }

    // Validate monthsLater if closetType is 'disappear'
    if (closetType == 'disappear') {
      final months = monthsLater != null ? int.tryParse(monthsLater) : null;
      if (months == null || months <= 0) {
        errors['monthsLater'] = 'invalidMonthsValue';
      } else if (months > 12) {
        errors['monthsLater'] = 'monthsCannotExceed12';
      }
    }

    return errors;
  }
}
