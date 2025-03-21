import 'package:flutter/material.dart';

import '../../../../data/services/core_fetch_services.dart';
import '../../../../core_enums.dart';
import '../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../utilities/helper_functions/image_helper.dart';

class UserPhoto extends StatelessWidget {
  final String imageUrl;
  final ImageSize imageSize;

  final CoreFetchService fetchService = CoreFetchService();

  UserPhoto({
    super.key,
    required this.imageUrl,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {

    final dimensions = ImageHelper.getDimensions(imageSize);

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
                child: Image.network(
                  transformedImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
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
