import 'package:flutter/material.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/models/daily_calendar_outfit.dart';
import '../../../../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../../../../../core/core_enums.dart';
import '../../../../core/presentation/widgets/outfit_image_widget.dart'; // Import OutfitImageWidget

class CarouselOutfit extends StatelessWidget {
  final DailyCalendarOutfit outfit;
  final int crossAxisCount;

  static final _logger = CustomLogger('CarouselOutfit');

  const CarouselOutfit({
    super.key,
    required this.outfit,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    _logger.d('Building CarouselOutfit for outfitId: ${outfit.outfitId}');
    final isCcNone = (outfit.outfitImageUrl == 'cc_none');

    if (!isCcNone && outfit.outfitImageUrl != null) {
      _logger.i('Displaying outfit image for outfitId: ${outfit.outfitId}');
      return OutfitImageWidget(
        imageUrl: outfit.outfitImageUrl!,
        imageSize: ImageSize.selfie,
        isActive: outfit.isActive,
      );
    } else {
      _logger.i('Displaying item grid for outfitId: ${outfit.outfitId}');
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InteractiveItemGrid(
          scrollController: ScrollController(),
          items: outfit.items,
          crossAxisCount: crossAxisCount,
          selectedItemIds: const [],
          isDisliked: false,
          selectionMode: SelectionMode.disabled,
        ),
      );
    }
  }
}
