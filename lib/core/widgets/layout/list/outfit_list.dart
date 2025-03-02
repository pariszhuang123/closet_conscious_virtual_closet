import 'package:flutter/material.dart';

import '../../../utilities/logger.dart';
import '../../../../outfit_management/core/data/models/daily_calendar_outfit.dart';
import '../../../../outfit_management/core/data/models/outfit_data.dart';
import '../../../../outfit_management/outfit_calendar/daily_calendar/presentation/widgets/carousel_outfit.dart';

class OutfitList<T> extends StatelessWidget {
  final List<T> outfits;
  final int crossAxisCount;
  final Function(String outfitId) onOutfitTap;
  final VoidCallback onAction;

  static final CustomLogger _logger = CustomLogger('OutfitList');

  const OutfitList({
    super.key,
    required this.outfits,
    required this.crossAxisCount,
    required this.onOutfitTap,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    if (outfits.isEmpty) {
      _logger.w("No outfits available, returning an empty widget.");
      return const SizedBox.shrink();
    }

    _logger.d("Building OutfitList with ${outfits.length} outfits.");

    return SizedBox(
      height: 350, // ✅ Constrain height for horizontal scrolling
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // ✅ Enable horizontal scrolling
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemCount: outfits.length,
        itemBuilder: (context, index) {
          final outfit = outfits[index];

          final outfitId = (outfit is DailyCalendarOutfit)
              ? outfit.outfitId
              : (outfit as OutfitData?)?.outfitId ?? '';

          _logger.d("Rendering OutfitList item at index $index with outfitId: $outfitId");

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✅ Outfit Image Carousel
                SizedBox(
                  width: 350, // ✅ Set a width for horizontal layout
                  child: CarouselOutfit<T>(
                    outfit: outfit,
                    crossAxisCount: crossAxisCount,
                    isSelected: false,
                    onTap: () {
                      _logger.i("onOutfitTap triggered for outfitId: $outfitId");
                      onOutfitTap(outfitId);
                    },
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}

