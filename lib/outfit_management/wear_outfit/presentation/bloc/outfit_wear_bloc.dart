import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'dart:async';
import 'package:uuid/uuid.dart';

import '../../../../core/usecase/photo_capture_service.dart';
import '../../../core/data/models/outfit_item_minimal.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../core/data/services/outfits_fetch_service.dart';
import '../../../../core/core_service_locator.dart';

part 'outfit_wear_event.dart';
part 'outfit_wear_state.dart';

class OutfitWearBloc extends Bloc<OutfitWearEvent, OutfitWearState> {
  final SupabaseClient supabaseClient;
  final CustomLogger logger;
  final AuthBloc authBloc;
  final PhotoCaptureService photoCaptureService;
  final OutfitFetchService _outfitFetchService;

  OutfitWearBloc({
    required this.authBloc,
    required this.photoCaptureService,
    required OutfitFetchService outfitFetchService, // Inject the service here
  })
      : supabaseClient = SupabaseConfig.client,
  // Use SupabaseConfig.client
        logger = coreLocator<CustomLogger>(
            instanceName: 'OutfitWearBlocLogger'),
  // Pre-tagged logger
        _outfitFetchService = outfitFetchService, // Assign the injected service here
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
      final imageUrl = await _outfitFetchService.fetchOutfitImageUrl(event.outfitId);

      // Check if imageURL is not the default 'cc_none' or any placeholder indicating no actual image
      if (imageUrl != null && imageUrl != 'cc_none') {
        logger.i('_onCheckForOutfitImageUrl: Custom image URL found');
        emit(OutfitImageUrlAvailable(imageUrl)); // Emit state with the provided image URL
      } else {
        logger.i('_onCheckForOutfitImageUrl: No custom image, fetching items');
        final selectedItems = await _outfitFetchService.fetchOutfitItems(event.outfitId); // Fetch outfit items

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

        final String imageUrl = await _uploadImage(userId, imageFile);
        await _processUploadedImage(imageUrl, event.outfitId);

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


  Future<String> _uploadImage(String userId, File imageFile) async {
    logger.i('Starting _uploadImage for user $userId');
    try {
      final imageBytes = await imageFile.readAsBytes();
      final String uuid = const Uuid().v4();
      final String imagePath = '/$userId/$uuid.jpg';

      await supabaseClient.storage.from('item_pics').uploadBinary(
        imagePath,
        imageBytes,
        fileOptions: const FileOptions(
          upsert: true,
          contentType: 'image/jpeg',
        ),
      );

      logger.i('_uploadImage: Image uploaded successfully for user $userId');
      final String publicUrlWithTimestamp = _generatePublicUrlWithTimestamp(imagePath);
      return publicUrlWithTimestamp;
    } catch (e) {
      logger.e('_uploadImage: Error uploading image for user $userId, error: $e');
      throw Exception('Image upload failed');
    }
  }

  String _generatePublicUrlWithTimestamp(String imagePath) {
    final String url = supabaseClient.storage.from('item_pics').getPublicUrl(imagePath);
    return Uri.parse(url).replace(queryParameters: {
      't': DateTime.now().millisecondsSinceEpoch.toString()
    }).toString();
  }

  Future<void> _processUploadedImage(String imageUrl, String outfitId) async {
    logger.i('Starting _processUploadedImage for outfit $outfitId');
    try {
      final response = await supabaseClient.rpc('upload_outfit_selfie', params: {
        '_image_url': imageUrl,
        '_outfit_id': outfitId,
      });

      if (response is! Map<String, dynamic> || response['status'] != 'success') {
        logger.w('_processUploadedImage: RPC call returned an unexpected response for outfit $outfitId: $response');
        throw Exception('RPC call failed');
      }

      logger.i('_processUploadedImage: Image processing completed successfully for outfit $outfitId');
    } catch (e) {
      logger.e('_processUploadedImage: Error processing uploaded image for outfit $outfitId, error: $e');
      throw Exception('Processing uploaded image failed');
    }
  }
  void _onConfirmOutfitCreation(
      ConfirmOutfitCreation event, Emitter<OutfitWearState> emit) {
    logger.i('Outfit creation confirmed');
    emit(OutfitCreationSuccess());
  }

}

