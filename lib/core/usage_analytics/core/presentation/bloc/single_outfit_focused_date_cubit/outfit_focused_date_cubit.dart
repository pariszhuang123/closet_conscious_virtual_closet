import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/logger.dart';
import '../../../../../data/services/core_save_services.dart';

part 'outfit_focused_date_state.dart';

class OutfitFocusedDateCubit extends Cubit<OutfitFocusedDateState> {
  final CoreSaveService coreSaveService;
  final CustomLogger _logger = CustomLogger('OutfitFocusedDateCubit');

  OutfitFocusedDateCubit(this.coreSaveService) : super(OutfitFocusedDateInitial());

  /// Set the focused date for a given outfit
  void setFocusedDateForOutfit(String outfitId) async {
    if (outfitId.isEmpty) {
      _logger.w("⚠️ Outfit ID is empty. Aborting.");
      emit(OutfitFocusedDateFailure("Invalid outfit ID"));
      return;
    }

    emit(OutfitFocusedDateLoading());

    try {
      _logger.i("🔄 Setting focused date for outfitId: $outfitId");

      final result = await coreSaveService.setFocusedDateForOutfit(outfitId);
      _logger.d("RPC result: $result");

      if (result) {
        _logger.i("Emitted Outfit FocusedDateSuccess");
        emit(OutfitFocusedDateSuccess(outfitId));
      } else {
        _logger.e("⚠️ Failed to set focused date.");
        emit(OutfitFocusedDateFailure("Failed to set focused date"));
      }
    } catch (e) {
      _logger.e("❌ Error setting focused date: $e");
      emit(OutfitFocusedDateFailure("Error setting focused date: $e"));
    }
  }
}
