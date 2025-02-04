import 'package:flutter/material.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/type_data.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/core_enums.dart';

class OutfitReviewButton extends StatelessWidget {
  final String outfitId;
  final String? feedback; // Feedback from DailyCalendarOutfit
  static final _logger = CustomLogger('ReviewButton');

  const OutfitReviewButton({
    super.key,
    required this.outfitId,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    // Determine button type based on feedback
    TypeData? typeData;

    switch (feedback) {
      case 'like':
        typeData = TypeDataList.outfitReviewLike(context);
        break;
      case 'alright':
        typeData = TypeDataList.outfitReviewAlright(context);
        break;
      case 'dislike':
        typeData = TypeDataList.outfitReviewDislike(context);
        break;
      default:
        return const SizedBox.shrink(); // No button if no feedback exists
    }

    _logger.i('Displaying review button: ${typeData.getName(context)} for outfitId: $outfitId');

    return NavigationTypeButton(
      label: typeData.getName(context),
      selectedLabel: typeData.getName(context),
      onPressed: () => _logger.i('Review button pressed: ${typeData?.getName(context) ?? ''
      } for outfitId: $outfitId'),
      assetPath: typeData.assetPath,
      isFromMyCloset: false,
      buttonType: ButtonType.primary,
      isSelected: true,
      usePredefinedColor: false,
    );
  }
}
