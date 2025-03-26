import 'package:flutter/material.dart';

import 'outfit_image_widget.dart';
import '../../../core/data/models/outfit_data.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/utilities/helper_functions/image_helper/image_helper.dart';

class OutfitDisplayWidget extends StatelessWidget {
  final OutfitData outfit;
  final ImageSize imageSize;

  const OutfitDisplayWidget({
    super.key,
    required this.outfit,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('OutfitDisplayWidget');
    logger.i('Building OutfitDisplayWidget for outfitId: ${outfit.outfitId}.');

    final bool hasValidOutfitImage =
        outfit.outfitImageUrl != null && outfit.outfitImageUrl != "cc_none";

    final firstItem = outfit.items?.isNotEmpty == true ? outfit.items!.first : null;
    final String? itemImagePath = firstItem != null
        ? getImagePathFromSource(firstItem.imageSource)
        : null;

    final bool hasValidItemImage = itemImagePath != null && itemImagePath.isNotEmpty;

    if (firstItem == null) {
      logger.e('❌ No item found in OutfitData for outfitId: ${outfit.outfitId}');
    } else {
      logger.i('✅ Found item: ${firstItem.name}, imagePath: $itemImagePath');
    }

    if (!hasValidOutfitImage && !hasValidItemImage) {
      logger.w('Outfit ${outfit.outfitId} has no outfit image and no valid item image.');
    }

    return hasValidOutfitImage
        ? OutfitImageWidget(
      key: ValueKey('outfit-image-${outfit.outfitId}'),
      imageUrl: outfit.outfitImageUrl!,
      imageSize: imageSize,
      isActive: outfit.isActive ?? true,
    )
        : hasValidItemImage
        ? OutfitImageWidget(
      key: ValueKey('outfit-item-image-${outfit.outfitId}'),
      imageUrl: itemImagePath,
      imageSize: imageSize,
      isActive: firstItem!.itemIsActive,
    )
        : Center(
      child: Text(
        S.of(context).noOutfitsAvailable,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
