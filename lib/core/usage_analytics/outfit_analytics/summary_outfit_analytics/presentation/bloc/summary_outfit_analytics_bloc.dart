import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../data/services/core_fetch_services.dart';
import '../../../../../data/services/core_save_services.dart';
import '../../../../../../outfit_management/core/data/models/outfit_data.dart';
import '../../../../../../outfit_management/core/outfit_enums.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../utilities/helper_functions/feedback_utilities.dart';

part 'summary_outfit_analytics_event.dart';
part 'summary_outfit_analytics_state.dart';

class SummaryOutfitAnalyticsBloc
    extends Bloc<SummaryOutfitAnalyticsEvent, SummaryOutfitAnalyticsState> {
  final CoreFetchService coreFetchServices;
  final CoreSaveService coreSaveServices;
  final CustomLogger _logger = CustomLogger('SummaryOutfitAnalyticsBloc');

  SummaryOutfitAnalyticsBloc(this.coreFetchServices, this.coreSaveServices)
      : super(SummaryOutfitAnalyticsInitial()) {
    on<FetchOutfitAnalytics>(_onFetchOutfitAnalytics);
    on<FetchFilteredOutfits>(_onFetchFilteredOutfits);
    on<SubmitOutfitReviewFeedback>(_onSubmitOutfitReviewFeedback);
  }

  Future<void> _onFetchOutfitAnalytics(
      FetchOutfitAnalytics event, Emitter<SummaryOutfitAnalyticsState> emit) async {
    _logger.i("Fetching outfit usage analytics...");
    emit(SummaryOutfitAnalyticsLoading());

    try {
      final analytics = await coreFetchServices.getOutfitUsageAnalytics();
      _logger.d("Raw RPC response: $analytics");

      if (analytics.isEmpty) {
        _logger.w("No analytics data returned.");
        emit(const SummaryOutfitAnalyticsFailure("No analytics data available."));
        return;
      }

      emit(SummaryOutfitAnalyticsSuccess(
        totalReviews: analytics["total_reviews"] ?? 0,
        likePercentage: analytics["like_percentage"] ?? 0.0,
        alrightPercentage: analytics["alright_percentage"] ?? 0.0,
        dislikePercentage: analytics["dislike_percentage"] ?? 0.0,
        status: analytics["status"] ?? "unknown",
        daysTracked: analytics["days_tracked"] ?? 0,
        closetShown: analytics["closet_shown"] ?? "allClosetShown",
        outfitReview: stringToFeedback(analytics["feedback"]),
      ));
      _logger.i("✅ Outfit analytics fetched successfully.");
    } catch (e) {
      _logger.e("❌ Error fetching outfit analytics: $e");
      emit(SummaryOutfitAnalyticsFailure("Failed to fetch outfit analytics: $e"));
    }
  }

  Future<void> _onFetchFilteredOutfits(
      FetchFilteredOutfits event, Emitter<SummaryOutfitAnalyticsState> emit) async {
    _logger.i("Fetching filtered outfits for page ${event.currentPage}...");
    emit(SummaryOutfitAnalyticsLoading());

    try {
      final response = await coreFetchServices.fetchFilteredOutfits(currentPage: event.currentPage);
      _logger.d("Raw RPC response: $response");

      if (response.isEmpty || response["status"] != "success") {
        _logger.w("No filtered outfits found.");
        emit(const SummaryOutfitAnalyticsFailure("No filtered outfits found."));
        return;
      }

      final outfitsJson = response["outfits"] as List<dynamic>;
      final outfits = outfitsJson.map((json) => OutfitData.fromMap(json)).toList();

      emit(FilteredOutfitsSuccess(outfits: outfits));
      _logger.i("✅ Filtered outfits fetched successfully. Count: ${outfits.length}");
    } catch (e) {
      _logger.e("❌ Error fetching outfits: $e");
      emit(SummaryOutfitAnalyticsFailure("Failed to fetch outfits: $e"));
    }
  }
  Future<void> _onSubmitOutfitReviewFeedback(
      SubmitOutfitReviewFeedback event, Emitter<SummaryOutfitAnalyticsState> emit) async {
    _logger.i("Updating outfit review feedback: ${event.feedback}");
    emit(UpdateOutfitReviewLoading());

    try {
      await coreSaveServices.updateOutfitReviewFeedback(event.feedback);
      emit(UpdateOutfitReviewSuccess());
      _logger.i("✅ Outfit review feedback updated successfully.");
    } catch (e) {
      _logger.e("❌ Error updating outfit review feedback: $e");
      emit(UpdateOutfitReviewFailure("Failed to update feedback: $e"));
    }
  }
}
