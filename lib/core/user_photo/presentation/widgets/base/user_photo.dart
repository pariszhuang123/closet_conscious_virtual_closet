import 'package:flutter/material.dart';
import 'dart:io';

import '../../../../data/services/core_fetch_services.dart';
import '../../../../core_enums.dart';
import '../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../utilities/helper_functions/image_helper.dart';

class UserPhoto extends StatelessWidget {
  final String? imageUrl;       // for remote
  final String? localImagePath; // for local
  final ImageSize imageSize;

  final CoreFetchService fetchService = CoreFetchService();

  UserPhoto({
    super.key,
    this.imageUrl,
    this.localImagePath,
    required this.imageSize,
  }) : assert(imageUrl != null || localImagePath != null, 'Provide at least one image source');

  @override
  Widget build(BuildContext context) {

    final dimensions = ImageHelper.getDimensions(imageSize);

    if (localImagePath != null) {
      final file = File(localImagePath!);
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: file.existsSync()
              ? Image.file(
            file,
            fit: BoxFit.cover,
            width: 114,
            height: 114,
          )
              : const Icon(Icons.broken_image),
        ),
      );
    }

    return FutureBuilder<String>(
      future: fetchService.getTransformedImageUrl(
        imageUrl!,
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
