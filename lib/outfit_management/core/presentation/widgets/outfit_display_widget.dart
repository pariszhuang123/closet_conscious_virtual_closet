import 'package:flutter/material.dart';
import 'outfit_image_widget.dart';
import '../../../../outfit_management/core/data/models/monthly_calendar_response.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../generated/l10n.dart';

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

    // ✅ Ignore "cc_none" and treat as no outfit image
    final bool hasValidOutfitImage =
        outfit.outfitImageUrl != null && outfit.outfitImageUrl != "cc_none";

    if (outfit.item == null) {
      logger.e('❌ No item found in OutfitData for outfitId: ${outfit.outfitId}');
    } else {
      logger.i('✅ Found item: ${outfit.item!.name}, imageUrl: ${outfit.item!.imageUrl}');
    }

    // ✅ If `outfit.item` exists, use it (Calendar case)
    final bool hasValidItemImage =
        outfit.item != null && outfit.item!.imageUrl.isNotEmpty;

    // ✅ Log when no valid image is found
    if (!hasValidOutfitImage && !hasValidItemImage) {
      logger.w('Outfit ${outfit.outfitId} has no outfit image and no valid item image.');
    }

    return hasValidOutfitImage
        ? OutfitImageWidget(
      key: ValueKey('outfit-image-${outfit.outfitId}'),
      imageUrl: outfit.outfitImageUrl!,
      imageSize: imageSize,
      isActive: outfit.isActive ?? true, // ✅ Default true
    )
        : hasValidItemImage
        ? OutfitImageWidget(
      key: ValueKey('outfit-item-image-${outfit.outfitId}'),
      imageUrl: outfit.item!.imageUrl,
      imageSize: imageSize,
      isActive: outfit.item!.itemIsActive, // ✅ Ensure default value
    )
        : Center(
      child: Text(
        S.of(context).noOutfitsAvailable,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
