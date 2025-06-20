import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/models/daily_calendar_outfit.dart';
import '../widgets/carousel_detailed_outfit.dart';
import '../../../../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../../../../../core/widgets/container/logo_text_container.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../core/widgets/layout/page_indicator.dart';
import '../../../../../core/widgets/feedback/custom_snack_bar.dart';

class DailyDetailedCalendarCarousel extends StatefulWidget {
  final List<DailyCalendarOutfit> outfits;
  final ThemeData theme;
  final int crossAxisCount;
  final Function(String outfitId) onOutfitTap; // ✅ Add this
  final VoidCallback onAction; // ✅ Now handles item taps via `onAction`


  const DailyDetailedCalendarCarousel({
    super.key,
    required this.outfits,
    required this.theme,
    required this.crossAxisCount,
    required this.onOutfitTap, // ✅ Fix: Now defined
    required this.onAction, // ✅ Pass this to trigger item tap navigation

  });

  @override
  State<DailyDetailedCalendarCarousel> createState() => _DailyDetailedCalendarCarouselState();
}

class _DailyDetailedCalendarCarouselState extends State<DailyDetailedCalendarCarousel> {
  final CustomLogger _logger = CustomLogger('_DailyDetailedCalendarCarouselState');

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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0), // ✅ Added padding
                    child: LogoTextContainer(
                      themeData: widget.theme,
                      text: (outfits[index].eventName == 'cc_none')
                          ? S.of(context).outfitReviewTitle
                          : outfits[index].eventName,
                      isFromMyCloset: false,
                      buttonType: ButtonType.primary,
                      isSelected: false,
                      usePredefinedColor: true,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Outfit Image (CarouselOutfit)
                  if (outfits[index].outfitImageUrl != 'cc_none' && outfits[index].outfitImageUrl != null)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25, // Adjust the factor as needed
                      child: CarouselDetailedOutfit(
                        outfit: outfits[index],
                        crossAxisCount: widget.crossAxisCount,
                        isSelected: false,
                        onOutfitTap: () {
                          widget.onOutfitTap(outfits[index].outfitId);
                        },
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Interactive Item Grid (Displays items for the selected outfit)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0), // ✅ Added padding
                      child: InteractiveItemGrid(
                        usePagination: true,
                        crossAxisCount: widget.crossAxisCount,
                        selectedItemIds: const [],
                        itemSelectionMode: ItemSelectionMode.action,
                        isOutfit: false,
                        isLocalImage: false,
                        onAction: () {
                          _logger.d("Item tapped in grid, triggering navigation");
                          widget.onAction();
                        },
                        onInactiveTap: () {
                          // Show the custom snackbar using localization
                          CustomSnackbar(
                            message: S.of(context).itemInactiveMessage,
                            theme: Theme.of(context),
                          ).show(context);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

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
