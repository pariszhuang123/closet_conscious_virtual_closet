import 'package:flutter/material.dart';
import '../../../../screens/my_closet.dart';
import '../../data/services/upload_service.dart';
import '../../../../user_management/authentication/presentation/bloc/authentication_bloc.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/theme/my_closet_theme.dart';
import '../../../../core/theme/my_outfit_theme.dart';

class NavigationHelper {
  final CustomLogger logger;

  NavigationHelper(this.logger);

  Future<void> uploadAndNavigate(
      BuildContext context,
      AuthBloc authBloc,
      String? itemName,
      String? amount,
      String? itemType,
      String? occasion,
      String? season,
      String? color,
      String? colorVariation,
      String? clothingType,
      String? clothingLayer,
      String? imagePath,
      ) async {
    authBloc.add(CheckAuthStatusEvent());
    logger.d('CheckAuthStatusEvent added');

    await Future.delayed(const Duration(milliseconds: 500));

    if (!context.mounted) return;

    final authState = authBloc.state;
    logger.d('Auth state: $authState');

    if (authState is Unauthenticated) {
      _showSnackbar(context, 'User is not authenticated.');
      logger.e('User is not authenticated');
      return;
    }

    if (authState is Authenticated) {
      final user = authState.user;
      logger.d('User authenticated: ${user.id}');

      final fields = [
        itemName,
        amount,
        itemType,
        occasion,
        season,
        color,
        colorVariation,
        clothingType,
        clothingLayer,
      ];

      logger.d('Fields before validation: $fields');

      if (!_areFieldsValid([
        itemName,
        amount,
        itemType,
        occasion,
        season,
        color,
        clothingType,
        clothingLayer,
      ])) {
        _showSnackbar(context, 'Please complete all fields.');
        logger.w('Validation failed: Incomplete fields');
        return;
      }

      try {
        final uploadService = UploadService(authBloc);

        logger.d('Uploading image');
        final imageUrl = await uploadService.uploadImage(imagePath!);
        logger.d('Image uploaded, URL: $imageUrl');

        logger.d('Inserting item data');
        final itemId = await uploadService.insertItemData(
          user.id,
          itemName!,
          amount!,
          itemType!,
          occasion!,
          season!,
          color!,
          colorVariation!,
          imageUrl,
        );
        logger.d('Item data inserted, ID: $itemId');

        logger.d('Inserting clothing data');
        await uploadService.insertClothingData(itemId, user.id, clothingType!, clothingLayer!);
        logger.d('Clothing data inserted');

        if (!context.mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyClosetPage(
              myClosetTheme: myClosetTheme,
              myOutfitTheme: myOutfitTheme
          )),
        );
      } catch (e) {
        _showSnackbar(context, 'An error occurred: $e');
        logger.e('An error occurred during upload and navigate: $e');
      }
    }
  }

  bool _areFieldsValid(List<String?> fields) {
    return fields.every((field) => field != null && field.isNotEmpty);
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void nextPage(
      BuildContext context,
      PageController pageController,
      int currentPage,
      Function(int) validateFields,
      Function() uploadAndNavigate,
      ) {
    if (validateFields(currentPage)) {
      if (currentPage < 2) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else {
        uploadAndNavigate();
        logger.d('Upload and navigate triggered');
      }
    } else {
      _showSnackbar(context, 'Please complete all required fields.');
      logger.w('Page navigation validation failed: Please complete all required fields.');
    }
  }
}
