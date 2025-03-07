import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../../outfit_management/core/data/models/outfit_data.dart';
import '../../../../../data/services/core_fetch_services.dart';

part 'filtered_outfits_state.dart';


class FilteredOutfitsCubit extends Cubit<FilteredOutfitsState> {
  final CoreFetchService coreFetchServices;
  final CustomLogger _logger = CustomLogger('FilteredOutfitsCubit');

  // Local pagination flags & storage
  bool _isFetching = false;
  bool _hasMoreOutfits = true;
  int _currentPage = 0;
  final List<OutfitData> _allOutfits = [];

  FilteredOutfitsCubit(this.coreFetchServices)
      : super(FilteredOutfitsInitial());

  /// Public method to fetch the next page of outfits.
  /// If [refresh] is true, start from page 0 again.
  void fetchFilteredOutfits({bool refresh = false}) async {
    // If we are refreshing, reset local variables
    if (refresh) {
      _logger.i("🔄 Refreshing, resetting pagination...");
      _currentPage = 0;
      _allOutfits.clear();
      _hasMoreOutfits = true;
    }

    // If already fetching or there are no more outfits, do nothing
    if (_isFetching || !_hasMoreOutfits) {
      _logger.i("⏩ Already fetching or no more outfits to load. Aborting.");
      return;
    }

    // Mark fetching in progress
    _isFetching = true;

    // If this is the first page (or a refresh), show loading indicator
    if (_currentPage == 0) {
      emit(FilteredOutfitsLoading());
    }

    try {
      _logger.i("🔄 Fetching filtered outfits for page $_currentPage");
      final response = await coreFetchServices.fetchFilteredOutfits(
          currentPage: _currentPage);

      _logger.d("Raw RPC response for filtered outfits: $response");

      // Basic checks
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
        // If we're at page=0, you might want to show "No outfits" UI
        // If we are deeper in pagination, that means no more results
        if (_currentPage == 0) {
          emit(NoFilteredReviewedOutfitState());
        } else {
          // Just set hasMoreOutfits to false so UI doesn't keep calling
          _hasMoreOutfits = false;
        }
        return;
      }

      if (status != "success") {
        _logger.w("⚠️ Status not success: $status");
        emit(FilteredOutfitsFailure("Status not success: $status"));
        return;
      }

      // Retrieve outfits list from the response
      final outfitsJson = response["outfits"] as List<dynamic>;
      final outfits = outfitsJson.map((json) => OutfitData.fromMap(json))
          .toList();

      // If no new outfits are returned, end pagination
      if (outfits.isEmpty) {
        _logger.i("No more outfits returned from server. Stopping pagination.");
        _hasMoreOutfits = false;
      } else {
        // Append new outfits and increment page
        _allOutfits.addAll(outfits);
        _currentPage++;
      }

      // Emit updated state with all loaded outfits
      emit(FilteredOutfitsSuccess(_allOutfits));
    } catch (e) {
      _logger.e("❌ Error fetching outfits: $e");
      emit(FilteredOutfitsFailure("Failed to fetch outfits: $e"));
    } finally {
      // Reset the fetching flag
      _isFetching = false;
    }
  }
}