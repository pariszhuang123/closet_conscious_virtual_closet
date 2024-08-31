import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/config/supabase_config.dart';
import '../../../../core/utilities/logger.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final String userId;

  UploadBloc({required this.userId}) : super(UploadInitial()) {
    on<StartUpload>(_onStartUpload);
    on<ValidateFormPage1>(_onValidateFormPage1);
    on<ValidateFormPage2>(_onValidateFormPage2);
    on<ValidateFormPage3>(_onValidateFormPage3);
  }

  void _onValidateFormPage1(ValidateFormPage1 event, Emitter<UploadState> emit) {
    final amountSpent = double.tryParse(event.amountSpentText);

    if (event.itemName.isEmpty) {
      emit(const FormInvalidPage1('item_name_required'));
    } else if (event.amountSpentText.isEmpty || amountSpent == null || amountSpent < 0) {
      emit(const FormInvalidPage1('invalid_amount_spent'));
    } else if (event.selectedItemType == null) {
      emit(const FormInvalidPage1('item_type_required'));
    } else if (event.selectedOccasion == null) {
      emit(const FormInvalidPage1('occasion_required'));
    } else {
      emit(FormValidPage1());
    }
  }

  void _onValidateFormPage2(ValidateFormPage2 event, Emitter<UploadState> emit) {
    if (event.selectedSeason == null) {
      emit(const FormInvalidPage2('season_required'));
    } else if (event.selectedSpecificType == null) {
      emit(const FormInvalidPage2('specific_type_required'));
    } else if (event.selectedItemType == 'clothing' && event.selectedClothingLayer == null) {
      emit(const FormInvalidPage2('clothing_layer_required'));
    } else {
      emit(FormValidPage2());
    }
  }

  void _onValidateFormPage3(ValidateFormPage3 event, Emitter<UploadState> emit) {
    if (event.selectedColour == null) {
      emit(const FormInvalidPage3('color_required'));
    } else if (event.selectedColour != 'black' && event.selectedColour != 'white' && event.selectedColourVariation == null) {
      emit(const FormInvalidPage3('color_variation_required'));
    } else {
      emit(FormValidPage3());
    }
  }

  Future<void> _onStartUpload(StartUpload event, Emitter<UploadState> emit) async {
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

  Future<String?> _saveData(
      String itemName,
      double amountSpent,
      File? imageFile,
      String? imageUrl,
      String? selectedItemType,
      String? selectedSpecificType,
      String? selectedClothingLayer,
      String? selectedOccasion,
      String? selectedSeason,
      String? selectedColour,
      String? selectedColourVariation,
      ) async {
    final logger = CustomLogger('UploadItemPage');
    String? finalImageUrl = imageUrl;
    selectedColourVariation ??= "cc_none";

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
            SupabaseConfig.client.storage.from('item_pics').getPublicUrl(imagePath);
        finalImageUrl = Uri.parse(finalImageUrl).replace(queryParameters: {
          't': DateTime.now().millisecondsSinceEpoch.toString()
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

    if (selectedItemType == 'clothing') {
      params['_clothing_type'] = selectedSpecificType;
      params['_clothing_layer'] = selectedClothingLayer;
    } else if (selectedItemType == 'shoes') {
      params['_shoes_type'] = selectedSpecificType;
    } else if (selectedItemType == 'accessory') {
      params['_accessory_type'] = selectedSpecificType;
    }

    try {
      final response = await SupabaseConfig.client.rpc(
        selectedItemType == 'clothing'
            ? 'upload_clothing_metadata'
            : selectedItemType == 'shoes'
            ? 'upload_shoes_metadata'
            : 'upload_accessory_metadata',
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
