import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/data/services/item_save_service.dart';
import '../../../../../../core/utilities/logger.dart';
import '../../../../../core/data/items_enums.dart';

part 'edit_multi_closet_event.dart';
part 'edit_multi_closet_state.dart';

class EditMultiClosetBloc extends Bloc<EditMultiClosetEvent, EditMultiClosetState> {
  final ItemSaveService itemSaveService;
  final CustomLogger logger = CustomLogger('EditMultiClosetBloc');

  EditMultiClosetBloc(this.itemSaveService) : super(const EditMultiClosetState()) {
    logger.i('Initializing CreateMultiClosetBloc');
    on<EditMultiClosetValidate>(_onEditMultiClosetValidate); // Handle validation
    on<EditMultiClosetUpdate>(_onEditMultiClosetUpdate); // Handle closet creation
    on<EditMultiClosetSkipValidation>(_onEditMultiClosetSkipValidation); // Handle skipping validation
  }

  // Handle Skip Validation Event
  void _onEditMultiClosetSkipValidation(
      EditMultiClosetSkipValidation event, Emitter<EditMultiClosetState> emit) {
    logger.i('Skipping validation as metadata is hidden.');
    emit(state.copyWith(
      status: ClosetStatus.valid,
      validationErrors: null, // Clear any validation errors
    ));
  }

  // Handle Validation Event
  Future<void> _onEditMultiClosetValidate(
      EditMultiClosetValidate event, Emitter<EditMultiClosetState> emit) async {
    logger.i('Validating multi-closet data.');

    final errors = _validateClosetData(
      closetName: event.closetName,
      closetType: event.closetType,
      validDate: event.validDate,
      isPublic: event.isPublic,
      itemIds: event.itemIds, // Pass selected items here
    );

    if (errors.isNotEmpty) {
      logger.e('Validation failed: $errors');
      emit(state.copyWith(
        status: ClosetStatus.failure,
        validationErrors: errors,
      ));
      return;
    }

    logger.i('Validation succeeded.');
    emit(state.copyWith(
      status: ClosetStatus.valid,
      validationErrors: null, // Clear previous errors
    ));
  }

  // Handle Closet Edit Event
  Future<void> _onEditMultiClosetUpdate(
      EditMultiClosetUpdate event, Emitter<EditMultiClosetState> emit) async {
    logger.i('Edit multi-closet with data: $event');

    emit(state.copyWith(status: ClosetStatus.loading));

    try {
      await itemSaveService.editMultiCloset(
        closetId: event.closetId,
        closetName: event.closetName,
        closetType: event.closetType,
        validDate: event.validDate,
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
    required DateTime? validDate,
    required bool? isPublic,
    List<String>? itemIds, // Optional parameter

  }) {
    final errors = <String, String>{};

    // Validate closetName
    if (closetName == null || closetName.isEmpty) {
      errors['closetName'] = 'closetNameCannotBeEmpty'; // Key for empty closet name
    } else if (closetName == 'cc_closet') {
      errors['closetName'] = 'reservedClosetNameError'; // Key for reserved key
    }

    if (closetType == 'disappear') {
      if (validDate == null) {
        errors['validDate'] = 'validDateRequiredForDisappearCloset'; // Key for missing valid date
      } else if (validDate.isBefore(DateTime.now()) || validDate.isAtSameMomentAs(DateTime.now())) {
        errors['validDate'] = 'dateCannotBeTodayOrEarlier'; // Key for invalid date
      }
    }


    return errors;
  }
}
