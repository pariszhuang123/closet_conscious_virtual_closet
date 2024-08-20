import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:equatable/equatable.dart';

import '../../../core/data/models/outfit_item_minimal.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../core/data/services/outfits_fetch_service.dart';
import '../../../core/data/services/outfits_save_service.dart';
import '../../../../core/utilities/logger.dart';

part 'outfit_review_state.dart';
part 'outfit_review_event.dart';

enum OutfitReviewFeedback { like, dislike, alright }

OutfitReviewFeedback stringToFeedback(String feedback) {
  final feedbackValue = feedback.split('.').last;
  switch (feedbackValue) {
    case 'like':
      return OutfitReviewFeedback.like;
    case 'dislike':
      return OutfitReviewFeedback.dislike;
    case 'alright':
      return OutfitReviewFeedback.alright;
    default:
      throw Exception('Invalid feedback string: $feedback');
  }
}


class OutfitReviewBloc extends Bloc<OutfitReviewEvent, OutfitReviewState> {
  final CustomLogger _logger = GetIt.instance<CustomLogger>(
      instanceName: 'OutfitReviewBlocLogger');
  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();
  final OutfitFetchService _outfitFetchService;
  final OutfitSaveService saveService;

  List<String> selectedItems = [];

  OutfitReviewBloc(this._outfitFetchService, this.saveService) : super(OutfitReviewInitial()) {
    on<CheckAndLoadOutfit>(_onCheckAndLoadOutfit);
    on<FetchOutfitItems>(_onFetchOutfitItems);
    on<ToggleItemSelection>(_onToggleItemSelection);
    on<FeedbackSelected>(_onFeedbackSelected);
    on<SubmitOutfitReview>(_onSubmitOutfitReview);
  }

  Future<void> _onCheckAndLoadOutfit(CheckAndLoadOutfit event,
      Emitter<OutfitReviewState> emit) async {
    final authState = _authBloc.state;
    if (authState is Authenticated) {
      emit(OutfitReviewLoading(outfitId: state.outfitId)); // Maintain outfitId during loading state
      _logger.i('Starting _onCheckAndLoadOutfit');

      final String userId = authState.user.id;

      try {
        final outfitId = await _outfitFetchService.fetchOutfitId(userId);

        if (outfitId != null) {
          _logger.i('Outfit ID: $outfitId');

          // Update state with the fetched outfitId
          emit(state.copyWith(
            feedback: event.feedback,
            outfitId: outfitId,
          ));

          // Handle the feedback depending on the type
          await _handleFeedback(event.feedback, outfitId, emit);
        } else {
          _logger.w('No outfit ID found, navigating to My Closet.');
          emit(NavigateToMyCloset());
        }
      } catch (e, stackTrace) {
        _logger.e('Failed to load outfit: $e');
        _logger.e('Stack trace: $stackTrace');
        emit(NavigateToMyCloset());
      }
    } else {
      _logger.w('User is not authenticated');
      emit(NavigateToMyCloset());
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

        // Ensure the state is only emitted if the handler hasn't completed
        if (!emit.isDone) {
          emit(OutfitImageUrlAvailable(imageUrl, outfitId: outfitId));
        }
      } else {
        _logger.w('No Outfit Image URL found, fetching outfit items.');

        final outfitItems = await _outfitFetchService.fetchOutfitItems(outfitId);

        // Ensure the state is only emitted if the handler hasn't completed
        if (!emit.isDone) {
          emit(OutfitReviewItemsLoaded(
            items: outfitItems,
            canSelectItems: false, // Assuming items can't be selected for 'like'
            feedback: OutfitReviewFeedback.like,
            outfitId: outfitId,
          ));
        }
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to load outfit image URL: $e');
      _logger.e('Stack trace: $stackTrace');

      // Ensure the state is only emitted if the handler hasn't completed
      if (!emit.isDone) {
        emit(NavigateToMyCloset());
      }
    }
  }

