import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data/models/closet_item_detailed.dart';
import '../../../core/data/services/item_fetch_service.dart';
import '../../../core/data/services/item_save_service.dart';


part 'edit_item_event.dart';
part 'edit_item_state.dart';

class EditItemBloc extends Bloc<EditItemEvent, EditItemState> {
  final String itemId;
  final ItemSaveService _itemSaveService;
  final ItemFetchService _itemFetchService;

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

    try {
      // Fetch item details using the ItemFetchService
      final itemData = await _itemFetchService.fetchItemDetails(event.itemId);
      emit(EditItemLoaded(itemId: itemData.itemId, item: itemData));
    } catch (e) {
      emit(EditItemLoadFailure());
    }
  }

  void _onMetadataChanged(MetadataChangedEvent event, Emitter<EditItemState> emit) {
    // Ensure state is EditItemLoaded or EditItemMetadataChanged
    if (state is EditItemLoaded || state is EditItemMetadataChanged) {
      final currentItemState = state is EditItemLoaded
          ? (state as EditItemLoaded).item
          : (state as EditItemMetadataChanged).updatedItem;

      // Create a new instance of ClosetItemDetailed with the updated fields
      final updatedItem = currentItemState.copyWith(
        itemType: event.updatedItem.itemType,
        name: event.updatedItem.name,
        amountSpent: event.updatedItem.amountSpent,
        occasion: event.updatedItem.occasion,
        season: event.updatedItem.season,
        colour: event.updatedItem.colour,
        colourVariations: event.updatedItem.colourVariations ?? currentItemState.colourVariations,
        clothingType: event.updatedItem.clothingType ?? currentItemState.clothingType,
        clothingLayer: event.updatedItem.clothingLayer ?? currentItemState.clothingLayer,
        shoesType: event.updatedItem.shoesType ?? currentItemState.shoesType,
        accessoryType: event.updatedItem.accessoryType ?? currentItemState.accessoryType,
      );

      // Emit the updated state with the new metadata
      emit(EditItemMetadataChanged(updatedItem: updatedItem));
    } else {
      emit(EditItemLoadFailure());
    }
  }

  Future<void> _onSubmitForm(SubmitFormEvent event,
      Emitter<EditItemState> emit) async {
    // Only handle if the state is EditItemMetadataChanged, meaning changes have been made
    if (state is EditItemMetadataChanged) {
      final metadataChangedState = state as EditItemMetadataChanged;
      final updatedItem = metadataChangedState.updatedItem; // Access the updated item

      emit(EditItemSubmitting(itemId: updatedItem.itemId));

      // Validate form data
      if (updatedItem.name.isEmpty ||
          updatedItem.amountSpent <= 0) {
        emit(EditItemValidationFailed());
        return;
      }

      try {
        // Call the ItemSaveService to save the edited metadata
        final success = await _itemSaveService.editItemMetadata(
          itemId: updatedItem.itemId,
          itemType: updatedItem.itemType,
          name: updatedItem.name,
          amountSpent: updatedItem.amountSpent,
          occasion: updatedItem.occasion,
          season: updatedItem.season,
          colour: updatedItem.colour,
          clothingType: updatedItem.clothingType,
          clothingLayer: updatedItem.clothingLayer,
          shoesType: updatedItem.shoesType,
          accessoryType: updatedItem.accessoryType,
          colourVariations: updatedItem.colourVariations ??
              'cc_none', // Default if null
        );

        if (success) {
          emit(EditItemUpdateSuccess());
        } else {
          emit(EditItemUpdateFailure());
        }
      } catch (e) {
        emit(EditItemUpdateFailure());
      }
    } else {
      emit(
          EditItemLoadFailure()); // Should never happen if button is hidden until changes are made
    }
  }
}