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
import '../../../../core/utilities/helper_functions/image_helper/image_helper.dart';

part 'outfit_review_state.dart';
part 'outfit_review_event.dart';

// Helper function to convert feedback enum to string
String convertFeedbackToString(OutfitReviewFeedback feedback) {
  return feedback.toString().split('.').last;
}

class OutfitReviewBloc extends Bloc<OutfitReviewEvent, OutfitReviewState> {
  final CustomLogger _logger = CustomLogger('OutfitReviewBlocLogger');
  final AuthBloc _authBloc = locator<AuthBloc>();
  final OutfitFetchService _outfitFetchService;
  final OutfitSaveService saveService;

  List<String> selectedItems = [];

  OutfitReviewBloc(this._outfitFetchService, this.saveService)
      : super(OutfitReviewInitial()) {
    on<CheckAndLoadOutfit>(_onCheckAndLoadOutfit);
    on<FetchOutfitItems>(_onFetchOutfitItems);
    on<FeedbackSelected>(_onFeedbackSelected);
    on<SubmitOutfitReview>(_onSubmitOutfitReview);
  }

  Future<void> _onCheckAndLoadOutfit(CheckAndLoadOutfit event,
      Emitter<OutfitReviewState> emit) async {
    final authState = _authBloc.state;
    if (authState is Authenticated) {
      emit(OutfitReviewLoading(
          outfitId: state.outfitId)); // Maintain outfitId during loading state
      _logger.i('Starting _onCheckAndLoadOutfit');

      final String userId = authState.user.id;

      try {
        final response = await _outfitFetchService.fetchOutfitId(userId);

        if (response != null && response.outfitId != null) {
          _logger.i('Outfit ID: ${response.outfitId}, Event Name: ${response.eventName}');

          // Update state with the fetched outfitId and eventName
          emit(OutfitReviewItemsLoaded(
            items: const [],
            outfitId: response.outfitId,
            eventName: response.eventName,
            feedback: event.feedback,
            canSelectItems: event.feedback != OutfitReviewFeedback.like,
            hasSelectedItems: false,
          ));

          // Handle the feedback depending on the type
          await _handleFeedback(event.feedback, response.outfitId!, emit);

        } else {
          _logger.w('No outfit ID found, navigating to My Closet.');
          emit(NavigateToMyOutfit());
        }
      } catch (e, stackTrace) {
        _logger.e('Failed to load outfit: $e');
        _logger.e('Stack trace: $stackTrace');
        emit(NavigateToMyOutfit());
      }
    } else {
      _logger.w('User is not authenticated');
      emit(NavigateToMyOutfit());
    }
  }


  Future<void> _handleFeedback(OutfitReviewFeedback feedback, String outfitId,
      Emitter<OutfitReviewState> emit) async {
    if (feedback == OutfitReviewFeedback.like) {
      await _handleLikeFeedback(outfitId, emit);
    } else {
      await _handleOtherFeedback(feedback, outfitId, emit);
    }
  }

