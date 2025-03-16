import 'package:flutter/material.dart';
import '../../../../core/widgets/container/base_container_no_format.dart';
import '../../../../core/widgets/feedback/custom_tooltip.dart';
import '../../../../core/widgets/button/number_type_button.dart';
import '../../../../core/core_enums.dart';

class UploadCompletedContainer extends StatelessWidget {
  final ThemeData theme;
  final dynamic currentStreakData;
  final dynamic highestStreakData;
  final dynamic costOfNewItemsData;
  final dynamic numberOfNewItemsData;
  final int currentStreakCount;
  final int highestStreakCount;
  final int newItemsCost;
  final int newItemsCount;

  const UploadCompletedContainer({
    super.key,
    required this.theme,
    required this.currentStreakData,
    required this.highestStreakData,
    required this.costOfNewItemsData,
    required this.numberOfNewItemsData,
    required this.currentStreakCount,
    required this.highestStreakCount,
    required this.newItemsCost,
    required this.newItemsCount,
  });

  @override
  Widget build(BuildContext context) {
    return BaseContainerNoFormat(
      theme: theme,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (currentStreakData != null)
              CustomTooltip(
                message: currentStreakData.getName(context),
                child: NumberTypeButton(
                  count: currentStreakCount,
                  assetPath: currentStreakData.assetPath ?? '',
                  isFromMyCloset: true,
                  isHorizontal: true,
                  buttonType: ButtonType.secondary,
                  usePredefinedColor: false,
                ),
              ),
            if (highestStreakData != null)
              CustomTooltip(
                message: highestStreakData.getName(context),
                child: NumberTypeButton(
                  count: highestStreakCount,
                  assetPath: highestStreakData.assetPath ?? '',
                  isFromMyCloset: true,
                  isHorizontal: true,
                  buttonType: ButtonType.secondary,
                  usePredefinedColor: false,
                ),
              ),
            if (costOfNewItemsData != null)
              CustomTooltip(
                message: costOfNewItemsData.getName(context),
                child: NumberTypeButton(
                  count: newItemsCost,
                  assetPath: costOfNewItemsData.assetPath ?? '',
                  isFromMyCloset: true,
                  isHorizontal: true,
                  buttonType: ButtonType.secondary,
                  usePredefinedColor: false,
                ),
              ),
            if (numberOfNewItemsData != null)
              CustomTooltip(
                message: numberOfNewItemsData.getName(context),
                child: NumberTypeButton(
                  count: newItemsCount,
                  assetPath: numberOfNewItemsData.assetPath ?? '',
                  isFromMyCloset: true,
                  isHorizontal: true,
                  buttonType: ButtonType.secondary,
                  usePredefinedColor: false,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
