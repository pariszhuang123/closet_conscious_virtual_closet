import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../../outfit_management/core/data/models/outfit_data.dart';
import '../../../../../data/services/core_fetch_services.dart';

part 'filtered_outfits_state.dart';


class FilteredOutfitsCubit extends Cubit<FilteredOutfitsState> {
  final CoreFetchService coreFetchServices;
  final CustomLogger _logger = CustomLogger('FilteredOutfitsCubit');

  FilteredOutfitsCubit(this.coreFetchServices) : super(FilteredOutfitsInitial());

  void fetchFilteredOutfits(int currentPage) async {
    _logger.i("🔄 Fetching filtered outfits for page $currentPage...");
    emit(FilteredOutfitsLoading());

    try {
      final response = await coreFetchServices.fetchFilteredOutfits(currentPage: currentPage);
      _logger.d("Raw RPC response for filtered outfits: $response");

      if (response.isEmpty) {
        _logger.w("⚠️ Unexpected empty response.");
        emit(FilteredOutfitsFailure("Unexpected empty response."));
        return;
      }

      final status = response["status"];

      if (status == "no_user_outfits") {
        _logger.w("⚠️ User has no outfits at all.");
        emit(NoReviewedOutfitState());
        return;
      }

      if (status == "no_filtered_outfits") {
        _logger.w("⚠️ No outfits match the selected filters.");
        emit(NoFilteredReviewedOutfitState());
        return;
      }

      if (status != "success") {
        _logger.w("⚠️ Unknown status received: $status");
        emit(FilteredOutfitsFailure("Unknown status: $status"));
        return;
      }

      final outfitsJson = response["outfits"] as List<dynamic>;
      final outfits = outfitsJson.map((json) => OutfitData.fromMap(json)).toList();

      _logger.i("✅ Emitting FilteredOutfitsSuccess with ${outfits.length} outfits.");
      emit(FilteredOutfitsSuccess(outfits));
    } catch (e) {
      _logger.e("❌ Error fetching outfits: $e");
      emit(FilteredOutfitsFailure("Failed to fetch outfits: $e"));
    }
  }
}
