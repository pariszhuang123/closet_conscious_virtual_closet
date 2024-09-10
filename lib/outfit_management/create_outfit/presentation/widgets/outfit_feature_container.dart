import 'package:flutter/material.dart';
import '../../../../core/widgets/container/base_container.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/widgets/button/number_type_button.dart';
import '../../../../core/theme/themed_svg.dart';
import '../../../../core/data/type_data.dart';

class OutfitFeatureContainer extends StatelessWidget {
  final ThemeData theme;
  final int outfitCount;
  final VoidCallback onFilterButtonPressed;
  final VoidCallback onArrangeButtonPressed;
  final VoidCallback onCalendarButtonPressed;
  final VoidCallback onStylistButtonPressed;



  const OutfitFeatureContainer({
    super.key,
    required this.theme,
    required this.outfitCount,
    required this.onFilterButtonPressed,
    required this.onArrangeButtonPressed,
    required this.onCalendarButtonPressed,
    required this.onStylistButtonPressed,
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
                label: TypeDataList.filter(context).getName(context),
                selectedLabel: '',
                onPressed: onFilterButtonPressed,
                assetPath: TypeDataList.filter(context).assetPath,
                isFromMyCloset: false,
                buttonType: ButtonType.secondary,
                usePredefinedColor: false,
              ),
              NavigationTypeButton(
                label: TypeDataList.arrange(context).getName(context),
                selectedLabel: '',
                onPressed: onArrangeButtonPressed,
                assetPath: TypeDataList.arrange(context).assetPath,
                isFromMyCloset: false,
                buttonType: ButtonType.secondary,
                usePredefinedColor: false,
              ),
              NavigationTypeButton(
                label: TypeDataList.calendar(context).getName(context),
                selectedLabel: '',
                onPressed: onCalendarButtonPressed,
                assetPath: TypeDataList.calendar(context).assetPath,
                isFromMyCloset: false,
                buttonType: ButtonType.secondary,
                usePredefinedColor: false,
              ),
              NavigationTypeButton(
                label: TypeDataList.aistylist(context).getName(context),
                selectedLabel: '',
                onPressed: onStylistButtonPressed,
                assetPath: TypeDataList.aistylist(context).assetPath,
                isFromMyCloset: false,
                buttonType: ButtonType.secondary,
                usePredefinedColor: false,
              ),
            ],
          ),
          Tooltip(
            message: TypeDataList.outfitsUpload(context).getName(context),
            child: NumberTypeButton(
              count: outfitCount,
              assetPath: TypeDataList.outfitsUpload(context).assetPath,
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
