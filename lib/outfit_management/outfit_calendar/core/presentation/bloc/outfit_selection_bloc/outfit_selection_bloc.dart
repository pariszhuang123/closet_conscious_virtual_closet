import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/utilities/logger.dart';
import '../../../../../core/data/services/outfits_fetch_services.dart';

part 'outfit_selection_event.dart';
part 'outfit_selection_state.dart';

class OutfitSelectionBloc extends Bloc<OutfitSelectionEvent, OutfitSelectionState> {
  final OutfitFetchService outfitFetchService;
  final CustomLogger logger;
  List<String> selectedOutfitIds = [];

  OutfitSelectionBloc({required this.outfitFetchService, required this.logger})
      : super(OutfitSelectionInitial()) {
    on<BulkToggleOutfitSelectionEvent>(_onBulkToggleOutfitSelection);
    on<ToggleOutfitSelectionEvent>(_onToggleOutfitSelection);
    on<ClearOutfitSelectionEvent>(_onClearOutfitSelection);
    on<SelectAllOutfitsEvent>(_onSelectAllOutfits);
    on<FetchActiveItemsEvent>(_onFetchActiveItems);
  }

  void _onBulkToggleOutfitSelection(
      BulkToggleOutfitSelectionEvent event, Emitter<OutfitSelectionState> emit) {

    // Prevent duplicates and merge selections
    final Set<String> updatedSelections = {...selectedOutfitIds, ...event.outfitIds};

    selectedOutfitIds = updatedSelections.toList();

    logger.d('Bulk updated outfit selections: $selectedOutfitIds');
    emit(OutfitSelectionUpdated(List.from(selectedOutfitIds)));
  }

  void _onToggleOutfitSelection(
      ToggleOutfitSelectionEvent event, Emitter<OutfitSelectionState> emit) {
    if (selectedOutfitIds.contains(event.outfitId)) {
      selectedOutfitIds.remove(event.outfitId);
      logger.d('Deselected outfit ID: ${event.outfitId}');
    } else {
      selectedOutfitIds.add(event.outfitId);
      logger.d('Selected outfit ID: ${event.outfitId}');
    }
    emit(OutfitSelectionUpdated(List.from(selectedOutfitIds)));
  }


  void _onClearOutfitSelection(
      ClearOutfitSelectionEvent event, Emitter<OutfitSelectionState> emit) {
    selectedOutfitIds.clear();
    logger.i('Cleared all selected outfits');
    emit(const OutfitSelectionUpdated([])); // Emit empty selection state
  }

  void _onSelectAllOutfits(
      SelectAllOutfitsEvent event, Emitter<OutfitSelectionState> emit) {
    selectedOutfitIds = List.from(event.allOutfitIds);
    logger.i('Selected all outfits: $selectedOutfitIds');
    emit(OutfitSelectionUpdated(selectedOutfitIds));
  }

  Future<void> _onFetchActiveItems(
      FetchActiveItemsEvent event, Emitter<OutfitSelectionState> emit) async {
    if (event.selectedOutfitIds.isEmpty) {
      logger.w('No outfits selected for fetching active items');
      emit(const OutfitSelectionError('No outfits selected.'));
      return;
    }

    emit(ActiveItemsLoading());
    logger.d('Fetching active items for selected outfits: ${event.selectedOutfitIds}');

    try {
      final List<String> activeItemIds = await outfitFetchService.getActiveItemsFromCalendar(event.selectedOutfitIds);
      logger.i('Active items fetched successfully for selected outfits');
      emit(ActiveItemsFetched(activeItemIds));
    } catch (error) {
      logger.e('Error fetching active items: $error');
      emit(const OutfitSelectionError('Failed to fetch active items.'));
    }
  }
}
