import 'package:flutter/material.dart';
import 'outfit_image_widget.dart';
import '../../../../outfit_management/core/data/models/monthly_calendar_response.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../generated/l10n.dart';

class OutfitDisplayWidget extends StatelessWidget {
  final OutfitData outfit;
  final int crossAxisCount;
  final ImageSize imageSize;

  const OutfitDisplayWidget({
    super.key,
    required this.outfit,
    required this.crossAxisCount,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('OutfitDisplayWidget');
    logger.i('Building OutfitDisplayWidget for outfitId: ${outfit.outfitId}.');

    final bool hasOutfitImage = outfit.outfitImageUrl != null && outfit.outfitImageUrl != 'cc_none';
    final bool hasValidItems = outfit.items != null && outfit.items!.isNotEmpty;

    if (!hasOutfitImage && !hasValidItems) {
      logger.w('Outfit ${outfit.outfitId} has no outfit image and no valid items.');
    }

    return hasOutfitImage
        ? OutfitImageWidget(
      key: ValueKey('outfit-image-${outfit.outfitId}'), // ✅ Matches RPC when outfit image exists
      imageUrl: outfit.outfitImageUrl!,
      imageSize: imageSize,
    )
        : hasValidItems
        ? OutfitImageWidget(
      key: ValueKey('outfit-item-image-${outfit.outfitId}'), // ✅ Matches RPC for first item image
      imageUrl: outfit.items!.first.imageUrl, // ✅ Uses the first item's image
      imageSize: imageSize,
    )
        : Center(
      child: Text(
        S.of(context).noOutfitsAvailable, // ✅ Uses localized text
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
