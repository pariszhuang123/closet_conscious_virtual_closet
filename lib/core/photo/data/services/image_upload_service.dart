import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/config/supabase_config.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../user_management/user_service_locator.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';


class ImageUploadService {
  final CustomLogger logger;

  ImageUploadService() : logger = CustomLogger('ImageUploadService');

  Future<String?> uploadImage(File imageFile) async {
    try {
      // Fetch the AuthBloc instance from the service locator
      final authBloc = locator<AuthBloc>();
      final userId = authBloc.userId;

      if (userId != null) {
        final imageBytes = await imageFile.readAsBytes();
        final uuid = const Uuid().v4();
        final imagePath = '/$userId/$uuid.jpg';

        await SupabaseConfig.client.storage.from('item_pics').uploadBinary(
          imagePath,
          imageBytes,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

        // Generate the public URL for the uploaded image
        String imageUrl = SupabaseConfig.client.storage
            .from('item_pics')
            .getPublicUrl(imagePath);
        imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
          't': DateTime.now().millisecondsSinceEpoch.toString()
        }).toString();

        return imageUrl;
      } else {
        logger.e('User not authenticated');
        return null;
      }
    } catch (e) {
      logger.e('Error uploading image: $e');
      return null; // Return null in case of failure
    }
  }
}
