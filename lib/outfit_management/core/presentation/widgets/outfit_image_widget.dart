import 'package:flutter/material.dart';
import '../../../../core/user_photo/presentation/widgets/base/user_photo.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/utilities/logger.dart';

class OutfitImageWidget extends StatelessWidget {
  final String imageUrl;
  final ImageSize imageSize;

  const OutfitImageWidget({
    super.key,
    required this.imageUrl,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('OutfitImageWidget');
    logger.i('Rendering OutfitImageWidget with imageUrl: $imageUrl, imageSize: $imageSize');

    return UserPhoto(
      imageUrl: imageUrl,
      imageSize: imageSize,
    );
  }
}
