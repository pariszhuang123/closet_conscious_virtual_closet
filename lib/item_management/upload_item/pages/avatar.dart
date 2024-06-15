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
    required this.itemName,
    required this.itemType,
    required this.amountSpent,
    this.clothingType,
    this.clothingLayer,
    this.shoesType,
    this.accessoryType,

    required this.occasion,
    required this.season,
    required this.colour,
    required this.colourVariations,
  });

  final String? imageUrl;
  final void Function(String imageUrl) onUpload;
  final String itemName;
  final double amountSpent;
  final String itemType;
  final String? clothingType;
  final String? clothingLayer;
  final String? shoesType;
  final String? accessoryType;

  final String? occasion;
  final String? season;
  final String? colour;
  final String? colourVariations;

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
                '_name': itemName,
                '_amount_spent': amountSpent,
                '_occasion': occasion,
                '_season': season,
                '_colour': colour,
                '_colour_variations': colourVariations,
              };

              if (itemType == 'clothing') {
                params['_clothing_type'] = clothingType;
                params['_clothing_layer'] = clothingLayer;
              } else if (itemType == 'shoes') {
                params['_shoes_type'] = shoesType;
              } else if (itemType == 'accessory') {
                params['_accessory_type'] = accessoryType;
              }

              final response = await SupabaseConfig.client.rpc(
                itemType == 'clothing'
                    ? 'upload_clothing_metadata'
                    : itemType == 'shoes'
                    ? 'upload_shoes_metadata'
                    : 'upload_accessory_metadata',
                params: params,
              );

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