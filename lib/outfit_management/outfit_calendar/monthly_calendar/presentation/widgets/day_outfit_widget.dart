import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/outfit_display_widget.dart';
import '../../../../core/data/models/monthly_calendar_response.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/core_enums.dart';

class DayOutfitWidget extends StatelessWidget {
  final DateTime date;
  final OutfitData outfit;
  final bool isGridDisplay;
  final bool isSelectable;
  final int crossAxisCount;
  final List<String> selectedOutfitIds; // ✅ Tracks which outfits are selected
  final Function(String) onOutfitSelected; // ✅ Added missing function for selection
  final VoidCallback onNavigate;

  const DayOutfitWidget({
    super.key,
    required this.date,
    required this.outfit,
    required this.isGridDisplay,
    required this.isSelectable,
    required this.crossAxisCount,
    required this.selectedOutfitIds,
    required this.onOutfitSelected,  // ✅ Required for handling outfit selection
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('DayOutfitWidget');
    const imageSize = ImageSize.monthlyCalendarImage;

    final bool isSelected = selectedOutfitIds.contains(outfit.outfitId); // ✅ Uses List<String>

    logger.d('Building widget for outfit ID: ${outfit.outfitId}');
    logger.d('Grid Display: $isGridDisplay, Selected: $isSelected, Date: $date');

    return GestureDetector(
      onTap: () {
        if (isSelectable) {
          logger.i('Outfit selected: ${outfit.outfitId}');
          onOutfitSelected(outfit.outfitId);
        } else {
          logger.i('Navigating from outfit ID: ${outfit.outfitId}');
          onNavigate();
        }
      },
      child: Stack(
        children: [
          // The outfit image
          OutfitDisplayWidget(
            outfit: outfit,
            imageSize: imageSize,
          ),

          // Border overlay when selected
          if (isSelected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(8), // Match OutfitDisplayWidget corners
                ),
              ),
            ),
        ],
      ),
    );
  }
}
