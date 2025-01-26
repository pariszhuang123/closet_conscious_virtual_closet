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
  final Function(String) onOutfitSelected;
  final VoidCallback onNavigate;

  const DayOutfitWidget({
    super.key,
    required this.date,
    required this.outfit,
    required this.isGridDisplay,
    required this.isSelectable,
    required this.crossAxisCount,
    required this.onOutfitSelected,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('DayOutfitWidget');
    final imageSize = isGridDisplay ? ImageSize.calendarOutfitItemGrid3 : ImageSize.calendarSelfie;

    return OutfitDisplayWidget(
      outfit: outfit,
      crossAxisCount: isGridDisplay ? crossAxisCount : 1,
      imageSize: imageSize,
      isSelectable: isSelectable,
      onOutfitSelected: (outfitId) {
        logger.i('Outfit selected: $outfitId on date: $date');
        onOutfitSelected(outfitId);
      },
      onNavigate: () {
        logger.i('Navigating to outfitId: ${outfit.outfitId} on date: $date');
        onNavigate();
      },
    );
  }
}
