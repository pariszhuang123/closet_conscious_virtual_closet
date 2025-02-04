import 'package:flutter/material.dart';
import '../../../../core/user_photo/presentation/widgets/base/user_photo.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/theme/grayscale_wrapper.dart';

class OutfitImageWidget extends StatelessWidget {
  final String imageUrl;
  final ImageSize imageSize;
  final bool isActive;

  const OutfitImageWidget({
    super.key,
    required this.imageUrl,
    required this.imageSize,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('OutfitImageWidget');
    logger.i('Rendering OutfitImageWidget with imageUrl: $imageUrl, imageSize: $imageSize, isActive: $isActive');

    return GrayscaleWrapper(
      applyGrayscale: !isActive, // ✅ Now supports any boolean condition
      child: UserPhoto(
        imageUrl: imageUrl,
        imageSize: imageSize,
      ),
    );
  }
}
