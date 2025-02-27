import 'package:flutter/material.dart';
import '../base_layout/base_grid.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../outfit_management/core/data/models/daily_calendar_outfit.dart';
import '../../../../outfit_management/core/data/models/outfit_data.dart';
import '../../../../core/core_enums.dart';
import '../../../../outfit_management/core/presentation/widgets/outfit_display_widget.dart';
import '../../../../../core/utilities/helper_functions/image_helper.dart'; // Import ImageHelper

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

    final ImageSize imageSize = ImageHelper.getImageSize(crossAxisCount); // Get size based on grid

    return BaseGrid<T>(
      items: outfits,
      crossAxisCount: crossAxisCount,
      itemBuilder: (context, outfit, index) {
        final outfitData = outfit is DailyCalendarOutfit
            ? OutfitData(
          outfitId: outfit.outfitId,
          outfitImageUrl: outfit.outfitImageUrl,
          items: outfit.items,
        )
            : outfit as OutfitData;

        return GestureDetector(
          onTap: () {
            _logger.d('Tapped outfitId: ${outfitData.outfitId}');
            onOutfitTap(outfitData.outfitId);
          },
          child: OutfitDisplayWidget(
            outfit: outfitData,
            imageSize: imageSize, // ✅ Dynamically pass based on crossAxisCount
          ),
        );
      },
    );
  }
}
