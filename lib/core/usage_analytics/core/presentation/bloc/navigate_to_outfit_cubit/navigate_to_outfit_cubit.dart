import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../data/services/core_save_services.dart';

part 'navigate_to_outfit_state.dart';

class NavigateToOutfitCubit extends Cubit<NavigateToOutfitState> {
  final CoreSaveService coreSaveService;
  final CustomLogger _logger = CustomLogger('NavigateToOutfitCubit');

  NavigateToOutfitCubit(this.coreSaveService) : super(NavigateToOutfitInitial());

  Future<void> navigateToOutfit(String outfitId) async {
    _logger.i("Navigating to analytics for outfit: $outfitId");
    emit(NavigateToOutfitLoading());

    try {
      final success = await coreSaveService.navigateToOutfitAnalytics(outfitId: outfitId);

      if (success) {
        _logger.i("Successfully navigated to outfit analytics.");
        emit(NavigateToOutfitSuccess());
      } else {
        _logger.w("Failed to navigate to outfit analytics.");
        emit(NavigateToOutfitFailure("Failed to navigate to outfit analytics."));
      }
    } catch (e) {
      _logger.e("Error navigating to outfit analytics: $e");
      emit(NavigateToOutfitFailure("An error occurred: $e"));
    }
  }
}
