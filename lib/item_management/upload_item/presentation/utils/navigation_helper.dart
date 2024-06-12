import 'package:flutter/material.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../screens/my_closet.dart';
import '../../data/services/upload_service.dart';
import '../../../../user_management/authentication/presentation/bloc/authentication_bloc.dart';


class NavigationHelper {
  static Future<void> uploadAndNavigate(
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
    final user = SupabaseConfig.client.auth.currentUser;

    if (user == null || !_areFieldsValid([
      itemName, amount, itemType, occasion, season, color, clothingType, clothingLayer, imagePath
    ])) {
      _showSnackbar(context, 'Please complete all fields.');
      return;
    }

    try {
      final uploadService = UploadService(authBloc);

      final imageUrl = await uploadService.uploadImage(imagePath!);
      final itemId = await uploadService.insertItemData(user.id, itemName!, amount!, itemType!, occasion!, season!, color!, colorVariation!, imageUrl);
      await uploadService.insertClothingData(itemId, user.id, clothingType!, clothingLayer!);

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyClosetPage()),
      );
    } catch (e) {
      _showSnackbar(context, 'An error occurred: $e');
    }
  }

  static bool _areFieldsValid(List<String?> fields) {
    return fields.every((field) => field != null && field.isNotEmpty);
  }

  static void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void nextPage(
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
      }
    } else {
      _showSnackbar(context, 'Please complete all required fields.');
    }
  }
}
