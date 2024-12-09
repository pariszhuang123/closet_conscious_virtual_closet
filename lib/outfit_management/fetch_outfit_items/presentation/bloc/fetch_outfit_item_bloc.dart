import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utilities/logger.dart';
import '../../../core/data/services/outfits_fetch_services.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../core/data/services/outfits_save_services.dart';
import '../../../core/outfit_enums.dart';
import '../../../../core/core_enums.dart';

part 'fetch_outfit_item_event.dart';
part 'fetch_outfit_item_state.dart';

class FetchOutfitItemBloc extends Bloc<FetchOutfitItemEvent, FetchOutfitItemState> {
  final CustomLogger logger;
  final OutfitFetchService outfitFetchService;
  final OutfitSaveService outfitSaveService;

  FetchOutfitItemBloc(this.outfitFetchService, this.outfitSaveService)
      : logger = CustomLogger('CreateOutfitItemBlocLogger'),
        super(FetchOutfitItemState.initial()) {
    on<FetchMoreItemsEvent>(_onFetchMoreItems);
    on<SelectCategoryEvent>(_onSelectCategory);
  }

  Future<void> _onSelectCategory(SelectCategoryEvent event, Emitter<FetchOutfitItemState> emit) async {
    logger.d('Selecting category: ${event.category}');
    emit(state.copyWith(
      currentCategory: event.category,
      saveStatus: SaveStatus.inProgress,
      categoryPages: {...state.categoryPages, event.category: 0},
      categoryHasReachedMax: {...state.categoryHasReachedMax, event.category: false},
    ));

    try {
      // Fetch items filtered by the selected category starting from pages 0
      final items = await outfitFetchService.fetchCreateOutfitItemsRPC(0, event.category);

      final updatedCategoryItems = {
        ...state.categoryItems,
        event.category: items,
      };

      emit(state.copyWith(
        categoryItems: updatedCategoryItems,
        categoryPages: {...state.categoryPages, event.category: 1},
        categoryHasReachedMax: {...state.categoryHasReachedMax, event.category: items.length < 9},
        saveStatus: SaveStatus.success,
      ));
    } catch (error) {
      logger.e('Error fetching items for category ${event.category}: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }

  Future<void> _onFetchMoreItems(FetchMoreItemsEvent event, Emitter<FetchOutfitItemState> emit) async {
    final currentCategory = state.currentCategory;

    // Check if max has been reached for the current category
    if (state.categoryHasReachedMax[currentCategory] == true) {
      logger.d('No more items to fetch for category: $currentCategory. Reached max limit.');
      return;
    }

    final currentPage = state.categoryPages[currentCategory] ?? 0;

    try {
      // Fetch more items, specifying pages but not filtering here; do category filtering afterward
      final allNewItems = await outfitFetchService.fetchCreateOutfitItemsRPC(currentPage, currentCategory);

      // Filter items by current category
      final newItems = allNewItems
          .where((item) => item.itemType.toLowerCase() == currentCategory.toString().split('.').last.toLowerCase())
          .toList();

      logger.d('Fetched ${newItems.length} new items for category $currentCategory on pages $currentPage');

      if (newItems.isEmpty) {
        emit(state.copyWith(
          categoryHasReachedMax: {...state.categoryHasReachedMax, currentCategory: true},
        ));
      } else {
        final filteredNewItems = newItems.where((newItem) =>
        !state.categoryItems[currentCategory]!.any((existingItem) => existingItem.itemId == newItem.itemId)
        ).toList();

        final updatedCategoryItems = {
          ...state.categoryItems,
          currentCategory: [...state.categoryItems[currentCategory]!, ...filteredNewItems],
        };

        emit(state.copyWith(
          categoryItems: updatedCategoryItems,
          categoryPages: {...state.categoryPages, currentCategory: currentPage + 1},
          saveStatus: SaveStatus.success,
        ));

      }
    } catch (error) {
      logger.e('Error fetching more items for category $currentCategory: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }
}
