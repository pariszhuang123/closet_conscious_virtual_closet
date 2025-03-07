import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../../../outfit_management/core/data/models/outfit_data.dart';
import '../../../../../data/services/core_fetch_services.dart';

part 'fetch_item_related_outfits_state.dart';

class FetchItemRelatedOutfitsCubit extends Cubit<FetchItemRelatedOutfitsState> {
  final CoreFetchService coreFetchService;
  final CustomLogger _logger = CustomLogger('FetchItemRelatedOutfitsCubit');

  bool _isFetching = false;
  bool _hasMoreOutfits = true;
  int _currentPage = 0;
  final List<OutfitData> _allOutfits = [];
  String? _currentItemId;

  FetchItemRelatedOutfitsCubit(this.coreFetchService) : super(FetchItemRelatedOutfitsInitial());

  /// Fetch related outfits for a given itemId with pagination.
  void fetchItemRelatedOutfits({required String itemId}) async {
    if (_currentItemId != itemId) {
      _logger.i("🔄 New item selected: Resetting pagination.");
      _currentItemId = itemId;
      _currentPage = 0;
      _allOutfits.clear();
      _hasMoreOutfits = true;
    }

    if (_isFetching || !_hasMoreOutfits) {
      _logger.i("⏩ Already fetching or no more outfits to load. Aborting.");
      return;
    }

    _isFetching = true;

    if (_currentPage == 0) {
      emit(FetchItemRelatedOutfitsLoading());
    }

    try {
      _logger.i("🔄 Fetching related outfits for itemId: $itemId, page $_currentPage");
      final response = await coreFetchService.getItemRelatedOutfits(
        itemId: itemId,
        currentPage: _currentPage,
      );

      _logger.d("Raw RPC response for related outfits: $response");

      if (response.isEmpty) {
        _logger.w("⚠️ Unexpected empty response.");
        emit(FetchItemRelatedOutfitsFailure("Unexpected empty response."));
        return;
      }

      final status = response["status"];

      if (status == "no_outfits") {
        _logger.w("⚠️ No related outfits found.");
        emit(NoItemRelatedOutfitsState());
        return;
      }

      if (status != "success") {
        _logger.w("⚠️ Unknown status received: $status");
        emit(FetchItemRelatedOutfitsFailure("Unknown status: $status"));
        return;
      }

      final outfitsJson = response["outfits"] as List<dynamic>;
      final outfits = outfitsJson.map((json) => OutfitData.fromMap(json)).toList();

      if (outfits.isEmpty) {
        _logger.i("No more outfits returned. Stopping pagination.");
        _hasMoreOutfits = false;
      }

      _allOutfits.addAll(outfits);
      _currentPage++;

      emit(FetchItemRelatedOutfitsSuccess(_allOutfits));
    } catch (e) {
      _logger.e("❌ Error fetching related outfits: $e");
      emit(FetchItemRelatedOutfitsFailure("Failed to fetch related outfits: $e"));
    } finally {
      _isFetching = false;
    }
  }
}
