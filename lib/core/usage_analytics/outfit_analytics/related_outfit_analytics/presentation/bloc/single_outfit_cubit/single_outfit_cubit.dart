import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../utilities/logger.dart';
import '../../../../../../../outfit_management/core/data/models/outfit_data.dart';
import '../../../../../../data/services/core_fetch_services.dart';

part 'single_outfit_state.dart';

class SingleOutfitCubit extends Cubit<SingleOutfitState> {
  final CoreFetchService coreFetchService;
  final CustomLogger _logger = CustomLogger('SingleOutfitCubit');

  SingleOutfitCubit(this.coreFetchService) : super(FetchOutfitInitial());

  /// Fetch a single outfit by its ID
  void fetchOutfit(String outfitId) async {
    if (outfitId.isEmpty) {
      _logger.w("⚠️ Outfit ID is empty. Aborting fetch.");
      emit(FetchOutfitFailure("Invalid outfit ID"));
      return;
    }

    emit(FetchOutfitLoading());

    try {
      _logger.i("🔄 Fetching outfit details for outfitId: $outfitId");

      final response = await coreFetchService.fetchOutfitById(outfitId);
      _logger.d("Raw RPC response for outfit: $response");

      // Validate response
      if (response.isEmpty || response['status'] != 'success') {
        _logger.e("⚠️ Unexpected response: $response");
        emit(FetchOutfitFailure("Failed to fetch outfit details"));
        return;
      }

      // Parse outfit data
      final outfitJson = response['outfit'] as Map<String, dynamic>;
      final outfit = OutfitData.fromMap(outfitJson);

      emit(FetchOutfitSuccess(outfit));
    } catch (e) {
      _logger.e("❌ Error fetching outfit: $e");
      emit(FetchOutfitFailure("Failed to fetch outfit: $e"));
    }
  }
}
