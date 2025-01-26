import 'package:flutter/material.dart';
import 'outfit_item_grid.dart';
import 'outfit_image_widget.dart';
import '../../../../outfit_management/core/data/models/monthly_calendar_response.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/utilities/logger.dart';

class OutfitDisplayWidget extends StatelessWidget {
  final OutfitData outfit;
  final int crossAxisCount;
  final ImageSize imageSize;
  final bool isSelectable;
  final VoidCallback? onNavigate;
  final ValueChanged<String>? onOutfitSelected;

  const OutfitDisplayWidget({
    super.key,
    required this.outfit,
    required this.crossAxisCount,
    required this.imageSize,
    required this.isSelectable,
    this.onNavigate,
    this.onOutfitSelected,
  });

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('OutfitDisplayWidget');
    logger.i('Building OutfitDisplayWidget for outfitId: ${outfit.outfitId}.');

    final isGridDisplay = outfit.outfitImageUrl == 'cc_none';

    return GestureDetector(
      onTap: () {
        if (isSelectable) {
          logger.d('Outfit selected: ${outfit.outfitId}');
          // Trigger the outfit selection callback
          onOutfitSelected?.call(outfit.outfitId);
        } else {
          logger.d('Navigating to outfitId: ${outfit.outfitId}');
          // Trigger the navigation callback
          onNavigate?.call();
        }
      },
      child: isGridDisplay
          ? OutfitItemGrid(
        key: ValueKey('outfit-grid-${outfit.outfitId}'),
        items: outfit.items ?? [],
        crossAxisCount: crossAxisCount,
      )
          : OutfitImageWidget(
        key: ValueKey('outfit-image-${outfit.outfitId}'),
        imageUrl: outfit.outfitImageUrl!,
        imageSize: imageSize,
      ),
    );
  }
}
