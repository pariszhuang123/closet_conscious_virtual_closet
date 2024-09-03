import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

import '../../../../core/usecase/photo_capture_service.dart';
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
  final PhotoCaptureService photoCaptureService;
  final OutfitFetchService outfitFetchService;
  final OutfitSaveService outfitSaveService;

  OutfitWearBloc({
    required this.photoCaptureService,
    required this.outfitFetchService,
    required this.outfitSaveService,
  }) :
        authBloc = locator<AuthBloc>(),
        logger = CustomLogger('OutfitWearBlocLogger'),
        super(OutfitWearInitial()) {
    on<CheckForOutfitImageUrl>(_onCheckForOutfitImageUrl);
    on<TakeSelfie>(_onTakeSelfie);
    on<ConfirmOutfitCreation>(_onConfirmOutfitCreation);
  }

  void _onCheckForOutfitImageUrl(
      CheckForOutfitImageUrl event, Emitter<OutfitWearState> emit) async {
    emit(OutfitWearLoading());
    logger.i('Starting _onCheckForOutfitImageUrl');

    try {
      // Fetch the image URL
      final imageUrl = await outfitFetchService.fetchOutfitImageUrl(event.outfitId);

      // Check if imageURL is not the default 'cc_none' or any placeholder indicating no actual image
      if (imageUrl != null && imageUrl != 'cc_none') {
        logger.i('_onCheckForOutfitImageUrl: Custom image URL found');
        emit(OutfitImageUrlAvailable(imageUrl)); // Emit state with the provided image URL
      } else {
        logger.i('_onCheckForOutfitImageUrl: No custom image, fetching items');
        final selectedItems = await outfitFetchService.fetchOutfitItems(event.outfitId); // Fetch outfit items

        if (selectedItems.isEmpty) {
          logger.w('_onCheckForOutfitImageUrl: No items found for outfit');
          emit(const OutfitWearError('No items found for this outfit')); // Emit error state
        } else {
          logger.i('_onCheckForOutfitImageUrl: Items fetched successfully');
          emit(OutfitWearLoaded(selectedItems)); // Emit loaded state with items
        }
      }
    } catch (e) {
      logger.e('_onCheckForOutfitImageUrl: Failed to load outfit details: $e');
      emit(const OutfitWearError('Failed to load outfit details')); // Emit error state on exception
    }
  }

  void _onTakeSelfie(TakeSelfie event, Emitter<OutfitWearState> emit) async {
    final authState = authBloc.state;
    if (authState is Authenticated) {
      emit(OutfitWearLoading());
      logger.i('Starting _onTakeSelfie');

      final String userId = authState.user.id;

      try {
        final File? imageFile = await photoCaptureService.captureAndResizePhoto();

        if (imageFile == null) {
          logger.w('_onTakeSelfie: No image captured for user: $userId');
          emit(const OutfitWearError('No photo was taken'));
          return;
        }

        final String imageUrl = await outfitSaveService.uploadImage(userId, imageFile);

        // Process the uploaded image with the outfit ID
        await outfitSaveService.processUploadedImage(imageUrl, event.outfitId);

        final OutfitItemMinimal selfieItem = OutfitItemMinimal(
          itemId: const Uuid().v4(),
          imageUrl: imageUrl,
          name: "Selfie",
        );
        emit(SelfieTaken([selfieItem]));

        logger.i(
            '_onTakeSelfie: Selfie upload and processing completed for user: $userId');
      } catch (e) {
        logger.e(
            '_onTakeSelfie: Failed to capture and save selfie for user: $userId, error: $e');
        emit(const OutfitWearError('Failed to take selfie'));
      }
    } else {
      logger.w(
          '_onTakeSelfie: Attempted selfie capture by unauthenticated user');
      emit(const OutfitWearError('User not authenticated'));
    }
  }

  void _onConfirmOutfitCreation(
      ConfirmOutfitCreation event, Emitter<OutfitWearState> emit) {
    logger.i('Outfit creation confirmed');
    emit(OutfitCreationSuccess());
  }
}
