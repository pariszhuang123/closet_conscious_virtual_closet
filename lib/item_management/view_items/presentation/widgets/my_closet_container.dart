import 'package:flutter/material.dart';
import '../../../../core/widgets/container/base_container.dart';
import '../../../../core/widgets/container/base_container_no_format.dart';
import 'upload_incomplete_row.dart';
import 'navigation_button_row.dart';
import 'upload_completed_container.dart';

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
  final VoidCallback onUploadCompletedButtonPressed;

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
    required this.onUploadCompletedButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BaseContainer(
          theme: theme,
          child: MyClosetNavigationRow(
            onUploadButtonPressed: onUploadButtonPressed,
            onFilterButtonPressed: onFilterButtonPressed,
            onArrangeButtonPressed: onArrangeButtonPressed,
            onMultiClosetButtonPressed: onMultiClosetButtonPressed,
            onPublicClosetButtonPressed: onPublicClosetButtonPressed,
          ),
        ),
        const SizedBox(height: 10.0),

        if (!isUploadCompleted)
          BaseContainerNoFormat(
            theme: theme,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: UploadIncompleteRow(
                theme: theme,
                apparelCount: apparelCount,
                itemUploadData: itemUploadData,
                onUploadCompletedButtonPressed: onUploadCompletedButtonPressed,
              ),
            ),
          ),

        if (isUploadCompleted)
          UploadCompletedContainer(
            theme: theme,
            currentStreakData: currentStreakData,
            highestStreakData: highestStreakData,
            costOfNewItemsData: costOfNewItemsData,
            numberOfNewItemsData: numberOfNewItemsData,
            currentStreakCount: currentStreakCount,
            highestStreakCount: highestStreakCount,
            newItemsCost: newItemsCost,
            newItemsCount: newItemsCount,
          ),
      ],
    );
  }
}
