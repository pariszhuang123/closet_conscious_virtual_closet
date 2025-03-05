import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../data/services/core_save_services.dart';

part 'navigate_to_item_state.dart';

class NavigateToItemCubit extends Cubit<NavigateToItemState> {
  final CoreSaveService coreSaveService;
  final CustomLogger _logger = CustomLogger('NavigateToItemCubit');

  NavigateToItemCubit(this.coreSaveService) : super(NavigateToItemInitial());

  Future<void> navigateToItem(String itemId) async {
    _logger.i("Navigating to analytics for item: $itemId");
    emit(NavigateToItemLoading());

    try {
      final success = await coreSaveService.navigateToItemAnalytics(itemId: itemId);

      if (success) {
        _logger.i("Successfully navigated to item analytics.");
        emit(NavigateToItemSuccess());
      } else {
        _logger.w("Failed to navigate to item analytics.");
        emit(NavigateToItemFailure("Failed to navigate to item analytics."));
      }
    } catch (e) {
      _logger.e("Error navigating to item analytics: $e");
      emit(NavigateToItemFailure("An error occurred: $e"));
    }
  }
}
