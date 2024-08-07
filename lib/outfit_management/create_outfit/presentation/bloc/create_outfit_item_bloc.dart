import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../../outfit_management/core/data/services/outfits_fetch_service.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';

part 'create_outfit_item_event.dart';
part 'create_outfit_item_state.dart';

class CreateOutfitItemBloc extends Bloc<CreateOutfitItemEvent, CreateOutfitItemState> {
  final SupabaseClient supabaseClient = SupabaseConfig.client;

  final CustomLogger logger = CustomLogger('CreateOutfitItemBloc');

  CreateOutfitItemBloc() : super(CreateOutfitItemState.initial()) {
    on<SelectItemEvent>(_onSelectItem);
    on<DeselectItemEvent>(_onDeselectItem);
    on<SaveOutfitEvent>(_onSaveOutfit);
    on<SelectCategoryEvent>(_onSelectCategory);
  }

  void _onSelectItem(SelectItemEvent event, Emitter<CreateOutfitItemState> emit) {
    final updatedSelectedItemIds = Map<OutfitItemCategory, List<String>>.from(state.selectedItemIds);
    final selectedItems = List<String>.from(updatedSelectedItemIds[event.category] ?? []);
    if (!selectedItems.contains(event.itemId)) {
      selectedItems.add(event.itemId);
    }
    updatedSelectedItemIds[event.category] = selectedItems;
    emit(state.copyWith(selectedItemIds: updatedSelectedItemIds));
    logger.d('Selected item ID: ${event.itemId} in category: ${event.category}');
  }

  void _onDeselectItem(DeselectItemEvent event, Emitter<CreateOutfitItemState> emit) {
    final updatedSelectedItemIds = Map<OutfitItemCategory, List<String>>.from(state.selectedItemIds);
    final selectedItems = List<String>.from(updatedSelectedItemIds[event.category] ?? []);
    if (selectedItems.contains(event.itemId)) {
      selectedItems.remove(event.itemId);
    }
    updatedSelectedItemIds[event.category] = selectedItems;
    emit(state.copyWith(selectedItemIds: updatedSelectedItemIds));
    logger.d('Deselected item ID: ${event.itemId} in category: ${event.category}');
  }

  Future<void> _onSaveOutfit(SaveOutfitEvent event, Emitter<CreateOutfitItemState> emit) async {
    emit(state.copyWith(saveStatus: SaveStatus.inProgress));
    try {
      final allSelectedItems = state.selectedItemIds.values.expand((i) => i).toList();

      // Log the allSelectedItems for debugging
      logger.i('All selected item IDs: $allSelectedItems');

      final response = await supabaseClient.rpc(
        'save_outfit_items',
        params: {
          'p_selected_items': allSelectedItems,
        },
      );

      // Log the response data for debugging
      logger.i('Response data: ${response.data}');

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['status'] == 'error') {
        throw responseData['message'];
      }

      emit(state.copyWith(saveStatus: SaveStatus.success));
    } catch (error) {
      logger.e('Error saving selected items: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }

  Future<void> _onSelectCategory(SelectCategoryEvent event, Emitter<CreateOutfitItemState> emit) async {
    emit(state.copyWith(currentCategory: event.category, saveStatus: SaveStatus.inProgress));

    try {
      final items = await fetchCreateOutfitItems(event.category, 0, 10); // You can adjust the batch size as needed
      emit(state.copyWith(
        items: items,
        saveStatus: SaveStatus.success,
      ));
      logger.d('Fetched items for category: ${event.category}');
    } catch (error) {
      logger.e('Error fetching items for category ${event.category}: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }
}
