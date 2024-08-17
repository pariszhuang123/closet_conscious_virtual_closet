import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/data/services/outfits_fetch_service.dart';
import '../../../core/data/services/outfits_save_service.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';

part 'outfit_review_state.dart';
part 'outfit_review_event.dart';

class OutfitReviewBloc extends Bloc<OutfitReviewEvent, OutfitReviewState> {
  final CustomLogger _logger = GetIt.instance<CustomLogger>(
      instanceName: 'OutfitReviewBlocLogger');
  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();

  final List<String> _selectedItemIds = [];
  OutfitReviewFeedback? _currentFeedback;
  String? _comments;
  String? _outfitId;

  OutfitReviewBloc() : super(const OutfitReviewInitial()) {
    _logger.i('OutfitReviewBloc initialized with initial state.');

    on<ToggleItemSelection>(_onToggleItemSelection);
    on<ValidateReviewSubmission>(_onValidateReviewSubmission);
    on<SubmitReview>(_onSubmitReview);
    on<FetchEarliestOutfitForReview>(_onFetchEarliestOutfitForReview);
    on<SelectFeedbackEvent>(_onSelectFeedbackEvent);
  }

// Use AuthBloc in the FetchEarliestOutfitForReview event
  void _onFetchEarliestOutfitForReview(FetchEarliestOutfitForReview event,
      Emitter<OutfitReviewState> emit) async {
    _logger.i(
        'Fetching earliest outfit for review started with feedback: ${event.feedback}');
    try {
      // Access the authenticated user ID from AuthBloc
      final userId = _authBloc.userId;
      // Log the userId to see what is being shown
      _logger.d('Authenticated userId: $userId');

      if (userId == null) {
        _logger.w('No authenticated user found.');
        emit(OutfitReviewError(
            'No authenticated user found', outfitId: _outfitId,
            currentFeedback: _currentFeedback));
        return;
      }

      // Fetch the outfit using the user ID
      final items = await tmpFetchEarliestOutfitForReview(event.feedback);

      _logger.d('Fetched items: $items');

      if (items.isEmpty) {
        _logger.i('No items found for the earliest outfit.');
        emit(OutfitReviewEmpty(
            outfitId: _outfitId, currentFeedback: _currentFeedback));
      } else if (items.length == 1 ) {
        _outfitId = items.first.itemId;
        _logger.i('Single item found, loading OutfitReviewImage state.');
        emit(OutfitReviewImage(
          items.first.imageUrl,
          outfitId: _outfitId,
          currentFeedback: _currentFeedback,
        ));
      } else {
        _outfitId = items.first.itemId;
        _logger.i('Multiple items found, loading OutfitReviewLoaded state.');
        emit(OutfitReviewLoaded(
          items.cast<Map<String, dynamic>>(),
          outfitId: _outfitId,
          currentFeedback: _currentFeedback,
        ));
      }
    } catch (e) {
      _logger.e('Error fetching earliest outfit for review: ${e.toString()}');
      emit(OutfitReviewError(
        'Failed to fetch outfit: ${e.toString()}',
        outfitId: _outfitId,
        currentFeedback: _currentFeedback,
      ));
    }
  }

  void _onSelectFeedbackEvent(SelectFeedbackEvent event,
      Emitter<OutfitReviewState> emit) {
    _currentFeedback = event.feedback;
    emit(state.copyWith(currentFeedback: _currentFeedback));

    add(FetchEarliestOutfitForReview(_currentFeedback!));
  }

  void _onToggleItemSelection(ToggleItemSelection event,
      Emitter<OutfitReviewState> emit) {
    if (_selectedItemIds.contains(event.itemId)) {
      _selectedItemIds.remove(event.itemId);
    } else {
      _selectedItemIds.add(event.itemId);
    }

    emit(ReviewStateUpdated(
      selectedItemIds: _selectedItemIds,
      feedback: _currentFeedback?.toFeedbackString(),
      comments: _comments,
      outfitId: _outfitId,
      currentFeedback: _currentFeedback,
    ));
  }


  void _onValidateReviewSubmission(ValidateReviewSubmission event,
      Emitter<OutfitReviewState> emit) {
    _logger.i('Validating review submission.');

    if (_currentFeedback == null) {
      _logger.w('Validation failed: Feedback must be chosen.');
      emit(const ReviewValidationError('Feedback must be chosen.'));
      return;
    }

    if ((_currentFeedback == OutfitReviewFeedback.alright ||
        _currentFeedback == OutfitReviewFeedback.dislike) &&
        _selectedItemIds.isEmpty) {
      _logger.w('Validation failed: No items selected for feedback.');
      emit(const ReviewValidationError(
          'You must select at least one item for this feedback.'));
      return;
    }

    _logger.i('Validation successful, proceeding to submit review.');
    add(SubmitReview(
      outfitId: _outfitId!,
      feedback: _currentFeedback!.toFeedbackString(),
      itemIds: _selectedItemIds,
      comments: _comments,
    ));
  }

  void _onSubmitReview(SubmitReview event,
      Emitter<OutfitReviewState> emit) async {
    _logger.i('Submitting review for outfitId: ${event.outfitId}');
    emit(ReviewSubmissionInProgress(
        outfitId: _outfitId, currentFeedback: _currentFeedback));

    try {
      final result = await reviewOutfit(
        outfitId: event.outfitId,
        feedback: event.feedback,
        itemIds: event.itemIds,
        comments: event.comments ?? 'cc_none',
      );

      _logger.d('Review submission result: $result');

      if (result['status'] == 'success') {
        _logger.i('Review submission successful.');
        emit(ReviewSubmissionSuccess(result['message'], outfitId: _outfitId,
            currentFeedback: _currentFeedback));
      } else {
        _logger.e(
            'Review submission failed with message: ${result['message']}');
        emit(ReviewSubmissionFailure(result['message'], outfitId: _outfitId,
            currentFeedback: _currentFeedback));
      }
    } catch (error) {
      _logger.e('Error during review submission: ${error.toString()}');
      emit(ReviewSubmissionFailure(error.toString(), outfitId: _outfitId,
          currentFeedback: _currentFeedback));
    }
  }
}