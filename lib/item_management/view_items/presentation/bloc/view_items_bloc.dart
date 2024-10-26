import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/data/services/item_fetch_service.dart';
import '../../../core/data/models/closet_item_minimal.dart';
import '../../../../core/utilities/logger.dart';

part 'view_items_event.dart';
part 'view_items_state.dart';

class ViewItemsBloc extends Bloc<ViewItemsEvent, ViewItemsState> {
  final ItemFetchService _itemFetchService;
  final CustomLogger _logger = CustomLogger('ViewItemsBloc');
  bool _hasMoreItems = true;
  bool _isFetching = false;

  ViewItemsBloc(this._itemFetchService) : super(ItemsLoading()) {
    on<FetchItemsEvent>(_onFetchItems);
  }

  // Handler for FetchItemsEvent
  Future<void> _onFetchItems(FetchItemsEvent event, Emitter<ViewItemsState> emit) async {
    if (_isFetching || !_hasMoreItems) return;

    _isFetching = true;
    final currentState = state;

    _logger.i('Fetching items for page ${event.page} using RPC');

    if (currentState is! ItemsLoaded || event.page == 0) {
      emit(ItemsLoading());
      _logger.i('Emitted ItemsLoading state');
    }

    try {
      // Call the fetchItems function, which now uses the RPC function
      final items = await _itemFetchService.fetchItems(event.page);

      // Check if there are fewer items than expected, indicating no more pages
      if (items.isEmpty) {
        _hasMoreItems = false;
        _logger.i('No more items to fetch. Disabling further fetching.');
      }

      if (currentState is ItemsLoaded) {
        _logger.i('Fetched ${items.length} items, appending to the existing list');
        final updatedItems = List<ClosetItemMinimal>.from(currentState.items)..addAll(items);
        emit(ItemsLoaded(updatedItems, event.page + 1));
        _logger.i('Emitted ItemsLoaded with ${updatedItems.length} total items');
      } else {
        _logger.i('Fetched ${items.length} items, emitting ItemsLoaded');
        emit(ItemsLoaded(items, event.page + 1));
      }
    } catch (e) {
      _logger.e('Error fetching items: $e');
      emit(ItemsError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }
}
