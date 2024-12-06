import 'package:flutter/material.dart';
import '../../../../core/widgets/container/base_container.dart';
import '../../../../core/widgets/container/base_container_no_format.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/widgets/button/number_type_button.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/widgets/custom_tooltip.dart';


class MyClosetContainer extends StatelessWidget {
  final ThemeData theme;
  final dynamic uploadData;
  final dynamic filterData;
  final dynamic arrangeData;
  final dynamic addClosetData;
  final dynamic publicClosetData;
  final dynamic itemUploadData;
  final dynamic currentStreakData;
  final dynamic highestStreakData;
  final dynamic costOfNewItemsData;
  final dynamic numberOfNewItemsData;
  final int apparelCount;
  final int currentStreakCount;
  final int highestStreakCount;
  final int newItemsCost;
  final int newItemsCount;
  final bool isUploadCompleted;
  final VoidCallback onUploadButtonPressed;
  final VoidCallback onFilterButtonPressed;
  final VoidCallback onArrangeButtonPressed;
  final VoidCallback onMultiClosetButtonPressed;
  final VoidCallback onPublicClosetButtonPressed;

  const MyClosetContainer({
    super.key,
    required this.theme,
    required this.uploadData,
    required this.filterData,
    required this.arrangeData,
    required this.addClosetData,
    required this.publicClosetData,
    required this.itemUploadData,
    required this.currentStreakData,
    required this.highestStreakData,
    required this.costOfNewItemsData,
    required this.numberOfNewItemsData,
    required this.apparelCount,
    required this.currentStreakCount,
    required this.highestStreakCount,
    required this.newItemsCost,
    required this.newItemsCount,
    required this.isUploadCompleted,
    required this.onUploadButtonPressed,
    required this.onFilterButtonPressed,
    required this.onArrangeButtonPressed,
    required this.onMultiClosetButtonPressed,
    required this.onPublicClosetButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BaseContainer(
          theme: theme,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  NavigationTypeButton(
                    label: uploadData.getName(context),
                    selectedLabel: '',
                    onPressed: onUploadButtonPressed,
                    assetPath: uploadData.assetPath!,
                    isFromMyCloset: true,
                    buttonType: ButtonType.primary,
                    usePredefinedColor: false,
                  ),
                  NavigationTypeButton(
                    label: filterData.getName(context),
                    selectedLabel: '',
                    onPressed: onFilterButtonPressed,
                    assetPath: filterData.assetPath ?? '',
                    isFromMyCloset: true,
                    buttonType: ButtonType.secondary,
                    usePredefinedColor: false,
                  ),
                  NavigationTypeButton(
                    label: arrangeData.getName(context),
                    selectedLabel: '',
                    onPressed: onArrangeButtonPressed,
                    assetPath: arrangeData.assetPath ?? '',
                    isFromMyCloset: true,
                    buttonType: ButtonType.secondary,
                    usePredefinedColor: false,
                  ),
                  NavigationTypeButton(
                    label: addClosetData.getName(context),
                    selectedLabel: '',
                    onPressed: onMultiClosetButtonPressed,
                    assetPath: addClosetData.assetPath ?? '',
                    isFromMyCloset: true,
                    buttonType: ButtonType.secondary,
                    usePredefinedColor: false,
                  ),
                  NavigationTypeButton(
                    label: publicClosetData.getName(context),
                    selectedLabel: '',
                    onPressed: onPublicClosetButtonPressed,
                    assetPath: publicClosetData.assetPath ?? '',
                    isFromMyCloset: true,
                    buttonType: ButtonType.secondary,
                    usePredefinedColor: false,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),

        if (!isUploadCompleted)
          BaseContainerNoFormat(
            theme: theme,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTooltip(
                    message: itemUploadData.getName(context),
                    child: NumberTypeButton(
                      count: apparelCount,
                      assetPath: itemUploadData.assetPath ?? '',
                      isFromMyCloset: true,
                      isHorizontal: true,
                      buttonType: ButtonType.secondary,
                      usePredefinedColor: false,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Show streak data, new items cost, and new items count only when upload is completed
        if (isUploadCompleted)
          BaseContainerNoFormat(
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
          ),
      ],
    );
  }
}
