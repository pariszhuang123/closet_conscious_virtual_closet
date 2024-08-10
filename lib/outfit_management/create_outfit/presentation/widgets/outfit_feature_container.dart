import 'package:flutter/material.dart';
import '../../../../core/widgets/base_container.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/widgets/button/number_type_button.dart';
import '../../../../core/theme/themed_svg.dart';

class OutfitFeatureContainer extends StatelessWidget {
  final ThemeData theme;
  final dynamic filterData;
  final dynamic calendarData;
  final dynamic outfitsUploadData;
  final int outfitCount;
  final VoidCallback onFilterButtonPressed;
  final VoidCallback onCalendarButtonPressed;

  const OutfitFeatureContainer({
    super.key,
    required this.theme,
    required this.filterData,
    required this.calendarData,
    required this.outfitsUploadData,
    required this.outfitCount,
    required this.onFilterButtonPressed,
    required this.onCalendarButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      theme: theme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              NavigationTypeButton(
                label: filterData.getName(context),
                selectedLabel: '',
                onPressed: onFilterButtonPressed,
                assetPath: filterData.assetPath ?? '',
                isFromMyCloset: false,
                buttonType: ButtonType.secondary,
                usePredefinedColor: false,
              ),
              NavigationTypeButton(
                label: calendarData.getName(context),
                selectedLabel: '',
                onPressed: onCalendarButtonPressed,
                assetPath: calendarData.assetPath ?? '',
                isFromMyCloset: false,
                buttonType: ButtonType.secondary,
                usePredefinedColor: false,
              ),
            ],
          ),
          Tooltip(
            message: outfitsUploadData.getName(context),
            child: NumberTypeButton(
              count: outfitCount,
              assetPath: outfitsUploadData.assetPath ?? '',
              isFromMyCloset: false,
              isHorizontal: false,
              buttonType: ButtonType.secondary,
              usePredefinedColor: false,
            ),
          ),
        ],
      ),
    );
  }
}
