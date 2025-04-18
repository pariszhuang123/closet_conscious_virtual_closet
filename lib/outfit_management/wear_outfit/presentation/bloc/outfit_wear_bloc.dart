import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../user_management/user_service_locator.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../core/data/services/outfits_fetch_services.dart';
import '../../../core/data/services/outfits_save_services.dart';

part 'outfit_wear_event.dart';
part 'outfit_wear_state.dart';

class OutfitWearBloc extends Bloc<OutfitWearEvent, OutfitWearState> {
  final CustomLogger logger;
  final AuthBloc authBloc;
  final OutfitFetchService outfitFetchService;
  final OutfitSaveService outfitSaveService;

  OutfitWearBloc({
    required this.outfitFetchService,
    required this.outfitSaveService,
  }) :
        authBloc = locator<AuthBloc>(),
        logger = CustomLogger('OutfitWearBlocLogger'),
        super(OutfitWearInitial()) {
    on<CheckForOutfitImageUrl>(_onCheckForOutfitImageUrl);
    on<ConfirmOutfitCreation>(_onConfirmOutfitCreation);
  }

  void _onCheckForOutfitImageUrl(
      CheckForOutfitImageUrl event, Emitter<OutfitWearState> emit) async {
    emit(OutfitWearLoading());
    logger.i('Starting _onCheckForOutfitImageUrl');

    try {
      final imageUrl = await outfitFetchService.fetchOutfitImageUrl(event.outfitId);

      if (imageUrl != null && imageUrl != 'cc_none') {
        logger.i('_onCheckForOutfitImageUrl: Custom image URL found');
        emit(OutfitImageUrlAvailable(imageUrl));
      } else {
        final selectedItems = await outfitFetchService.fetchOutfitItems(event.outfitId);

        if (selectedItems.isEmpty) {
          logger.w('_onCheckForOutfitImageUrl: No items found for outfit');
          emit(const OutfitWearError('No items found for this outfit'));
        } else {
          logger.i('_onCheckForOutfitImageUrl: Items fetched successfully');
          emit(OutfitWearLoaded(selectedItems));
        }
      }
    } catch (e) {
      logger.e('_onCheckForOutfitImageUrl: Failed to load outfit details: $e');
      emit(const OutfitWearError('Failed to load outfit details'));
    }
  }

  Future<void> _onConfirmOutfitCreation(
      ConfirmOutfitCreation event, Emitter<OutfitWearState> emit) async {
    logger.i('Outfit creation confirmed with event name: ${event.eventName} and outfitId: ${event.outfitId}');

    emit(OutfitWearSubmitting());

    try {
      final success = await outfitSaveService.updateOutfitEventName(
        outfitId: event.outfitId,
        eventName: event.eventName,
      );

      if (success) {
        emit(OutfitCreationSuccess());
      } else {
        emit(const OutfitWearError('Failed to update event name.'));
      }
    } catch (e) {
      logger.e('Error while submitting outfit review: $e');
      emit(const OutfitWearError('An error occurred while submitting the outfit review.'));
    }
  }
}
