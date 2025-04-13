import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../widgets/button/navigation_type_button.dart';
import '../../../../core_enums.dart';
import '../../../../utilities/app_router.dart';
import '../../../../data/type_data.dart';

class TutorialPremiumFeatureButtons extends StatelessWidget {
  final bool isFromMyCloset;
  final void Function({
  required BuildContext context,
  required TutorialType tutorialType,
  required String nextRoute,
  required bool isFromMyCloset,
  }) navigateToTutorial;

  const TutorialPremiumFeatureButtons({
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
          S.of(context).premiumFeatureTutorials,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: NavigationTypeButton(
                label: S.of(context).filter_filter,
                selectedLabel: '',
                onPressed: () => navigateToTutorial(
                  context: context,
                  tutorialType: TutorialType.paidFilter,
                  nextRoute: AppRoutesName.filter,
                  isFromMyCloset: isFromMyCloset,
                ),
                assetPath: TypeDataList.filter(context).assetPath,
                isFromMyCloset: isFromMyCloset,
                buttonType: ButtonType.secondary,
                usePredefinedColor: false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: NavigationTypeButton(
                label: S.of(context).arrange,
                selectedLabel: '',
                onPressed: () => navigateToTutorial(
                  context: context,
                  tutorialType: TutorialType.paidCustomize,
                  nextRoute: AppRoutesName.customize,
                  isFromMyCloset: isFromMyCloset,
                ),
                assetPath: TypeDataList.arrange(context).assetPath,
                isFromMyCloset: isFromMyCloset,
                buttonType: ButtonType.secondary,
                usePredefinedColor: false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: NavigationTypeButton(
                label: S.of(context).addCloset_addCloset,
                selectedLabel: '',
                onPressed: () => navigateToTutorial(
                  context: context,
                  tutorialType: TutorialType.paidMultiCloset,
                  nextRoute: AppRoutesName.viewMultiCloset,
                  isFromMyCloset: isFromMyCloset,
                ),
                assetPath: TypeDataList.addCloset(context).assetPath,
                isFromMyCloset: isFromMyCloset,
                buttonType: ButtonType.secondary,
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
              child: NavigationTypeButton(
                label: S.of(context).calendar,
                selectedLabel: '',
                onPressed: () => navigateToTutorial(
                  context: context,
                  tutorialType: TutorialType.paidCalendar,
                  nextRoute: AppRoutesName.monthlyCalendar,
                  isFromMyCloset: false,
                ),
                assetPath: TypeDataList.calendar(context).assetPath,
                isFromMyCloset: false,
                buttonType: ButtonType.secondary,
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
