import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../core/outfit_enums.dart';
import '../../../../user_management/user_service_locator.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../core/data/services/outfits_fetch_services.dart';
import '../../../core/data/services/outfits_save_services.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/utilities/helper_functions/feedback_utilities.dart';

part 'outfit_review_state.dart';
part 'outfit_review_event.dart';

// Helper function to convert feedback enum to string
String convertFeedbackToString(OutfitReviewFeedback feedback) =>
    feedback.toString().split('.').last;

class OutfitReviewBloc
    extends Bloc<OutfitReviewEvent, OutfitReviewState> {
  final CustomLogger _logger = CustomLogger('OutfitReviewBlocLogger');
  final AuthBloc _authBloc = locator<AuthBloc>();
  final OutfitFetchService _outfitFetchService;
  final OutfitSaveService saveService;

  List<ClosetItemMinimal> _cachedItems = [];

  OutfitReviewBloc(
      this._outfitFetchService,
      this.saveService,
      ) : super(OutfitReviewInitial()) {
    on<CheckAndLoadOutfit>(_onCheckAndLoadOutfit);
    on<FeedbackSelected>(_onFeedbackSelected);
    on<SubmitOutfitReview>(_onSubmitOutfitReview);
  }

  Future<void> _onCheckAndLoadOutfit(
      CheckAndLoadOutfit event,
      Emitter<OutfitReviewState> emit,
      ) async {
    final authState = _authBloc.state;
    if (authState is! Authenticated) {
      _logger.w('User not authenticated');
      emit(NavigateToMyOutfit());
      return;
    }

    emit(const OutfitReviewLoading());

    try {
      final resp = await _outfitFetchService.fetchOutfitId(authState.user.id);

      if (resp?.outfitId == null) {
        _logger.w('No outfit ID found');
        emit(NavigateToMyOutfit());
        return;
      }

      final outfitId = resp!.outfitId!;
      final eventName = resp.eventName;

      _logger.i('Got outfitId=$outfitId, eventName=$eventName');

      // Now fetch either the image or the items:
      await _handleFeedback(
        event.feedback,
        outfitId,
        eventName,
        emit,
      );
    } catch (e, st) {
      _logger.e('Error in _onCheckAndLoadOutfit: $e\n$st');
      emit(NavigateToMyOutfit());
    }
  }

  Future<void> _handleFeedback(
      OutfitReviewFeedback feedback,
      String outfitId,
      String? eventName,
      Emitter<OutfitReviewState> emit,
      ) async {
    if (feedback == OutfitReviewFeedback.like) {
      await _handleLikeFeedback(outfitId, eventName, emit);
    } else {
      await _handleOtherFeedback(feedback, outfitId, eventName, emit);
    }
  }

  Future<void> _handleLikeFeedback(
      String outfitId,
      String? eventName,
      Emitter<OutfitReviewState> emit,
      ) async {
    try {
      final imageUrl = await _outfitFetchService.fetchOutfitImageUrl(outfitId);

      if (imageUrl != null && imageUrl != 'cc_none') {
        // 1) Preload items into cache (no UI state change yet)
        _cachedItems = await _outfitFetchService.fetchOutfitItems(outfitId);

        _logger.i('Emitting image state for outfit $outfitId');
        emit(OutfitImageUrlAvailable(
          imageUrl,
          _cachedItems,
          outfitId: outfitId,
          eventName: eventName,
          feedback: OutfitReviewFeedback.like,
        ));
      } else {
        // no image, just fetch items & show grid
        _cachedItems = await _outfitFetchService.fetchOutfitItems(outfitId);
        emit(OutfitReviewItemsLoaded(
          items: _cachedItems,
          outfitId: outfitId,
          eventName: eventName,
          feedback: OutfitReviewFeedback.like,
          canSelectItems: false,
          hasSelectedItems: false,
        ));
      }
    } catch (e, st) {
      _logger.e('Error in _handleLikeFeedback: $e\n$st');
      emit(NavigateToMyOutfit());
    }
  }

  Future<void> _handleOtherFeedback(
      OutfitReviewFeedback feedback,
      String outfitId,
      String? eventName,
      Emitter<OutfitReviewState> emit,
      ) async {
    try {
      // if we already preloaded, skip the network call
      final items = _cachedItems.isNotEmpty
          ? _cachedItems
          : await _outfitFetchService.fetchOutfitItems(outfitId);

      _logger.i('Emitting items-loaded state with ${items.length} items');
      emit(OutfitReviewItemsLoaded(
        items: items,
        outfitId: outfitId,
        eventName: eventName,
        feedback: feedback,
        canSelectItems: feedback != OutfitReviewFeedback.like,
        hasSelectedItems: false,
      ));
    } catch (e, st) {
      _logger.e('Error in _handleOtherFeedback: $e\n$st');
      emit(OutfitReviewError('Failed to load items for outfit', outfitId: outfitId));
    }
  }

  Future<void> _onFeedbackSelected(
      FeedbackSelected event,
      Emitter<OutfitReviewState> emit,
      ) async {
    // You can re-use the same _handleOtherFeedback/_handleLikeFeedback
    // logic if you want to re-fetch items when the user toggles feedback.
    await _handleFeedback(
      event.feedback,
      event.outfitId,
      state.eventName,
      emit,
    );
  }

  Future<void> _onSubmitOutfitReview(
      SubmitOutfitReview event,
      Emitter<OutfitReviewState> emit,
      ) async {
    try {
      final fb = stringToFeedback(event.feedback);
      final fbString = convertFeedbackToString(fb);

      await saveService.reviewOutfit(
        outfitId: event.outfitId,
        feedback: fbString,
        itemIds: event.itemIds,
        comments: event.comments,
      );

      emit(ReviewSubmissionSuccess());
      _logger.i('Review submitted for ${event.outfitId}');
    } catch (e, st) {
      _logger.e('Error submitting review: $e\n$st');
      emit(ReviewSubmissionFailure(e.toString()));
    }
  }
}
