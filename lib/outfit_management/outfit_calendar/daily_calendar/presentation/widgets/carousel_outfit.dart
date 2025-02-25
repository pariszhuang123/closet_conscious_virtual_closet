import 'package:flutter/material.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/models/daily_calendar_outfit.dart';
import '../../../../core/data/models/outfit_data.dart';
import '../../../../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../../../../../core/core_enums.dart';
import '../../../../core/presentation/widgets/outfit_image_widget.dart';

class CarouselOutfit<T> extends StatelessWidget {
  final T outfit;
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
    // ✅ Ensure type safety by using `outfit as T?` and providing default values
    final outfitId = (outfit is DailyCalendarOutfit)
        ? (outfit as DailyCalendarOutfit?)?.outfitId ?? ''
        : (outfit as OutfitData?)?.outfitId ?? '';

    final outfitImageUrl = (outfit is DailyCalendarOutfit)
        ? (outfit as DailyCalendarOutfit?)?.outfitImageUrl
        : (outfit as OutfitData?)?.outfitImageUrl;

    final isActive = (outfit is DailyCalendarOutfit)
        ? (outfit as DailyCalendarOutfit?)?.isActive ?? true
        : (outfit as OutfitData?)?.isActive ?? true;

    final items = (outfit is DailyCalendarOutfit)
        ? (outfit as DailyCalendarOutfit?)?.items ?? []
        : (outfit as OutfitData?)?.items ?? [];

    _logger.d('Building CarouselOutfit for outfitId: $outfitId');

    final isCcNone = (outfitImageUrl == 'cc_none');

    return isCcNone || outfitImageUrl == null
        ? Stack(
      children: [
        IgnorePointer(
          ignoring: true,
          child: InteractiveItemGrid(
            scrollController: ScrollController(),
            items: items,
            crossAxisCount: crossAxisCount,
            selectedItemIds: const [],
            selectionMode: SelectionMode.disabled,
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    )
        : GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: OutfitImageWidget(
        imageUrl: outfitImageUrl,
        imageSize: ImageSize.selfie,
        isActive: isActive,
      ),
    );
  }
}
