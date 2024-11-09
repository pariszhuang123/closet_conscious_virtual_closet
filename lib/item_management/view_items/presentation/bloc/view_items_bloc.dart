import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/data/services/item_fetch_service.dart';
import '../../../core/data/models/closet_item_minimal.dart';
import '../../../../core/utilities/logger.dart';

part 'view_items_event.dart';
part 'view_items_state.dart';

class ViewItemsBloc extends Bloc<ViewItemsEvent, ViewItemsState> {
  final ItemFetchService _itemFetchService;
  final CustomLogger _logger;
  bool _hasMoreItems = true;
  bool _isFetching = false;

  ViewItemsBloc({
    ItemFetchService? itemFetchService,
    CustomLogger? logger,
  })  : _itemFetchService = itemFetchService ?? ItemFetchService(),
        _logger = logger ?? CustomLogger('ViewItemsBloc'),
        super(ItemsLoading()) {
    on<FetchItemsEvent>(_onFetchItems);
  }

  // Handler for FetchItemsEvent
  Future<void> _onFetchItems(FetchItemsEvent event, Emitter<ViewItemsState> emit) async {
    _logger.i('Received FetchItemsEvent for pages: ${event.page}');
    _logger.i('Current state: $state');
    _logger.i('Flags - _isFetching: $_isFetching, _hasMoreItems: $_hasMoreItems');


    // Exit early if currently fetching or if no more items are available
    if (_isFetching || !_hasMoreItems) {
      _logger.i('Fetching aborted. Either already fetching or no more items.');
      return;
    }

    // Set _isFetching to prevent duplicate fetches
    _isFetching = true;

    // Emit loading state only if it's a fresh fetch (pages 0)
    if (state is! ItemsLoaded || event.page == 0) {
      emit(ItemsLoading());
      _logger.i('Emitted ItemsLoading state');
    }

    try {
      // Fetch items with the current pages
      final items = await _itemFetchService.fetchItems(event.page);

      // Update _hasMoreItems based on the result
      if (items.isEmpty) {
        _hasMoreItems = false;
        _logger.i('No more items to fetch. _hasMoreItems set to false.');
      }

      // Update state with new or appended items
      if (state is ItemsLoaded) {
        final updatedItems = List<ClosetItemMinimal>.from((state as ItemsLoaded).items)..addAll(items);
        emit(ItemsLoaded(updatedItems, event.page + 1));
        _logger.i('Emitted ItemsLoaded with ${updatedItems.length} total items');
      } else {
        emit(ItemsLoaded(items, event.page + 1));
        _logger.i('Emitted ItemsLoaded with initial ${items.length} items');
      }
    } catch (e) {
      _logger.e('Error fetching items: $e');
      emit(ItemsError(e.toString()));
    } finally {
      // Always reset _isFetching, regardless of success or failure
      _isFetching = false;
      _logger.i('Resetting _isFetching to false');
    }
  }
}
