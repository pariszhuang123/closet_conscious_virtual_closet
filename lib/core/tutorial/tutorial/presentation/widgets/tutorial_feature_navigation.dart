import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../generated/l10n.dart';
import '../../../../widgets/button/navigation_type_button.dart';
import '../../../../core_enums.dart';
import '../../../../utilities/app_router.dart';
import '../../../../data/type_data.dart';


class TutorialFeatureNavigation extends StatelessWidget {
  const TutorialFeatureNavigation({super.key});

  void _navigateToTutorial(
      BuildContext context, {
        required TutorialType tutorialType,
        required String nextRoute,
        required bool isFromMyCloset,
      }) {
    context.pushNamed(
      AppRoutesName.tutorialVideoPopUp,
      extra: {
        'tutorialInputKey': tutorialType, // using the extension
        'nextRoute': nextRoute,
        'isFromMyCloset': isFromMyCloset,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const isFromMyCloset = true; // Set false if this widget is used from other screens

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          NavigationTypeButton(
            label: S.of(context).bulkUpload,
            selectedLabel: '',
            onPressed: () => _navigateToTutorial(
              context,
              tutorialType: TutorialType.freeUploadPhotoLibrary,
              nextRoute: AppRoutesName.pendingPhotoLibrary,
              isFromMyCloset: isFromMyCloset,
            ),
            assetPath: TypeDataList.bulkUpload(context).assetPath,
            isFromMyCloset: isFromMyCloset,
            buttonType: ButtonType.primary,
            usePredefinedColor: false,
          ),
          NavigationTypeButton(
            label: S.of(context).upload,
            selectedLabel: '',
            onPressed: () => _navigateToTutorial(
              context,
              tutorialType: TutorialType.freeUploadCamera,
              nextRoute: AppRoutesName.uploadItemPhoto,
              isFromMyCloset: isFromMyCloset,
            ),
            assetPath: TypeDataList.upload(context).assetPath,
            isFromMyCloset: isFromMyCloset,
            buttonType: ButtonType.primary,
            usePredefinedColor: false,
          ),
          NavigationTypeButton(
            label: S.of(context).editItem,
            selectedLabel: '',
            onPressed: () => _navigateToTutorial(
              context,
              tutorialType: TutorialType.freeEditCamera,
              nextRoute: AppRoutesName.editItem,
              isFromMyCloset: isFromMyCloset,
            ),
            assetPath: TypeDataList.editItem(context).assetPath,
            isFromMyCloset: isFromMyCloset,
            buttonType: ButtonType.primary,
            usePredefinedColor: false,
          ),
          NavigationTypeButton(
            label: S.of(context).filter_filter,
            selectedLabel: '',
            onPressed: () => _navigateToTutorial(
              context,
              tutorialType: TutorialType.paidFilter,
              nextRoute: AppRoutesName.filter,
              isFromMyCloset: isFromMyCloset,
            ),
            assetPath: TypeDataList.filter(context).assetPath,
            isFromMyCloset: isFromMyCloset,
            buttonType: ButtonType.secondary,
            usePredefinedColor: false,
          ),
          NavigationTypeButton(
            label: S.of(context).arrange,
            selectedLabel: '',
            onPressed: () => _navigateToTutorial(
              context,
              tutorialType: TutorialType.paidCustomize,
              nextRoute: AppRoutesName.customize,
              isFromMyCloset: isFromMyCloset,
            ),
            assetPath: TypeDataList.arrange(context).assetPath,
            isFromMyCloset: isFromMyCloset,
            buttonType: ButtonType.secondary,
            usePredefinedColor: false,
          ),
          NavigationTypeButton(
            label: S.of(context).addCloset_addCloset,
            selectedLabel: '',
            onPressed: () => _navigateToTutorial(
              context,
              tutorialType: TutorialType.paidMultiCloset,
              nextRoute: AppRoutesName.viewMultiCloset,
              isFromMyCloset: isFromMyCloset,
            ),
            assetPath: TypeDataList.addCloset(context).assetPath,
            isFromMyCloset: isFromMyCloset,
            buttonType: ButtonType.secondary,
            usePredefinedColor: false,
          ),
          NavigationTypeButton(
            label: S.of(context).createOutfit,
            selectedLabel: '',
            onPressed: () => _navigateToTutorial(
              context,
              tutorialType: TutorialType.freeCreateOutfit,
              nextRoute: AppRoutesName.createOutfit,
              isFromMyCloset: false,
            ),
            assetPath: TypeDataList.createOutfit(context).assetPath,
            isFromMyCloset: false,
            buttonType: ButtonType.primary,
            usePredefinedColor: false,
          ),
          NavigationTypeButton(
            label: S.of(context).calendar,
            selectedLabel: '',
            onPressed: () => _navigateToTutorial(
              context,
              tutorialType: TutorialType.paidCalendar,
              nextRoute: AppRoutesName.monthlyCalendar,
              isFromMyCloset: false,
            ),
            assetPath: TypeDataList.calendar(context).assetPath,
            isFromMyCloset: false,
            buttonType: ButtonType.secondary,
            usePredefinedColor: false,
          ),
        ],
      ),
    );
  }
}
