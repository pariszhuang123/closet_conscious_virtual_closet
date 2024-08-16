import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data/services/outfits_fetch_service.dart';
import '../../../core/data/services/outfits_save_service.dart';

part 'outfit_review_state.dart';
part 'outfit_review_event.dart';

class OutfitReviewBloc extends Bloc<OutfitReviewEvent, OutfitReviewState> {
  final List<String> _selectedItemIds = [];
  OutfitReviewFeedback? _currentFeedback;
  String? _comments;
  String? _outfitId;

  OutfitReviewBloc() : super(const OutfitReviewInitial()) {
    on<ToggleItemSelection>(_onToggleItemSelection);
    on<ValidateReviewSubmission>(_onValidateReviewSubmission);
    on<SubmitReview>(_onSubmitReview);
    on<FetchEarliestOutfitForReview>(_onFetchEarliestOutfitForReview);
    on<SelectFeedbackEvent>(_onSelectFeedbackEvent);
  }

  void _onFetchEarliestOutfitForReview(
      FetchEarliestOutfitForReview event, Emitter<OutfitReviewState> emit) async {
    emit(OutfitReviewLoading(outfitId: _outfitId, currentFeedback: _currentFeedback));
    try {
      final items = await fetchEarliestOutfitForReview(event.feedback);

      if (items.isEmpty) {
        emit(OutfitReviewEmpty(outfitId: _outfitId, currentFeedback: _currentFeedback));
      } else if (items.length == 1 && items.first['item_id'] == null) {
        _outfitId = items.first['outfit_id'];
        emit(OutfitReviewImage(
          items.first['image_url'],
          outfitId: _outfitId,
          currentFeedback: _currentFeedback,
        ));
      } else {
        _outfitId = items.first['outfit_id'];
        emit(OutfitReviewLoaded(
          items,
          outfitId: _outfitId,
          currentFeedback: _currentFeedback,
        ));
      }
    } catch (e) {
      emit(OutfitReviewError(
        'Failed to fetch outfit: ${e.toString()}',
        outfitId: _outfitId,
        currentFeedback: _currentFeedback,
      ));
    }
  }

  void _onSelectFeedbackEvent(
      SelectFeedbackEvent event, Emitter<OutfitReviewState> emit) {
    _currentFeedback = event.feedback;
    emit(state.copyWith(currentFeedback: _currentFeedback));

    add(FetchEarliestOutfitForReview(_currentFeedback!));
  }

  void _onToggleItemSelection(ToggleItemSelection event, Emitter<OutfitReviewState> emit) {
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

  void _onValidateReviewSubmission(ValidateReviewSubmission event, Emitter<OutfitReviewState> emit) {
    if (_currentFeedback == null) {
      emit(const ReviewValidationError('Feedback must be chosen.'));
      return;
    }

    if ((_currentFeedback == OutfitReviewFeedback.alright || _currentFeedback == OutfitReviewFeedback.dislike) && _selectedItemIds.isEmpty) {
      emit(const ReviewValidationError('You must select at least one item for this feedback.'));
      return;
    }

    add(SubmitReview(
      outfitId: _outfitId!,  // Ensure outfitId is not null here
      feedback: _currentFeedback!.toFeedbackString(),
      itemIds: _selectedItemIds,
      comments: _comments,
    ));
  }

  Future<void> _onSubmitReview(
      SubmitReview event, Emitter<OutfitReviewState> emit) async {
    emit(ReviewSubmissionInProgress(outfitId: _outfitId, currentFeedback: _currentFeedback));

    try {
      final result = await reviewOutfit(
        outfitId: event.outfitId,
        feedback: event.feedback,
        itemIds: event.itemIds,
        comments: event.comments ?? 'cc_none',
      );

      if (result['status'] == 'success') {
        emit(ReviewSubmissionSuccess(result['message'], outfitId: _outfitId, currentFeedback: _currentFeedback));
      } else {
        emit(ReviewSubmissionFailure(result['message'], outfitId: _outfitId, currentFeedback: _currentFeedback));
      }
    } catch (error) {
      emit(ReviewSubmissionFailure(error.toString(), outfitId: _outfitId, currentFeedback: _currentFeedback));
    }
  }
}