  Future<void> _handleLikeFeedback(String outfitId,
      Emitter<OutfitReviewState> emit) async {
    try {
      final imageUrl = await _outfitFetchService.fetchOutfitImageUrl(outfitId);
      if (imageUrl != null && imageUrl != 'cc_none') {
        _logger.i('Outfit Image URL found: $imageUrl');

        if (!emit.isDone) {
          emit(OutfitImageUrlAvailable(
              imageUrl,
              outfitId: outfitId,
              eventName: state.eventName // Preserve eventName

          )); // Ensure outfitId is included
        }
      } else {
        _logger.w('No Outfit Image URL found, fetching outfit items.');

        final outfitItems = await _outfitFetchService.fetchOutfitItems(outfitId);

        if (!emit.isDone) {
          emit(OutfitReviewItemsLoaded(
            items: outfitItems,
            canSelectItems: false,
            feedback: OutfitReviewFeedback.like,
            outfitId: outfitId, // Include outfitId
            eventName: state.eventName, // Preserve eventName
          ));
        }
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to load outfit image URL: $e');
      _logger.e('Stack trace: $stackTrace');

      if (!emit.isDone) {
        emit(NavigateToMyOutfit()); // Include outfitId
      }
    }
  }

  Future<void> _handleOtherFeedback(OutfitReviewFeedback feedback,
      String outfitId, Emitter<OutfitReviewState> emit) async {
    try {
      final canSelectItems = feedback == OutfitReviewFeedback.alright ||
          feedback == OutfitReviewFeedback.dislike;

      final outfitItems = await _outfitFetchService.fetchOutfitItems(outfitId);
      _logger.i('Fetched outfit items:');
      for (var item in outfitItems) {
        _logger.i('Item: ${item.name}, ID: ${item.itemId}, Image URL: ${getImagePathFromSource(item.imageSource)}');
      }

      if (!emit.isDone) {
        emit(OutfitReviewItemsLoaded(
          items: outfitItems,
          canSelectItems: canSelectItems,
          feedback: feedback,
          outfitId: outfitId,
          eventName: state.eventName// Ensure outfitId is included
        ));
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to load outfit items: $e');
      _logger.e('Stack trace: $stackTrace');

      if (!emit.isDone) {
        emit(OutfitReviewError('Failed to load outfit items', outfitId: outfitId)); // Ensure outfitId is included
      }
    }
  }

  void _onFeedbackSelected(FeedbackSelected event,
      Emitter<OutfitReviewState> emit) async {
    final feedback = event.feedback;

    _logger.i('Feedback selected: $feedback for outfitId: ${event.outfitId}');

    // Check if the state is OutfitReviewItemsLoaded before calling copyWith
    if (state is OutfitReviewItemsLoaded) {
      final loadedState = state as OutfitReviewItemsLoaded;

      emit(loadedState.copyWith(
        feedback: feedback,
        canSelectItems: feedback != OutfitReviewFeedback.like,
        hasSelectedItems: loadedState.items.any((item) => item.isDisliked),
      ));
    } else {
      // If it's not OutfitReviewItemsLoaded, manually emit a new state
      emit(OutfitReviewItemsLoaded(
        items: const [], // Empty items list (default)
        outfitId: state.outfitId,
        eventName: state.eventName,
        feedback: feedback,
        canSelectItems: feedback != OutfitReviewFeedback.like,
        hasSelectedItems: false,
      ));
    }


    if (feedback == OutfitReviewFeedback.like) {
      _logger.i('Handling "like" feedback');
      await _handleLikeFeedback(event.outfitId, emit); // Ensure outfitId is passed
    } else {
      _logger.i('Handling other feedback: $feedback');
      await _handleOtherFeedback(feedback, event.outfitId, emit); // Ensure outfitId is passed
    }
  }

  Future<void> _onFetchOutfitItems(FetchOutfitItems event,
      Emitter<OutfitReviewState> emit) async {
    _logger.i('Handling FetchOutfitItems event');
    emit(OutfitReviewLoading(outfitId: state.outfitId));

    try {
      final selectedItems = await _outfitFetchService.fetchOutfitItems(
          event.outfitId);

      _logger.i('Fetched items: $selectedItems');

      if (selectedItems.isEmpty) {
        _logger.w('No items found for the outfit');
        emit(NoOutfitItemsFound(outfitId: state.outfitId));
      } else {
        emit(OutfitReviewItemsLoaded(
          items: selectedItems, // Corrected to named parameter
          outfitId: event.outfitId,
        ));
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to load outfit items: $e');
      _logger.e('Stack trace: $stackTrace');
      emit(OutfitReviewError(
          'Failed to load outfit items', outfitId: state.outfitId));
    }
  }

  Future<void> _onSubmitOutfitReview(SubmitOutfitReview event,
      Emitter<OutfitReviewState> emit) async {
    try {
      _logger.i('Submitting outfit review...');

      final OutfitReviewFeedback feedbackEnum = stringToFeedback(
          event.feedback);
      final String feedbackString = convertFeedbackToString(feedbackEnum);

      final List<String> dislikedItemIds = event.itemIds;

      _logger.d('Feedback received: $feedbackString');

      // Submit the review with feedback and disliked item IDs
      await saveService.reviewOutfit(
        outfitId: event.outfitId,
        feedback: feedbackString, // Pass the converted feedback string
        itemIds: dislikedItemIds, // Pass the extracted disliked item IDs
        comments: event.comments, // Pass optional comments
      );

      emit(ReviewSubmissionSuccess());
      _logger.i('Outfit review submitted successfully');
    } catch (error) {
      emit(ReviewSubmissionFailure(error.toString()));
      _logger.e('Failed to submit outfit review: $error');
    }
  }
}