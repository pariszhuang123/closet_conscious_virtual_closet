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

      if (response.isEmpty || response["status"] != "success") {
        _logger.w("⚠️ No filtered outfits found.");
        emit(FilteredOutfitsFailure("No filtered outfits found."));
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
