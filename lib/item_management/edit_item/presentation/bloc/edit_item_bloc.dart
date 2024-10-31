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
  final CustomLogger _logger = CustomLogger('ItemEditBloc');

  EditItemBloc({
    required this.itemId,
  }) : _itemSaveService = ItemSaveService(),
        _itemFetchService = ItemFetchService(),
        super(EditItemInitial()) {
    // Register event handlers
    on<LoadItemEvent>(_onLoadItem);
    on<MetadataChangedEvent>(_onMetadataChanged);
    on<SubmitFormEvent>(_onSubmitForm);
  }

  // Handler for loading item from Supabase
  Future<void> _onLoadItem(LoadItemEvent event,
      Emitter<EditItemState> emit) async {
    emit(EditItemLoading());
    _logger.i("Loading item with ID: ${event.itemId}");

    try {
      // Fetch item details using the ItemFetchService
      final itemData = await _itemFetchService.fetchItemDetails(event.itemId);
      _logger.d("Item loaded successfully: $itemData");
      emit(EditItemLoaded(itemId: itemData.itemId, item: itemData));
    } catch (e) {
      _logger.e("Failed to load item: $e");
      emit(EditItemLoadFailure());
    }
  }

  // Handler for metadata changes
  void _onMetadataChanged(MetadataChangedEvent event, Emitter<EditItemState> emit) {
    if (_isValidStateForMetadataChange()) {
      final currentItemState = state is EditItemLoaded
          ? (state as EditItemLoaded).item
          : (state as EditItemMetadataChanged).updatedItem;

      // Reset fields based on the new itemType
      final updatedItem = currentItemState.copyWith(
        itemType: event.updatedItem.itemType,
        name: event.updatedItem.name,
        amountSpent: event.updatedItem.amountSpent,
        occasion: event.updatedItem.occasion,
        season: event.updatedItem.season,
        colour: event.updatedItem.colour,
        colourVariations: event.updatedItem.colourVariations ?? currentItemState.colourVariations,

        // Reset irrelevant fields based on itemType
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

      // Emit the updated state with the new metadata
      emit(EditItemMetadataChanged(updatedItem: updatedItem));
    } else {
      _logger.w("Attempted to change metadata in invalid state.");
      emit(EditItemLoadFailure());
    }
  }

  // Handler for submitting the form
  Future<void> _onSubmitForm(SubmitFormEvent event, Emitter<EditItemState> emit) async {
    if (state is EditItemMetadataChanged) {
      final metadataChangedState = state as EditItemMetadataChanged;
      final updatedItem = metadataChangedState.updatedItem;

      emit(EditItemSubmitting(itemId: updatedItem.itemId));
      _logger.i("Submitting form for item ID: ${updatedItem.itemId}");


      try {
        // Call the ItemSaveService to save the edited metadata
        final success = await _itemSaveService.editItemMetadata(
          itemId: updatedItem.itemId,
          itemType: updatedItem.itemType.join(", "),
          name: updatedItem.name,
          amountSpent: updatedItem.amountSpent,
          occasion: updatedItem.occasion.join(", "),
          season: updatedItem.season.join(", "),
          colour: updatedItem.colour.join(", "),
          clothingType: updatedItem.clothingType?.join(", "),
          clothingLayer: updatedItem.clothingLayer?.join((", ")),
          shoesType: updatedItem.shoesType?.join(", "),
          accessoryType: updatedItem.accessoryType?.join(", "),
          colourVariations: updatedItem.colourVariations?.join(", ") ?? 'cc_none',
        );

        if (success) {
          _logger.i("Item metadata updated successfully.");
          emit(EditItemUpdateSuccess());
        } else {
          _logger.e("Item metadata update failed.");
          emit(EditItemUpdateFailure("Metadata update failed due to an unknown error."));
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
    return state is EditItemLoaded || state is EditItemMetadataChanged;
  }
}
