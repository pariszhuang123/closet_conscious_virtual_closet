import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../utilities/logger.dart';
import '../../../../outfit_management/core/outfit_enums.dart';

class GridPaginationCubit<T> extends Cubit<void> {
  late final PagingController<int, T> pagingController;

  final Future<List<T>> Function({
  required int pageKey,
  OutfitItemCategory? category,
  }) _backendFetch;

  final CustomLogger _logger;
  OutfitItemCategory? _currentCategory;

  GridPaginationCubit({
    required Future<List<T>> Function({
    required int pageKey,
    OutfitItemCategory? category,
    }) fetchPage,
    OutfitItemCategory? initialCategory,
    String tag = 'GridPaginationCubit',
  })  : _backendFetch = fetchPage,
        _currentCategory = initialCategory,
        _logger = CustomLogger(tag),
        super(null) {
    pagingController = PagingController<int, T>(
      getNextPageKey: (state) {
        final pages = state.pages ?? [];
        if (pages.isEmpty) return 0;
        final pageSize = pages.first.length;
        final lastPage = pages.last;
        return lastPage.length < pageSize ? null : pages.length;
      },
      fetchPage: _fetchWithLogging,
    );

    pagingController.addListener(() {
      final err = pagingController.value.error;
      if (err != null) {
        _logger.e('PagingController error: $err');
      }
    });

    _logger.i('GridPaginationCubit initialized with category: $_currentCategory');
    pagingController.refresh(); // initial fetch
  }

  Future<List<T>> _fetchWithLogging(int pageKey) async {
    _logger.i('Fetching page $pageKey with category $_currentCategory...');
    try {
      final items = await _backendFetch(pageKey: pageKey, category: _currentCategory);
      _logger.i('Fetched ${items.length} items on page $pageKey');
      return items;
    } catch (e, stack) {
      _logger.e('Error fetching page $pageKey: $e\n$stack');
      rethrow;
    }
  }

  /// Updates the current category and refreshes the pagination
  void updateCategory(OutfitItemCategory? newCategory) {
    if (newCategory == _currentCategory) return;
    _logger.d('Updating category from $_currentCategory to $newCategory');
    _currentCategory = newCategory;
    pagingController.refresh(); // triggers a new fetch with the updated category
  }

  @override
  Future<void> close() {
    _logger.i('Disposing GridPaginationCubit');
    pagingController.dispose();
    return super.close();
  }
}
