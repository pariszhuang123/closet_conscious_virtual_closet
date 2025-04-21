import 'package:flutter/material.dart';

import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/data/type_data.dart';

class MyClosetNavigationRow extends StatelessWidget {
  final VoidCallback onUploadButtonPressed;
  final VoidCallback onFilterButtonPressed;
  final VoidCallback onArrangeButtonPressed;
  final VoidCallback onMultiClosetButtonPressed;
  final VoidCallback onPublicClosetButtonPressed;

  const MyClosetNavigationRow({
    super.key,
    required this.onUploadButtonPressed,
    required this.onFilterButtonPressed,
    required this.onArrangeButtonPressed,
    required this.onMultiClosetButtonPressed,
    required this.onPublicClosetButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          NavigationTypeButton(
            label: TypeDataList.bulkUpload(context).getName(context),
            selectedLabel: '',
            onPressed: onUploadButtonPressed,
            assetPath: TypeDataList
                .bulkUpload(context)
                .assetPath,
            isFromMyCloset: true,
            buttonType: ButtonType.primary,
            usePredefinedColor: false,
          ),
          NavigationTypeButton(
            label: TypeDataList.filter(context).getName(context),
            selectedLabel: '',
            onPressed: onFilterButtonPressed,
            assetPath: TypeDataList
                .filter(context)
                .assetPath,
            isFromMyCloset: true,
            buttonType: ButtonType.secondary,
            usePredefinedColor: false,
          ),
          NavigationTypeButton(
            label: TypeDataList.arrange(context).getName(context),
            selectedLabel: '',
            onPressed: onArrangeButtonPressed,
            assetPath: TypeDataList
                .arrange(context)
                .assetPath,
            isFromMyCloset: true,
            buttonType: ButtonType.secondary,
            usePredefinedColor: false,
          ),
          NavigationTypeButton(
            label: TypeDataList.addCloset(context).getName(context),
            selectedLabel: '',
            onPressed: onMultiClosetButtonPressed,
            assetPath: TypeDataList
                .addCloset(context)
                .assetPath,
            isFromMyCloset: true,
            buttonType: ButtonType.secondary,
            usePredefinedColor: false,
          ),
          NavigationTypeButton(
            label: TypeDataList.publicCloset(context).getName(context),
            selectedLabel: '',
            onPressed: onPublicClosetButtonPressed,
            assetPath: TypeDataList
                .publicCloset(context)
                .assetPath,
            isFromMyCloset: true,
            buttonType: ButtonType.secondary,
            usePredefinedColor: false,
          ),
        ],
      ),
    );
  }
}