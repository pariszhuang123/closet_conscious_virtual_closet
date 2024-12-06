import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/data/services/item_fetch_service.dart';
import '../../../../core/data/services/item_save_service.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/items_enums.dart';
import '../../../../../core/data/item_selector.dart';


part 'create_multi_closet_event.dart';
part 'create_multi_closet_state.dart';

class CreateMultiClosetBloc extends Bloc<CreateMultiClosetEvent, CreateMultiClosetState>
    implements ItemSelector {
  final ItemFetchService itemFetchService;
  final ItemSaveService itemSaveService;

  final CustomLogger logger = CustomLogger('CreateMultiClosetBloc');


  CreateMultiClosetBloc(this.itemSaveService, this.itemFetchService)
      : super(const CreateMultiClosetState()) {
    logger.i('Initializing CreateMultiClosetBloc');
    on<FieldChanged>(_onFieldChanged);
    on<ToggleSelectItem>(_onToggleSelectItem);
    on<ClearSelectedItems>(_onClearSelectedItems);
    on<ValidateClosetDetails>(_onValidateClosetDetails);
    on<CreateMultiClosetRequested>(_onCreateMultiClosetRequested);
  }

  @override
  List<String> get selectedItemIds => state.selectedItemIds;

  @override
  void toggleItemSelection(String itemId) {
    logger.d('Toggling item selection for itemId: $itemId');
    add(ToggleSelectItem(itemId));
  }

  void _onFieldChanged(FieldChanged event, Emitter<CreateMultiClosetState> emit) {
    logger.i('Field changed: ${event.fieldName} = ${event.value}');
    emit(state.copyWith(
      closetName: event.fieldName == 'closetName' ? event.value as String : null,
      closetType: event.fieldName == 'closetType' ? event.value as String : null,
      isPublic: event.fieldName == 'isPublic' ? event.value as bool : null,
      monthsLater: event.fieldName == 'monthsLater' ? event.value as int? : null,
    ));
    logger.d('State updated: ${state.toString()}');
  }

  void _onToggleSelectItem(ToggleSelectItem event, Emitter<CreateMultiClosetState> emit) {
    logger.i('Toggling selection for itemId: ${event.itemId}');
    final updatedSelectedItemIds = List<String>.from(state.selectedItemIds);

    if (updatedSelectedItemIds.contains(event.itemId)) {
      logger.d('Item deselected: ${event.itemId}');
      updatedSelectedItemIds.remove(event.itemId);
    } else {
      logger.d('Item selected: ${event.itemId}');
      updatedSelectedItemIds.add(event.itemId);
    }

    emit(state.copyWith(
      selectedItemIds: updatedSelectedItemIds,
      hasSelectedItems: updatedSelectedItemIds.isNotEmpty,
    ));
    logger.d('Updated selected items: $updatedSelectedItemIds');
  }

  void _onClearSelectedItems(ClearSelectedItems event, Emitter<CreateMultiClosetState> emit) {
    logger.i('Clearing all selected items');
    emit(state.copyWith(selectedItemIds: [], hasSelectedItems: false));
    logger.d('State after clearing items: ${state.toString()}');
  }

  void _onValidateClosetDetails(
      ValidateClosetDetails event, Emitter<CreateMultiClosetState> emit) {
    logger.i('Validating closet details for closetName: ${state.closetName}');
    final errorKeys = <String, String>{};

    if (state.closetName.isEmpty) {
      errorKeys['closetName'] = "closet_name_required";
    }
    if (state.selectedItemIds.isEmpty) errorKeys['selectedItems'] = "item_selection_required";

    if (state.closetType == 'permanent') {
      if (state.isPublic == null) {
        errorKeys['isPublic'] = "is_public_required_for_permanent";
      }
    } else if (state.closetType == 'temporary') {
      if (state.monthsLater == null || state.monthsLater! < 0) {
        errorKeys['monthsLater'] = "valid_months_later_required_for_temporary";
      }
    }

    if (errorKeys.isEmpty) {
      logger.i('Validation passed');
      emit(state.copyWith(errorKeys: null, status: ClosetStatus.valid));
    } else {
      logger.w('Validation failed: ${errorKeys.values.join(", ")}');
      emit(state.copyWith(errorKeys: errorKeys, status: ClosetStatus.invalid));
    }
  }

  Future<void> _onCreateMultiClosetRequested(
      CreateMultiClosetRequested event, Emitter<CreateMultiClosetState> emit) async {
    emit(state.copyWith(status: ClosetStatus.loading));
    logger.i('Creating multi-closet: ${state.closetName}');

    if (!state.hasSelectedItems || state.closetName.isEmpty) {
      emit(state.copyWith(status: ClosetStatus.failure, error: "Validation failed"));
      return;
    }

    try {
      await itemSaveService.addMultiCloset(
        closetName: state.closetName,
        closetType: state.closetType,
        itemIds: state.selectedItemIds,
        monthsLater: state.monthsLater,
        isPublic: state.isPublic,
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
