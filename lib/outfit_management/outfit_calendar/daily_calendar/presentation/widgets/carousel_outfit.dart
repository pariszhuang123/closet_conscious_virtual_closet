import 'package:flutter/material.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/models/daily_calendar_outfit.dart';
import '../../../../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../../../../../core/core_enums.dart';
import '../../../../core/presentation/widgets/outfit_image_widget.dart'; // Import OutfitImageWidget

class CarouselOutfit extends StatelessWidget {
  final DailyCalendarOutfit outfit;
  final int crossAxisCount;
  final bool isSelected;
  final VoidCallback onTap;


  static final _logger = CustomLogger('CarouselOutfit');

  const CarouselOutfit({
    super.key,
    required this.outfit,
    required this.crossAxisCount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    _logger.d('Building CarouselOutfit for outfitId: ${outfit.outfitId}');
    final isCcNone = (outfit.outfitImageUrl == 'cc_none');

    return isCcNone || outfit.outfitImageUrl == null
        ? Stack(
      children: [
        // ✅ IgnorePointer ensures InteractiveItemGrid does NOT capture touch events
        IgnorePointer(
          ignoring: true,
          child: InteractiveItemGrid(
            scrollController: ScrollController(),
            items: outfit.items,
            crossAxisCount: crossAxisCount,
            selectedItemIds: const [],
            selectionMode: SelectionMode.disabled,
          ),
        ),

        // ✅ Transparent GestureDetector on top captures tap for outfitId
        Positioned.fill(
          child: GestureDetector(
            onTap: onTap, // Trigger outfitId when tapping anywhere on the grid
            behavior: HitTestBehavior.translucent, // Ensures taps pass through
          ),
        ),
      ],
    )
        : GestureDetector(
      onTap: onTap, // ✅ Capture taps when outfit image is displayed
      behavior: HitTestBehavior.opaque, // Ensure entire area is tappable
      child: OutfitImageWidget(
        imageUrl: outfit.outfitImageUrl!,
        imageSize: ImageSize.selfie,
        isActive: outfit.isActive,
      ),
    );
  }
}
