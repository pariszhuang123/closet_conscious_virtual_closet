import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  List<String> selectedItems = [];

  OutfitReviewBloc() : super(OutfitReviewInitial()) {
    on<CheckAndLoadOutfit>(_onCheckAndLoadOutfit);
    on<CheckForOutfitImageUrl>(_onCheckForOutfitImageUrl);
    on<FeedbackSelected>(_onFeedbackSelected);
    on<FetchOutfitItems>(_onFetchOutfitItems);
  }

  Future<void> _onCheckAndLoadOutfit(CheckAndLoadOutfit event,
      Emitter<OutfitReviewState> emit) async {
    final authState = _authBloc.state;
    if (authState is Authenticated) {
      emit(OutfitReviewLoading());
      _logger.i('Starting _onCheckAndLoadOutfit');

      final String userId = authState.user.id;


      try {
        _logger.i('Fetching outfit for user $userId');

        final response = await Supabase.instance.client
            .from('outfits')
            .select('outfit_id, feedback')
            .eq('auth_uid', userId) // Use the current user ID
            .eq('reviewed', false)
            .order('updated_at', ascending: true)
            .single();

        final outfitId = response['outfit_id'];
        final feedback = response['feedback'];


        if (feedback == 'pending' || feedback == 'like') {
          add(CheckForOutfitImageUrl(outfitId));
        } else {
          add(FetchOutfitItems(outfitId));
        }
      } catch (e) {
        _logger.e('Failed to load outfit: $e');
        emit(NavigateToMyCloset());
      }
    }
  }
  Future<void> _onCheckForOutfitImageUrl(CheckForOutfitImageUrl event,
      Emitter<OutfitReviewState> emit) async {
    _logger.i('Checking for outfit image URL for outfit ${event.outfitId}');
    emit(OutfitReviewLoading());

    try {
      final imageUrl = await fetchOutfitImageUrl(event.outfitId);

      if (imageUrl != null && imageUrl != 'cc_none') {
        _logger.i('Image URL found: $imageUrl');
        emit(OutfitImageUrlAvailable(imageUrl));
      } else {
        _logger.i('No custom image, fetching items');
        add(FetchOutfitItems(event.outfitId));
      }
    } catch (e) {
      _logger.e('Failed to load outfit image URL: $e');
      emit(NavigateToMyCloset());
    }
  }

  Future<void> _onFetchOutfitItems(FetchOutfitItems event, Emitter<OutfitReviewState> emit) async {
    _logger.i('Fetching outfit items for outfit ${event.outfitId}');
    emit(OutfitReviewLoading());

    try {
      final selectedItems = await fetchOutfitItems(event.outfitId);

      if (selectedItems.isEmpty) {
        _logger.w('No items found for outfit ${event.outfitId}');
        emit(NoOutfitItemsFound());
      } else {
        _logger.i('Items fetched successfully for outfit ${event.outfitId}');
        emit(OutfitItemsLoaded(selectedItems));
      }
    } catch (e) {
      _logger.e('Failed to load outfit items: $e');
      emit(const OutfitReviewError('Failed to load outfit items'));
    }
  }

  void _onFeedbackSelected(FeedbackSelected event,
      Emitter<OutfitReviewState> emit) {
    _logger.i('Feedback selected: ${event.feedback}');
    emit(FeedbackUpdated(event.feedback));
    add(CheckAndLoadOutfit());
  }
}