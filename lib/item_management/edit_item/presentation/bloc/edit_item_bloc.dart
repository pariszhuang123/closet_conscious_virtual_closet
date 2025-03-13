import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data/models/closet_item_detailed.dart';
import '../../../core/data/services/item_fetch_service.dart';
import '../../../core/data/services/item_save_service.dart';
import '../../../../core/utilities/logger.dart';

part 'edit_item_event.dart';
part 'edit_item_state.dart';

class EditItemBloc extends Bloc<EditItemEvent, EditItemState> {
  final String itemId;
  final ItemSaveService _itemSaveService;
  final ItemFetchService _itemFetchService;
  final CustomLogger _logger;

  EditItemBloc({
    required this.itemId,
    ItemSaveService? itemSaveService,
    ItemFetchService? itemFetchService,
    CustomLogger? logger,
  })
      : _itemSaveService = itemSaveService ?? ItemSaveService(),
        _itemFetchService = itemFetchService ?? ItemFetchService(),
        _logger = logger ?? CustomLogger('ItemEditBloc'),
        super(EditItemInitial()) {
    // Register event handlers
    on<LoadItemEvent>(_onLoadItem);
    on<MetadataChangedEvent>(_onMetadataChanged);
    on<ValidateFormEvent>(_onValidateForm); // New validation-only event.
    on<SubmitFormEvent>(_onSubmitForm);
  }

  // Handler for loading item from Supabase
  Future<void> _onLoadItem(LoadItemEvent event,
      Emitter<EditItemState> emit) async {
    emit(EditItemLoading());
    _logger.i("Loading item with ID: ${event.itemId}");

    try {
      final itemData = await _itemFetchService.fetchItemDetails(event.itemId);
      _logger.d("Item loaded successfully: $itemData");
      emit(EditItemLoaded(itemId: itemData.itemId, item: itemData));
    } catch (e) {
      _logger.e("Failed to load item: $e");
      emit(EditItemLoadFailure());
    }
  }

  // Handler for metadata changes
  void _onMetadataChanged(MetadataChangedEvent event,
      Emitter<EditItemState> emit) {
    if (_isValidStateForMetadataChange()) {
      final currentItemState = state is EditItemValidationFailure
          ? (state as EditItemValidationFailure).updatedItem
          : state is EditItemLoaded
            ? (state as EditItemLoaded).item
            : (state as EditItemMetadataChanged).updatedItem;

      final updatedItem = currentItemState.copyWith(
        itemType: event.updatedItem.itemType,
        name: event.updatedItem.name,
        amountSpent: event.updatedItem.amountSpent,
        occasion: event.updatedItem.occasion,
        season: event.updatedItem.season,
        colour: event.updatedItem.colour,
        colourVariations: event.updatedItem.colourVariations ??
            currentItemState.colourVariations,
        clothingType: event.updatedItem.itemType.contains('clothing')
            ? event.updatedItem.clothingType ?? []
            : [],
        clothingLayer: event.updatedItem.itemType.contains('clothing')
            ? event.updatedItem.clothingLayer
            : null,
        shoesType: event.updatedItem.itemType.contains('shoes')
            ? (event.updatedItem.shoesType ?? [])
            : [],
        accessoryType: event.updatedItem.itemType.contains('accessory')
            ? (event.updatedItem.accessoryType ?? [])
            : [],
      );

      _logger.d("Item metadata changed: $updatedItem");
      emit(EditItemMetadataChanged(updatedItem: updatedItem));
    } else {
      _logger.w("Attempted to change metadata in invalid state.");
      emit(EditItemLoadFailure());
    }
  }

  // New handler: Validate interdependent fields then submit
  Future<void> _onValidateForm(ValidateFormEvent event, Emitter<EditItemState> emit) async {
    final item = event.updatedItem;
    Map<String, String> tempErrors = {};

    // Interdependent validation rules:
    if (item.itemType.contains('clothing')) {
      if (item.clothingType == null || item.clothingType!.isEmpty) {
        tempErrors['clothing_type'] = "Clothing type is required.";
      }
      if (item.clothingLayer == null || item.clothingLayer!.isEmpty) {
        tempErrors['clothing_layer'] = "Clothing layer is required.";
      }
    } else if (item.itemType.contains('accessory')) {
      if (item.accessoryType == null || item.accessoryType!.isEmpty) {
        tempErrors['accessory_type'] = "Accessory type is required.";
      }
    } else if (item.itemType.contains('shoes')) {
      if (item.shoesType == null || item.shoesType!.isEmpty) {
        tempErrors['shoes_type'] = "Shoes type is required.";
      }
    }

    if (!item.colour.contains('black') && !item.colour.contains('white')) {
      if (item.colourVariations == null || item.colourVariations!.isEmpty) {
        tempErrors['colour_variations'] = "Colour variation is required.";
      }
    }

    if (tempErrors.isNotEmpty) {
      _logger.w('Interdependent validation failed: $tempErrors');
      emit(EditItemValidationFailure(updatedItem: item, validationErrors: tempErrors));
      return;
    }

    _logger.i("Validation succeeded for item ID: ${item.itemId}");
    emit(EditItemValidationSuccess(validatedItem: item));
  }



// Handler for submitting the form (legacy handler, if needed)
  Future<void> _onSubmitForm(SubmitFormEvent event,
      Emitter<EditItemState> emit) async {
    if (state is EditItemValidationSuccess) {
      final metadataChangedState = state as EditItemValidationSuccess;
      final updatedItem = metadataChangedState.validatedItem;
      emit(EditItemSubmitting(itemId: updatedItem.itemId));
      _logger.i("Submitting form for item ID: ${updatedItem.itemId}");

      try {
        final success = await _itemSaveService.editItemMetadata(
          itemId: updatedItem.itemId,
          itemType: updatedItem.itemType.join(", "),
          name: updatedItem.name,
          amountSpent: updatedItem.amountSpent,
          occasion: updatedItem.occasion.join(", "),
          season: updatedItem.season.join(", "),
          colour: updatedItem.colour.join(", "),
          clothingType: updatedItem.clothingType?.join(", "),
          clothingLayer: updatedItem.clothingLayer?.join(", "),
          shoesType: updatedItem.shoesType?.join(", "),
          accessoryType: updatedItem.accessoryType?.join(", "),
          colourVariations: updatedItem.colourVariations?.join(", ") ??
              'cc_none',
        );

        if (success) {
          _logger.i("Item metadata updated successfully.");
          emit(EditItemUpdateSuccess());
        } else {
          _logger.e("Item metadata update failed.");
          emit(EditItemUpdateFailure(
              "Metadata update failed due to an unknown error."));
        }
      } catch (e) {
        _logger.e("Error during item update: $e");
        emit(EditItemUpdateFailure(e.toString()));
      }
    } else {
      _logger.w("Form submission attempted in invalid state.");
      emit(EditItemLoadFailure());
    }
  }

  // Helper method to validate state before metadata change
  bool _isValidStateForMetadataChange() {
    return state is EditItemLoaded || state is EditItemMetadataChanged || state is EditItemValidationFailure;
  }
}
