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

    final bool hasOutfitImage = outfit.outfitImageUrl != null;
    final bool hasItemImage = outfit.item?.imageUrl != null;

    if (!hasOutfitImage && !hasItemImage) {
      logger.w('Outfit ${outfit.outfitId} has no outfit image and no valid item image.');
    }

    return hasOutfitImage
        ? OutfitImageWidget(
      key: ValueKey('outfit-image-${outfit.outfitId}'),
      imageUrl: outfit.outfitImageUrl!,
      imageSize: imageSize,
      isActive: outfit.isActive ?? true, // ✅ Provide a default value
    )
        : hasItemImage
        ? OutfitImageWidget(
      key: ValueKey('outfit-item-image-${outfit.outfitId}'),
      imageUrl: outfit.item!.imageUrl,
      imageSize: imageSize,
      isActive: outfit.item!.itemIsActive, // ✅ Pass itemIsActive for item
    )
        : Center(
      child: Text(
        S.of(context).noOutfitsAvailable,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
