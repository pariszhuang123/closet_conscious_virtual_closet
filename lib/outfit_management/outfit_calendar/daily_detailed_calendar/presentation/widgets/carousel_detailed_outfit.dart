import 'package:flutter/material.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/models/daily_calendar_outfit.dart';
import '../../../../core/presentation/widgets/outfit_image_widget.dart';
import '../../../../../core/core_enums.dart';

class CarouselDetailedOutfit extends StatelessWidget {
  final DailyCalendarOutfit outfit;
  final int crossAxisCount;
  final bool isSelected;
  final VoidCallback onOutfitTap;

  static final _logger = CustomLogger('CarouselDetailedOutfit');

  const CarouselDetailedOutfit({
    super.key,
    required this.outfit,
    required this.crossAxisCount,
    required this.isSelected,
    required this.onOutfitTap,
  });

  @override
  Widget build(BuildContext context) {

    _logger.d('Building CarouselOutfit for outfitId: ${outfit.outfitId}');

    return GestureDetector(
      onTap: onOutfitTap,
      child: OutfitImageWidget(
        imageUrl: outfit.outfitImageUrl!,
        imageSize: ImageSize.itemInteraction,
        isActive: outfit.isActive,
      ),
    );
  }
}
