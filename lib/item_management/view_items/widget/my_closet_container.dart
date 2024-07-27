import 'package:flutter/material.dart';
import '../../../core/widgets/base_container.dart';
import '../../../core/widgets/button/navigation_type_button.dart';
import '../../../core/widgets/button/number_type_button.dart';
import '../../../core/theme/themed_svg.dart';

class MyClosetContainer extends StatelessWidget {
  final ThemeData theme;
  final dynamic uploadData;
  final dynamic filterData;
  final dynamic addClosetData;
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
  final VoidCallback onMultiClosetButtonPressed;

  const MyClosetContainer({
    super.key,
    required this.theme,
    required this.uploadData,
    required this.filterData,
    required this.addClosetData,
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
    required this.onMultiClosetButtonPressed,
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
                    imagePath: uploadData.imagePath!,
                    isAsset: true,
                    isFromMyCloset: true,
                    buttonType: ButtonType.primary,
                  ),
                  NavigationTypeButton(
                    label: filterData.getName(context),
                    selectedLabel: '',
                    onPressed: onFilterButtonPressed,
                    imagePath: filterData.imagePath ?? '',
                    isAsset: true,
                    isFromMyCloset: true,
                    buttonType: ButtonType.secondary,
                  ),
                  NavigationTypeButton(
                    label: addClosetData.getName(context),
                    selectedLabel: '',
                    onPressed: onMultiClosetButtonPressed,
                    imagePath: addClosetData.imagePath ?? '',
                    isAsset: true,
                    isFromMyCloset: true,
                    buttonType: ButtonType.secondary,
                  ),
                ],
              ),
              if (!isUploadCompleted)
                Tooltip(
                  message: itemUploadData.getName(context),
                  child: NumberTypeButton(
                    count: apparelCount,
                    imagePath: itemUploadData.imagePath ?? '',
                    isAsset: itemUploadData.isAsset,
                    isFromMyCloset: true,
                    isHorizontal: false,
                    buttonType: ButtonType.secondary,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Visibility(
          visible: isUploadCompleted,
          child: BaseContainer(
            theme: theme,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Tooltip(
                    message: currentStreakData.getName(context),
                    child: NumberTypeButton(
                      count: currentStreakCount,
                      imagePath: currentStreakData.imagePath ?? '',
                      isAsset: currentStreakData.isAsset,
                      isFromMyCloset: true,
                      isHorizontal: true,
                      buttonType: ButtonType.secondary,
                    ),
                  ),
                  Tooltip(
                    message: highestStreakData.getName(context),
                    child: NumberTypeButton(
                      count: highestStreakCount,
                      imagePath: highestStreakData.imagePath ?? '',
                      isAsset: highestStreakData.isAsset,
                      isFromMyCloset: true,
                      isHorizontal: true,
                      buttonType: ButtonType.secondary,
                    ),
                  ),
                  Tooltip(
                    message: costOfNewItemsData.getName(context),
                    child: NumberTypeButton(
                      count: newItemsCost,
                      imagePath: costOfNewItemsData.imagePath ?? '',
                      isAsset: costOfNewItemsData.isAsset,
                      isFromMyCloset: true,
                      isHorizontal: true,
                      buttonType: ButtonType.secondary,
                    ),
                  ),
                  Tooltip(
                    message: numberOfNewItemsData.getName(context),
                    child: NumberTypeButton(
                      count: newItemsCount,
                      imagePath: numberOfNewItemsData.imagePath ?? '',
                      isAsset: numberOfNewItemsData.isAsset,
                      isFromMyCloset: true,
                      isHorizontal: true,
                      buttonType: ButtonType.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
