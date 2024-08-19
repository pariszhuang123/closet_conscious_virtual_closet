import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:equatable/equatable.dart';

import '../../../core/data/models/outfit_item_minimal.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../core/data/services/outfits_fetch_service.dart';
import '../../../../core/utilities/logger.dart';

part 'outfit_review_state.dart';
part 'outfit_review_event.dart';

class OutfitReviewBloc extends Bloc<OutfitReviewEvent, OutfitReviewState> {
  final CustomLogger _logger = GetIt.instance<CustomLogger>(
      instanceName: 'OutfitReviewBlocLogger');
  final AuthBloc _authBloc = GetIt.instance<AuthBloc>();
  final OutfitFetchService _outfitFetchService;

  List<String> selectedItems = [];

  OutfitReviewBloc(this._outfitFetchService) : super(OutfitReviewInitial()) {
    on<CheckAndLoadOutfit>(_onCheckAndLoadOutfit);
    on<FetchOutfitItems>(_onFetchOutfitItems);
    on<ToggleItemSelection>(_onToggleItemSelection);
    on<FeedbackSelected>(_onFeedbackSelected);
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

  Future<void> _handleLikeFeedback(String outfitId, Emitter<OutfitReviewState> emit) async {
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
            items: outfitItems,  // Corrected to named parameter
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

  Future<void> _handleOtherFeedback(OutfitReviewFeedback feedback, String outfitId, Emitter<OutfitReviewState> emit) async {
    try {
      // Determine if item selection should be enabled based on feedback
      final canSelectItems = feedback == OutfitReviewFeedback.alright || feedback == OutfitReviewFeedback.dislike;

      // Await the async operation
      final outfitItems = await _outfitFetchService.fetchOutfitItems(outfitId);
      _logger.i('Fetched outfit items:');
      for (var item in outfitItems) {
        _logger.i('Item: ${item.name}, ID: ${item.itemId}, Image URL: ${item.imageUrl}');
      }

      // Ensure that the emit function is only called after all async operations are complete
      if (!emit.isDone) {
        emit(OutfitReviewItemsLoaded(
          items: outfitItems,  // Corrected to named parameter
          canSelectItems: canSelectItems,
          feedback: feedback,
          outfitId: outfitId,
        ));
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to load outfit items: $e');
      _logger.e('Stack trace: $stackTrace');

      if (!emit.isDone) {
        emit(OutfitReviewError('Failed to load outfit items', outfitId: outfitId));
      }
    }
  }

  void _onFeedbackSelected(FeedbackSelected event, Emitter<OutfitReviewState> emit) {
    final feedback = event.feedback;

    _logger.i('Feedback selected: $feedback for outfitId: ${event.outfitId}');
    emit(state.copyWith(feedback: feedback));

    if (feedback == OutfitReviewFeedback.like) {
      _logger.i('Handling "like" feedback');
      _handleLikeFeedback(event.outfitId, emit);
    } else {
      _logger.i('Handling other feedback: $feedback');
      _handleOtherFeedback(feedback, event.outfitId, emit);
    }
  }

  Future<void> _onFetchOutfitItems(FetchOutfitItems event,
      Emitter<OutfitReviewState> emit) async {
    _logger.i('Handling FetchOutfitItems event');
    emit(OutfitReviewLoading(outfitId: state.outfitId));

    try {
      final selectedItems = await _outfitFetchService.fetchOutfitItems(event.outfitId);

      _logger.i('Fetched items: $selectedItems');

      if (selectedItems.isEmpty) {
        _logger.w('No items found for the outfit');
        emit(NoOutfitItemsFound(outfitId: state.outfitId));
      } else {
        emit(OutfitReviewItemsLoaded(
          items: selectedItems,  // Corrected to named parameter
          outfitId: event.outfitId,
        ));
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to load outfit items: $e');
      _logger.e('Stack trace: $stackTrace');
      emit(OutfitReviewError('Failed to load outfit items', outfitId: state.outfitId));
    }
  }

  void _onToggleItemSelection(ToggleItemSelection event,
      Emitter<OutfitReviewState> emit) {
    if (!state.canSelectItems) {
      // Ignore item selection if it's not allowed
      return;
    }

    final updatedSelectedItemIds = Map<OutfitReviewFeedback, List<String>>.from(
        state.selectedItemIds);
    final selectedItems = List<String>.from(
        updatedSelectedItemIds[state.feedback] ?? []);

    if (selectedItems.contains(event.itemId)) {
      selectedItems.remove(event.itemId);
      _logger.d('Deselected item ID: ${event.itemId}');
    } else {
      selectedItems.add(event.itemId);
      _logger.d('Selected item ID: ${event.itemId}');
    }

    updatedSelectedItemIds[state.feedback] = selectedItems;

    // Calculate if any items are selected across all categories
    final hasSelectedItems = updatedSelectedItemIds.values.any((items) =>
    items.isNotEmpty);

    emit(state.copyWith(
      selectedItemIds: updatedSelectedItemIds,
      hasSelectedItems: hasSelectedItems,
    ));

    // Log to ensure state update
    _logger.d('Updated selected item IDs in state: ${state.selectedItemIds}');
  }
}
