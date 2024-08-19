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
      emit(OutfitReviewLoading());
      _logger.i('Starting _onCheckAndLoadOutfit');

      final String userId = authState.user.id;

      try {
        final outfitId = await _outfitFetchService.fetchOutfitId(userId);

        if (outfitId != null) {
          _logger.i('Outfit ID: $outfitId');
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
        emit(OutfitImageUrlAvailable(imageUrl));
      } else {
        _logger.w('No Outfit Image URL found, fetching outfit items.');

        final outfitItems = await _outfitFetchService.fetchOutfitItems(outfitId);

        emit(OutfitReviewItemsLoaded(
          outfitItems,
          canSelectItems: false, // Assuming items can't be selected for 'like'
          feedback: OutfitReviewFeedback.like,
        ));
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to load outfit image URL: $e');
      _logger.e('Stack trace: $stackTrace');
      emit(NavigateToMyCloset());
    }
  }

  Future<void> _handleOtherFeedback(OutfitReviewFeedback feedback, String outfitId,
      Emitter<OutfitReviewState> emit) async {
    try {
      // Determine if item selection should be enabled based on feedback
      final canSelectItems = feedback == OutfitReviewFeedback.alright || feedback == OutfitReviewFeedback.dislike;

      final outfitItems = await _outfitFetchService.fetchOutfitItems(outfitId);
      _logger.i('Fetched outfit items: $outfitItems');

      emit(OutfitReviewItemsLoaded(
        outfitItems,
        canSelectItems: canSelectItems,
        feedback: feedback,
      ));
    } catch (e, stackTrace) {
      _logger.e('Failed to load outfit items: $e');
      _logger.e('Stack trace: $stackTrace');
      emit(const OutfitReviewError('Failed to load outfit items'));
    }
  }

  void _onFeedbackSelected(FeedbackSelected event, Emitter<OutfitReviewState> emit) {
    final feedback = event.feedback;

    if (feedback == OutfitReviewFeedback.like) {
      _handleLikeFeedback(event.outfitId, emit);
    } else {
      _handleOtherFeedback(feedback, event.outfitId, emit);
    }
  }

  Future<void> _onFetchOutfitItems(FetchOutfitItems event,
      Emitter<OutfitReviewState> emit) async {
    _logger.i('Handling FetchOutfitItems event');
    emit(OutfitReviewLoading());

    try {
      final selectedItems = await _outfitFetchService.fetchOutfitItems(event.outfitId);

      _logger.i('Fetched items: $selectedItems');

      if (selectedItems.isEmpty) {
        _logger.w('No items found for the outfit');
        emit(NoOutfitItemsFound());
      } else {
        for (var item in selectedItems) {
          _logger.i('Fetched item - ID: ${item.itemId}, Name: ${item.name}, Image URL: ${item.imageUrl}');
        }
        emit(OutfitReviewItemsLoaded(selectedItems));
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to load outfit items: $e');
      _logger.e('Stack trace: $stackTrace');
      emit(const OutfitReviewError('Failed to load outfit items'));
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
