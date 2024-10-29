import 'package:flutter/material.dart';
import '../../../../data/services/core_fetch_services.dart';
import '../../../../core_enums.dart';
import '../../../../widgets/progress_indicator/closet_progress_indicator.dart';

class UserPhoto extends StatelessWidget {
  final String imageUrl;
  final ImageSize imageSize;

  final CoreFetchService fetchService = CoreFetchService();

  UserPhoto({
    super.key,
    required this.imageUrl,
    required this.imageSize,
  });

  Map<String, int> getDimensions(ImageSize size) {
    switch (size) {
      case ImageSize.selfie:
        return {'width': 450, 'height': 450}; // Dimensions for selfies
      case ImageSize.itemInteraction:
        return {'width': 275, 'height': 275}; // Dimensions for item interaction screen
      case ImageSize.itemGrid2:
        return {'width': 275, 'height': 275}; // Grid 2 dimensions
      case ImageSize.itemGrid3:
        return {'width': 175, 'height': 175}; // Dimensions for item grid (3 per row)
      case ImageSize.itemGrid5:
        return {'width': 110, 'height': 110}; // Dimensions for item grid (5 per row)
      case ImageSize.itemGrid7:
        return {'width': 60, 'height': 60}; // Grid 7 dimensions

      default:
        return {'width': 175, 'height': 175}; // Fallback dimensions
    }
  }

  @override
  Widget build(BuildContext context) {

    final dimensions = getDimensions(imageSize);

    return FutureBuilder<String>(
      future: fetchService.getTransformedImageUrl(
        imageUrl,
        'item_pics',
        width: dimensions['width'],
        height: dimensions['height'],
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ClosetProgressIndicator();
        } else if (snapshot.hasError) {
          return const Icon(Icons.error);
        } else if (snapshot.hasData) {
          String transformedImageUrl = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: AspectRatio(
                aspectRatio: 1.0, // Adjust aspect ratio as needed
                child: Image.network(
                  transformedImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        } else {
          return const Icon(Icons.error);
        }
      },
    );
  }
}
