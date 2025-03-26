import 'package:flutter/material.dart';

import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/models/daily_calendar_outfit.dart';
import '../../../../../core/widgets/layout/carousel/carousel_outfit.dart';
import '../widgets/review_comment_row.dart';
import '../../../../../core/widgets/layout/page_indicator.dart';
import '../../../../../core/utilities/helper_functions/image_helper/image_helper.dart';
import '../../../../../core/core_enums.dart';

class DailyCalendarCarousel extends StatefulWidget {
  final List<DailyCalendarOutfit> outfits;
  final ThemeData theme;
  final int crossAxisCount;
  final Function(String outfitId) onTap; // Pass function from screen

  const DailyCalendarCarousel({
    super.key,
    required this.outfits,
    required this.theme,
    required this.crossAxisCount,
    required this.onTap, // Add callback
  });

  @override
  State<DailyCalendarCarousel> createState() => _DailyCalendarCarouselState();
}

class _DailyCalendarCarouselState extends State<DailyCalendarCarousel> {
  final CustomLogger _logger = CustomLogger('_DailyCalendarCarouselState');

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final outfits = widget.outfits;
    if (outfits.isEmpty) {
      _logger.w("No outfits available, returning an empty widget.");
      return const SizedBox.shrink();
    }

    _logger.d("Building DailyCalendarCarousel with ${outfits.length} outfits. Current index: $currentIndex");

    return Column(
      children: [
        // PageView wraps LogoTextContainer, CarouselOutfit, and ReviewAndCommentRow
        Expanded(
          child: PageView.builder(
            itemCount: outfits.length,
            onPageChanged: (index) {
              _logger.d("Page changed: previousIndex = $currentIndex, newIndex = $index");
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              _logger.d("Rendering outfit at index $index with outfitId: ${outfits[index].outfitId}");

              return Column(
                children: [
                  // Title (LogoTextContainer)
                  // Outfit Image (CarouselOutfit)
                  Expanded(
                    child: CarouselOutfit(
                      outfit: outfits[index],
                      crossAxisCount: widget.crossAxisCount,
                      isSelected: false,
                      outfitSize: OutfitSize.dailyCalendarOutfitImage,
                      getHeightForOutfitSize: ImageHelper.getHeightForOutfitSize, // ✅ Pass function dynamically
                      onTap: () {
                        widget.onTap(outfits[index].outfitId);  // Call onTap function from parent
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Review and Comment Row
                  ReviewAndCommentRow(
                    outfitId: outfits[index].outfitId,
                    feedback: outfits[index].feedback,
                    outfitComments: outfits[index].outfitComments,
                    theme: widget.theme,
                    isReadOnly: true,
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Page Indicator (Now at the very bottom)
        PageIndicator(
          itemCount: outfits.length,
          currentIndex: currentIndex,
          theme: widget.theme,
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