  Future<void> _handleOtherFeedback(OutfitReviewFeedback feedback,
      String outfitId, Emitter<OutfitReviewState> emit) async {
    try {
      // Determine if item selection should be enabled based on feedback
      final canSelectItems = feedback == OutfitReviewFeedback.alright ||
          feedback == OutfitReviewFeedback.dislike;

      // Await the async operation
      final outfitItems = await _outfitFetchService.fetchOutfitItems(outfitId);
      _logger.i('Fetched outfit items:');
      for (var item in outfitItems) {
        _logger.i('Item: ${item.name}, ID: ${item.itemId}, Image URL: ${item.imageUrl}');
      }

      // Ensure that the emit function is only called after all async operations are complete
      if (!emit.isDone) {
        emit(OutfitReviewItemsLoaded(
          items: outfitItems,
          canSelectItems: canSelectItems,
          feedback: feedback,
          outfitId: outfitId,
        ));
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to load outfit items: $e');
      _logger.e('Stack trace: $stackTrace');

      if (!emit.isDone) {
        emit(OutfitReviewError(
            'Failed to load outfit items', outfitId: outfitId));
      }
    }
  }

  void _onFeedbackSelected(FeedbackSelected event,
      Emitter<OutfitReviewState> emit) async {
    final feedback = event.feedback;

    _logger.i('Feedback selected: $feedback for outfitId: ${event.outfitId}');

    emit(state.copyWith(feedback: feedback));

    if (feedback == OutfitReviewFeedback.like) {
      _logger.i('Handling "like" feedback');
      await _handleLikeFeedback(event.outfitId, emit);
    } else {
      _logger.i('Handling other feedback: $feedback');
      await _handleOtherFeedback(feedback, event.outfitId, emit);
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

  void _onToggleItemSelection(ToggleItemSelection event,
      Emitter<OutfitReviewState> emit) {
    if (state is OutfitReviewItemsLoaded) {
      final loadedState = state as OutfitReviewItemsLoaded;

      // Check if the current feedback is "like"
      if (loadedState.feedback == OutfitReviewFeedback.like) {
        _logger.d('Item selection is disabled when feedback is "like".');
        return; // Exit the method early to prevent toggling
      }

      // Find the index of the item to be updated
      final itemIndex = loadedState.items.indexWhere((item) =>
      item.itemId == event.itemId);

      if (itemIndex != -1) {
        // Create a new list where only the selected item is updated
        final updatedItems = List<OutfitItemMinimal>.from(loadedState.items);
        final updatedItem = updatedItems[itemIndex].copyWith(
          isDisliked: !updatedItems[itemIndex].isDisliked,
        );
        updatedItems[itemIndex] = updatedItem;

        // Emit the new state with the updated list
        emit(loadedState.copyWith(items: updatedItems));

        // Log the updated items with their disliked status
        _logger.d('Updated disliked items: ${updatedItems.where((item) =>
        item.isDisliked).map((item) => item.itemId).toList()}');
      }
    }
  }

  void _onSubmitOutfitReview(SubmitOutfitReview event, Emitter<OutfitReviewState> emit) async {
    String convertFeedbackToString(OutfitReviewFeedback feedback) {
      return feedback.toString().split('.').last;
    }

    if (state is OutfitReviewItemsLoaded) {
      final loadedState = state as OutfitReviewItemsLoaded;

      final OutfitReviewFeedback feedback = stringToFeedback(event.feedback);
      final dislikedItemIds = _extractDislikedItemIds(loadedState);
      final String feedbackString = convertFeedbackToString(feedback);

      _logInitialState(event, dislikedItemIds, feedbackString);

      // Validate before proceeding
      if (!_isLikeFeedback(feedbackString) && !_isDislikeOrAlrightFeedbackWithDislikedItems(feedbackString, dislikedItemIds)) {
        _logger.e('Invalid submission detected. Feedback: $feedbackString, disliked items: ${dislikedItemIds.isNotEmpty}');

        _handleInvalidSubmission(feedbackString, dislikedItemIds, loadedState, emit);
        return; // Exit early to prevent submission
      }

      emit(ReviewSubmissionInProgress());
      _logger.i('State changed to: ReviewSubmissionInProgress');

      try {
        await _submitReview(event, dislikedItemIds, emit);
      } catch (error) {
        _handleSubmissionFailure(error, emit);
      }
    } else {
      _logger.e('Invalid state: Expected OutfitReviewItemsLoaded but received $state');
    }
  }


  bool _isLikeFeedback(String feedback) {
    _logger.d('Checking if feedback is "like": $feedback == like');
    return feedback == 'like'; // Ensure you're comparing against the string 'like'
  }

  bool _isDislikeOrAlrightFeedbackWithDislikedItems(String feedback, List<String> dislikedItemIds) {
    _logger.d('Checking if feedback is "dislike" or "alright" with disliked items: $feedback, items present: ${dislikedItemIds.isNotEmpty}');
    return (feedback == 'dislike' || feedback == 'alright') && dislikedItemIds.isNotEmpty;
  }

  List<String> _extractDislikedItemIds(OutfitReviewItemsLoaded loadedState) {
    return loadedState.items
        .where((item) => item.isDisliked)
        .map((item) => item.itemId)
        .toList();
  }

  void _logInitialState(SubmitOutfitReview event, List<String> dislikedItemIds, String feedback) {
    _logger.i('Event triggered: SubmitOutfitReview');
    _logger.i('Feedback received: $feedback');
    _logger.i('Disliked Item IDs: $dislikedItemIds');
    _logger.i('Disliked items present: ${dislikedItemIds.isNotEmpty}');
    _logger.i('State before submission: $state');
  }

  Future<void> _submitReview(SubmitOutfitReview event, List<String> dislikedItemIds, Emitter<OutfitReviewState> emit) async {
    await saveService.reviewOutfit(
      outfitId: event.outfitId,
      feedback: event.feedback,
      itemIds: dislikedItemIds,
      comments: event.comments,
    );

    emit(ReviewSubmissionSuccess());
    _logger.i('Review submission success. State changed to: ReviewSubmissionSuccess');
  }

  void _handleInvalidSubmission(String feedback, List<String> dislikedItemIds, OutfitReviewItemsLoaded loadedState, Emitter<OutfitReviewState> emit) {
    _logger.w('Invalid submission detected. Feedback: $feedback, disliked items present: ${dislikedItemIds.isNotEmpty}');

    emit(InvalidReviewSubmission(
      outfitId: loadedState.outfitId,
    ));
    _logger.w('State changed to: InvalidReviewSubmission');
  }

  void _handleSubmissionFailure(dynamic error, Emitter<OutfitReviewState> emit) {
    emit(ReviewSubmissionFailure(error.toString()));
    _logger.e('Review submission failed. Error: $error');
    _logger.e('State changed to: ReviewSubmissionFailure');
  }
}