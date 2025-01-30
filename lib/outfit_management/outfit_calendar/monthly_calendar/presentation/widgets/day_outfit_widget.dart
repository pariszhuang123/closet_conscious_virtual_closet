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
    final imageSize = isGridDisplay ? ImageSize.calendarOutfitItemGrid3 : ImageSize.calendarSelfie;

    final bool isSelected = selectedOutfitIds.contains(outfit.outfitId); // ✅ Uses List<String>

    logger.d('Building widget for outfit ID: ${outfit.outfitId}');
    logger.d('Grid Display: $isGridDisplay, Selected: $isSelected, Date: $date');

    return GestureDetector( // ✅ Handles taps at the DayOutfitWidget level
      onTap: () {
        if (isSelectable) {
          logger.i('Outfit selected: ${outfit.outfitId}');
          onOutfitSelected(outfit.outfitId);
        } else {
          logger.i('Navigating from outfit ID: ${outfit.outfitId}');
          onNavigate();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.primary, width: 3)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(4.0),
        child: OutfitDisplayWidget( // ✅ Keeps OutfitDisplayWidget purely visual
          outfit: outfit,
          crossAxisCount: isGridDisplay ? crossAxisCount : 1,
          imageSize: imageSize,
        ),
      ),
    );
  }
}