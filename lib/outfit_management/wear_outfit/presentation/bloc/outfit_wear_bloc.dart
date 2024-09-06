import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/data/models/outfit_item_minimal.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../user_management/user_service_locator.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../core/data/services/outfits_fetch_service.dart';
import '../../../core/data/services/outfits_save_service.dart';

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

  void _onConfirmOutfitCreation(
      ConfirmOutfitCreation event, Emitter<OutfitWearState> emit) {
    logger.i('Outfit creation confirmed');
    emit(OutfitCreationSuccess());
  }
}
