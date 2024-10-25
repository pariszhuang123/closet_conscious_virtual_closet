import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/data/services/item_fetch_service.dart';
import '../../../core/data/models/closet_item_minimal.dart';
import '../../../../core/utilities/logger.dart'; // Import the CustomLogger

part 'view_items_event.dart';
part 'view_items_state.dart';

class ViewItemsBloc extends Bloc<ViewItemsEvent, ViewItemsState> {
  final ItemFetchService _itemFetchService;
  final CustomLogger _logger = CustomLogger('ViewItemsBloc'); // Initialize CustomLogger
  bool _hasMoreItems = true; // Keep track if there are more items to load
  bool _isFetching = false; // Prevent multiple fetches at once

  ViewItemsBloc(this._itemFetchService) : super(ItemsLoading()) {
    // Using on<FetchItemsEvent> for handling fetch events
    on<FetchItemsEvent>(_onFetchItems);
  }

  // Handler for FetchItemsEvent
  Future<void> _onFetchItems(FetchItemsEvent event, Emitter<ViewItemsState> emit) async {
    // Prevent further fetch if we're already fetching
    if (_isFetching || !_hasMoreItems) {
      return;
    }

    _isFetching = true; // Mark fetching as true
    final currentState = state;

    // Log the start of the fetch process
    _logger.i('Fetching items for page ${event.page} with batch size ${event.batchSize}');

    // Only emit loading state if it's the first time loading
    if (currentState is! ItemsLoaded || event.page == 0) {
      emit(ItemsLoading());
      _logger.i('Emitted ItemsLoading state');
    }

    try {
      final items = await _itemFetchService.fetchItems(event.page, event.batchSize);

      // If fewer items are returned than requested, assume no more items
      if (items.length < event.batchSize) {
        _hasMoreItems = false;
        _logger.i('No more items to fetch. Disabling further fetching.');
      }

      if (currentState is ItemsLoaded) {
        // Log the success of fetching and appending items
        _logger.i('Fetched ${items.length} items, appending to the existing list');

        // If items are already loaded, append the new items to the existing list
        final updatedItems = List<ClosetItemMinimal>.from(currentState.items)..addAll(items);
        emit(ItemsLoaded(updatedItems, event.page + 1)); // Increment page after fetch
        _logger.i('Emitted ItemsLoaded with ${updatedItems.length} total items');
      } else {
        // Log the success of the first fetch
        _logger.i('Fetched ${items.length} items, emitting ItemsLoaded');
        // If no items are loaded yet, emit the new items
        emit(ItemsLoaded(items, event.page + 1)); // Set next page
      }
    } catch (e) {
      // Log the error
      _logger.e('Error fetching items: $e');
      emit(ItemsError(e.toString()));
    } finally {
      _isFetching = false; // Reset fetching state
    }
  }
}
