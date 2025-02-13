import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/models/daily_calendar_outfit.dart';
import '../widgets/carousel_outfit.dart';
import '../../../../../core/widgets/container/logo_text_container.dart';
import '../../../../../core/core_enums.dart';
import '../widgets/review_comment_row.dart';
import '../../../../../core/widgets/layout/page_indicator.dart';

class DailyCalendarCarousel extends StatefulWidget {
  final List<DailyCalendarOutfit> outfits;
  final ThemeData theme;
  final int crossAxisCount;

  const DailyCalendarCarousel({
    super.key,
    required this.outfits,
    required this.theme,
    required this.crossAxisCount,
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
                  LogoTextContainer(
                    themeData: widget.theme,
                    text: (outfits[index].eventName == 'cc_none')
                        ? S.of(context).outfitReviewTitle
                        : outfits[index].eventName,
                    isFromMyCloset: false,
                    buttonType: ButtonType.primary,
                    isSelected: false,
                    usePredefinedColor: true,
                  ),

                  const SizedBox(height: 8),

                  // Outfit Image (CarouselOutfit)
                  Expanded(
                    child: CarouselOutfit(
                      outfit: outfits[index],
                      crossAxisCount: widget.crossAxisCount,
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
