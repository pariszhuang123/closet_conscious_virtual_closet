import 'package:flutter/material.dart';
import '../base_layout/base_grid.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../outfit_management/outfit_calendar/daily_calendar/presentation/widgets/carousel_outfit.dart';
import '../../../../outfit_management/core/data/models/daily_calendar_outfit.dart';
import '../../../../outfit_management/core/data/models/outfit_data.dart';

// ✅ Allow both `OutfitData` and `DailyCalendarOutfit`
class InteractiveOutfitGrid<T> extends StatelessWidget {
  final List<T> outfits;
  final int crossAxisCount;
  final Function(String outfitId) onOutfitTap;

  static final _logger = CustomLogger('InteractiveOutfitGrid');

  const InteractiveOutfitGrid({
    super.key,
    required this.outfits,
    required this.crossAxisCount,
    required this.onOutfitTap,
  });

  @override
  Widget build(BuildContext context) {
    _logger.d('Building InteractiveOutfitGrid with ${outfits.length} outfits');

    return BaseGrid<T>(
      items: outfits, // ✅ Works with both models
      crossAxisCount: crossAxisCount,
      itemBuilder: (context, outfit, index) {
        return CarouselOutfit(
          outfit: outfit,
          crossAxisCount: crossAxisCount,
          isSelected: false,
          onTap: () {
            final outfitId = (outfit is DailyCalendarOutfit)
                ? outfit.outfitId
                : (outfit as OutfitData).outfitId; // ✅ Handles both types
            _logger.d('Tapped outfitId: $outfitId');
            onOutfitTap(outfitId);
          },
        );
      },
    );
  }
}
