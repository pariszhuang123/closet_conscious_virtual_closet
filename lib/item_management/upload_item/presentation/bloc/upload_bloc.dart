import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import '../../../../core/config/supabase_config.dart';
import '../../../../core/utilities/logger.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  UploadBloc() : super(UploadInitial()) {
    on<StartUpload>(_onStartUpload);
  }

  Future<void> _onStartUpload(StartUpload event,
      Emitter<UploadState> emit) async {
    emit(Uploading());
    emit(Uploading());
    try {
      final result = await _saveData(
        event.itemName,
        event.amountSpent,
        event.imageFile,
        event.imageUrl,
        event.selectedItemType,
        event.selectedSpecificType,
        event.selectedClothingLayer,
        event.selectedOccasion,
        event.selectedSeason,
        event.selectedColour,
        event.selectedColourVariation,
      );
      if (result == null) {
        emit(UploadSuccess());
      } else {
        emit(UploadFailure(result));
      }
    } catch (e) {
      emit(UploadFailure(e.toString()));
    }
  }

  Future<String?> _saveData(String itemName,
      double amountSpent,
      File? imageFile,
      String? imageUrl,
      String? selectedItemType,
      String? selectedSpecificType,
      String? selectedClothingLayer,
      String? selectedOccasion,
      String? selectedSeason,
      String? selectedColour,
      String? selectedColourVariation,) async {
    final logger = CustomLogger('UploadItemPage');
    final userId = SupabaseConfig.client.auth.currentUser!.id;
    String? finalImageUrl = imageUrl;

    if (imageFile != null) {
      final imageBytes = await imageFile.readAsBytes();
      final uuid = const Uuid().v4();
      final imagePath = '/$userId/$uuid.jpg';

      try {
        await SupabaseConfig.client.storage.from('item_pics').uploadBinary(
          imagePath,
          imageBytes,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

        finalImageUrl =
            SupabaseConfig.client.storage.from('item_pics').getPublicUrl(
                imagePath);
        finalImageUrl = Uri.parse(finalImageUrl).replace(queryParameters: {
          't': DateTime
              .now()
              .millisecondsSinceEpoch
              .toString()
        }).toString();
      } catch (e) {
        logger.e('Error uploading image: $e');
        throw Exception('Error uploading image: $e');
      }
    }

    final Map<String, dynamic> params = {
      '_item_type': selectedItemType,
      '_image_url': finalImageUrl,
      '_name': itemName,
      '_amount_spent': amountSpent,
      '_occasion': selectedOccasion,
      '_season': selectedSeason,
      '_colour': selectedColour,
      '_colour_variations': selectedColourVariation,
    };

    if (selectedItemType == 'Clothing') {
      params['_clothing_type'] = selectedSpecificType;
      params['_clothing_layer'] = selectedClothingLayer;
    } else if (selectedItemType == 'Shoes') {
      params['_shoes_type'] = selectedSpecificType;
    } else if (selectedItemType == 'Accessory') {
      params['_accessory_type'] = selectedSpecificType;
    }

    try {
      final response = await SupabaseConfig.client.rpc(
        selectedItemType == 'Clothing'
            ? 'update_clothing_metadata'
            : selectedItemType == 'Shoes'
            ? 'update_shoes_metadata'
            : 'update_accessory_metadata',
        params: params,
      );
      logger.i('Full response: ${jsonEncode(response)}');

      if (response is Map<String, dynamic> && response.containsKey('status')) {
        if (response['status'] == 'success') {
          logger.i('Data inserted successfully: ${jsonEncode(response)}');
          return null; // Indicating success
        } else {
          logger.e('Unexpected response format: ${jsonEncode(response)}');
          return 'Unexpected response format';
        }
      } else {
        logger.e('Unexpected response: ${jsonEncode(response)}');
        return 'Unexpected response format';
      }
    } catch (e) {
      logger.e('Unexpected error: $e');
      return 'Unexpected error: $e';
    }
  }
}