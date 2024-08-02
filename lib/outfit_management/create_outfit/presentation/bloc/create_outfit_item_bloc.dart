import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/config/supabase_config.dart';
import '../../../../core/utilities/logger.dart';

part 'create_outfit_item_event.dart';
part 'create_outfit_item_state.dart';

class CreateOutfitItemBloc extends Bloc<CreateOutfitItemEvent, CreateOutfitItemState> {
  final SupabaseClient supabaseClient;
  final CustomLogger logger = CustomLogger('CreateOutfitItemBloc');

  CreateOutfitItemBloc(this.supabaseClient) : super(const CreateOutfitItemState()) {
    on<SelectItemEvent>(_onSelectItem);
    on<SaveOutfitEvent>(_onSaveOutfit);
  }

  void _onSelectItem(SelectItemEvent event,
      Emitter<CreateOutfitItemState> emit) {
    final updatedSelectedItemIds = Map<OutfitItemCategory, List<String>>.from(
        state.selectedItemIds);
    final selectedItems = updatedSelectedItemIds[event.category] ?? [];
    if (selectedItems.contains(event.itemId)) {
      selectedItems.remove(event.itemId);
    } else {
      selectedItems.add(event.itemId);
    }
    updatedSelectedItemIds[event.category] = selectedItems;
    emit(state.copyWith(selectedItemIds: updatedSelectedItemIds,
        currentCategory: event.category));
  }

  Future<void> _onSaveOutfit(SaveOutfitEvent event,
      Emitter<CreateOutfitItemState> emit) async {
    try {
      final response = await SupabaseConfig.client.rpc(
          'save_outfit_items', params: {
        'p_selected_items': event.selectedItemIds.values.expand((i) => i)
            .toList()
      });

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
}