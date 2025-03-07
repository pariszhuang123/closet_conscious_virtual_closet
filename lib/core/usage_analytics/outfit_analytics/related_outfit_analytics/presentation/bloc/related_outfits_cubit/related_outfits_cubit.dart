import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../utilities/logger.dart';
import '../../../../../../../outfit_management/core/data/models/outfit_data.dart';
import '../../../../../../data/services/core_fetch_services.dart';

part 'related_outfits_state.dart';

class RelatedOutfitsCubit extends Cubit<RelatedOutfitsState> {
  final CoreFetchService coreFetchServices;
  final CustomLogger _logger = CustomLogger('RelatedOutfitsCubit');

  // Local pagination flags & storage
  bool _isFetching = false;
  bool _hasMoreOutfits = true;
  int _currentPage = 0;
  final List<OutfitData> _allOutfits = [];
  String? _currentOutfitId;

  RelatedOutfitsCubit(this.coreFetchServices) : super(RelatedOutfitsInitial());

  /// Fetch related outfits for a given outfitId with pagination.
  void fetchRelatedOutfits({required String outfitId}) async {
    // If the outfit ID changes, reset pagination
    if (_currentOutfitId != outfitId) {
      _logger.i("🔄 New outfit selected: Resetting pagination.");
      _currentOutfitId = outfitId;
      _currentPage = 0;
      _allOutfits.clear();
      _hasMoreOutfits = true;
    }

    // If already fetching or no more outfits available, do nothing
    if (_isFetching || !_hasMoreOutfits) {
      _logger.i("⏩ Already fetching or no more related outfits to load. Aborting.");
      return;
    }

    // Mark fetching in progress
    _isFetching = true;

    // Show loading indicator only for the first page
    if (_currentPage == 0) {
      emit(RelatedOutfitsLoading());
    }

    try {
      _logger.i("🔄 Fetching related outfits for outfitId: $outfitId, page $_currentPage");
      final response = await coreFetchServices.fetchRelatedOutfits(
        outfitId: outfitId,
        currentPage: _currentPage,
      );

      _logger.d("Raw RPC response for related outfits: $response");

      if (response.isEmpty) {
        _logger.w("⚠️ Unexpected empty response.");
        emit(RelatedOutfitsFailure("Unexpected empty response."));
        return;
      }

      final status = response["status"];

      if (status == "no_similar_items") {
        _logger.w("⚠️ No similar outfits found.");
        emit(NoRelatedOutfitState());
        return;
      }

      if (status != "success") {
        _logger.w("⚠️ Unknown status received: $status");
        emit(RelatedOutfitsFailure("Unknown status: $status"));
        return;
      }

      // Retrieve related outfits array
      final outfitsJson = response["outfits"] as List<dynamic>;
      final outfits = outfitsJson.map((json) => OutfitData.fromMap(json)).toList();

      // If no new outfits are returned, we've reached the end
      if (outfits.isEmpty) {
        _logger.i("No more outfits returned from server. Stopping pagination.");
        _hasMoreOutfits = false;
      } else {
        // Append new outfits and increment page
        _allOutfits.addAll(outfits);
        _currentPage++;
      }

      // Finally, emit success with the entire list so far
      emit(RelatedOutfitsSuccess(_allOutfits));
    } catch (e) {
      _logger.e("❌ Error fetching related outfits: $e");
      emit(RelatedOutfitsFailure("Failed to fetch related outfits: $e"));
    } finally {
      // Reset the fetching flag
      _isFetching = false;
    }
  }
}
