import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/config/supabase_config.dart';
import '../../../core/utilities/logger.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.imageUrl,
    required this.onUpload,
    required this.itemType,
    this.clothingType,
    this.clothingLayer,
    this.shoeType,
    this.accessoryType,

  });

  final String? imageUrl;
  final void Function(String imageUrl) onUpload;
  final String itemType; // New parameter for item type
  final String? clothingType;
  final String? clothingLayer;
  final String? shoeType;
  final String? accessoryType;

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('AvatarWidget');

    return Column(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: imageUrl != null
              ? Image.network(
            imageUrl!,
            fit: BoxFit.cover,
          )
              : Container(
            color: Colors.grey,
            child: const Center(
              child: Text('No Image'),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? image = await picker.pickImage(source: ImageSource.camera);
            if (image == null) {
              logger.w('No image selected');
              return;
            }
            final imageExtension = image.path.split('.').last.toLowerCase();
            final imageBytes = await image.readAsBytes();
            final userId = SupabaseConfig.client.auth.currentUser!.id;

            final uuid = const Uuid().v4();
            final imagePath = '/$userId/$uuid.$imageExtension';

            try {
              await SupabaseConfig.client.storage.from('item_pics').uploadBinary(
                imagePath,
                imageBytes,
                fileOptions: FileOptions(
                  upsert: true,
                  contentType: 'image/$imageExtension',
                ),
              );

              String newImageUrl = SupabaseConfig.client.storage.from('item_pics').getPublicUrl(imagePath);
              newImageUrl = Uri.parse(newImageUrl).replace(queryParameters: {
                't': DateTime.now().millisecondsSinceEpoch.toString()
              }).toString();

              final Map<String, dynamic> params = {
                '_item_type': itemType,
                '_image_url': newImageUrl,
                '_name': 'my clothing',
                '_amount_spent': 10,
                '_occasion': 'active',
                '_season': 'spring',
                '_colour': 'red',
                '_colour_variations': 'light',
              };

              if (itemType == 'clothing') {
                params['_clothing_type'] = clothingType;
                params['_clothing_layer'] = clothingLayer;
              } else if (itemType == 'shoe') {
                params['_shoe_type'] = shoeType;
              } else if (itemType == 'accessory') {
                params['_accessory_type'] = accessoryType;
              }

              final response = await SupabaseConfig.client.rpc('upload_clothing_metadata', params: {
                '_item_type': 'clothing',
                '_image_url': newImageUrl,
                '_name': 'my clothing',
                '_amount_spent': 10,
                '_occasion': 'active',
                '_season': 'spring',
                '_colour': 'red',
                '_colour_variations': 'light',
                '_clothing_type': 'top',
                '_clothing_layer': 'base_layer',
              });

              if (response.error != null) {
                logger.e('Error inserting data: ${response.error!.message}');
              } else {
                logger.i('Data inserted successfully');
                onUpload(newImageUrl);
              }
            } catch (e) {
              logger.e('Error uploading image: $e');
            }
          },
          child: const Text('Upload'),
        ),
      ],
    );
  }
}