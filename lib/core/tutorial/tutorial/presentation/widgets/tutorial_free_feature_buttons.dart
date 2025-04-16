import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../widgets/button/navigation_type_button.dart';
import '../../../../core_enums.dart';
import '../../../../utilities/app_router.dart';
import '../../../../data/type_data.dart';

class TutorialFreeFeatureButtons extends StatelessWidget {
  final bool isFromMyCloset;
  final void Function({
  required BuildContext context,
  required TutorialType tutorialType,
  required String nextRoute,
  required bool isFromMyCloset,
  }) navigateToTutorial;

  const TutorialFreeFeatureButtons({
    super.key,
    required this.isFromMyCloset,
    required this.navigateToTutorial,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).alwaysAvailableFeatures,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: NavigationTypeButton(
                label: S.of(context).bulkUpload,
                selectedLabel: '',
                onPressed: () =>
                    navigateToTutorial(
                      context: context,
                      tutorialType: TutorialType.freeUploadPhotoLibrary,
                      nextRoute: AppRoutesName.pendingPhotoLibrary,
                      isFromMyCloset: isFromMyCloset,
                    ),
                assetPath: TypeDataList.bulkUpload(context).assetPath,
                isFromMyCloset: isFromMyCloset,
                buttonType: ButtonType.primary,
                usePredefinedColor: false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: NavigationTypeButton(
                label: S
                    .of(context)
                    .cameraUpload,
                selectedLabel: '',
                onPressed: () =>
                    navigateToTutorial(
                      context: context,
                      tutorialType: TutorialType.freeUploadCamera,
                      nextRoute: AppRoutesName.uploadItemPhoto,
                      isFromMyCloset: isFromMyCloset,
                    ),
                assetPath: TypeDataList
                    .cameraUpload(context)
                    .assetPath,
                isFromMyCloset: isFromMyCloset,
                buttonType: ButtonType.primary,
                usePredefinedColor: false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: NavigationTypeButton(
                label: S
                    .of(context)
                    .editItem,
                selectedLabel: '',
                onPressed: () =>
                    navigateToTutorial(
                      context: context,
                      tutorialType: TutorialType.freeEditCamera,
                      nextRoute: AppRoutesName.myCloset,
                      isFromMyCloset: isFromMyCloset,
                    ),
                assetPath: TypeDataList
                    .editItem(context)
                    .assetPath,
                isFromMyCloset: isFromMyCloset,
                buttonType: ButtonType.primary,
                usePredefinedColor: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Second Row
        Row(
          children: [
            Expanded(
              child:           NavigationTypeButton(
                label: S.of(context).createOutfit,
                selectedLabel: '',
                onPressed: () => navigateToTutorial(
                  context: context,
                  tutorialType: TutorialType.freeCreateOutfit,
                  nextRoute: AppRoutesName.createOutfit,
                  isFromMyCloset: false,
                ),
                assetPath: TypeDataList.createOutfit(context).assetPath,
                isFromMyCloset: false,
                buttonType: ButtonType.primary,
                usePredefinedColor: false,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(child: SizedBox.shrink()), // Empty
            const SizedBox(width: 8),
            const Expanded(child: SizedBox.shrink()), // Empty
          ],
        ),
      ],
    );
  }
}
