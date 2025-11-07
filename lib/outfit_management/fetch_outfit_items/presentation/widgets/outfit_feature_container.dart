import 'package:flutter/material.dart';
import '../../../../core/widgets/container/base_container.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/widgets/button/number_type_button.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/data/type_data.dart';
import '../../../../core/widgets/feedback/custom_tooltip.dart';

class OutfitFeatureContainer extends StatelessWidget {
  final ThemeData theme;
  final int outfitCount;
  final VoidCallback onFilterButtonPressed;
  final VoidCallback onArrangeButtonPressed;
  final VoidCallback onCalendarButtonPressed;
  final VoidCallback onOutfitLotteryButtonPressed;
  final VoidCallback onStylistButtonPressed;
  final bool showOutfitLotteryButton;
  final bool showAiStylistButton;

  const OutfitFeatureContainer({
    super.key,
    required this.theme,
    required this.outfitCount,
    required this.onFilterButtonPressed,
    required this.onArrangeButtonPressed,
    required this.onCalendarButtonPressed,
    required this.onOutfitLotteryButtonPressed,
    required this.onStylistButtonPressed,
    required this.showOutfitLotteryButton,
    required this.showAiStylistButton
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
              if (showAiStylistButton)
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
          CustomTooltip(
            message: TypeDataList.outfitsUpload(context).getName(context),
            position: TooltipPosition.right,
            theme: theme,
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
