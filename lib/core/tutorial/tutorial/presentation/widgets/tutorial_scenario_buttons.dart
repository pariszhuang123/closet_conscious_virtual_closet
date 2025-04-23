import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../widgets/button/navigation_type_button.dart';
import '../../../../core_enums.dart';
import '../../../../utilities/app_router.dart';
import '../../../../data/type_data.dart';

class TutorialScenarioButtons extends StatelessWidget {
  final bool isFromMyCloset;
  final void Function({
  required BuildContext context,
  required TutorialType tutorialType,
  required String nextRoute,
  required bool isFromMyCloset,
  }) navigateToTutorial;

  const TutorialScenarioButtons({
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
          S.of(context).scenarioTutorials,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: NavigationTypeButton(
                label: S.of(context).personalStyle,
                selectedLabel: '',
                onPressed: () => navigateToTutorial(
                  context: context,
                  tutorialType: TutorialType.flowIntroPersonalStyle,
                  nextRoute: AppRoutesName.pendingPhotoLibrary,
                  isFromMyCloset: isFromMyCloset,
                ),
                assetPath: TypeDataList.personalStyle(context).assetPath,
                isFromMyCloset: isFromMyCloset,
                buttonType: ButtonType.primary,
                usePredefinedColor: false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: NavigationTypeButton(
                label: S.of(context).lifeChange,
                selectedLabel: '',
                onPressed: () => navigateToTutorial(
                  context: context,
                  tutorialType: TutorialType.flowIntroLifeChange,
                  nextRoute: AppRoutesName.pendingPhotoLibrary,
                  isFromMyCloset: isFromMyCloset,
                ),
                assetPath: TypeDataList.lifeChange(context).assetPath,
                isFromMyCloset: isFromMyCloset,
                buttonType: ButtonType.primary,
                usePredefinedColor: false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: NavigationTypeButton(
                label: S.of(context).parentMemories,
                selectedLabel: '',
                onPressed: () => navigateToTutorial(
                  context: context,
                  tutorialType: TutorialType.flowIntroMemory,
                  nextRoute: AppRoutesName.pendingPhotoLibrary,
                  isFromMyCloset: isFromMyCloset,
                ),
                assetPath: TypeDataList.parentMemories(context).assetPath,
                isFromMyCloset: isFromMyCloset,
                buttonType: ButtonType.primary,
                usePredefinedColor: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

          ],
        );
  }
}
