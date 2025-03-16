import 'package:flutter/material.dart';

import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/core_enums.dart';

class MyClosetNavigationRow extends StatelessWidget {
  final dynamic uploadData;
  final dynamic filterData;
  final dynamic arrangeData;
  final dynamic addClosetData;
  final dynamic publicClosetData;
  final VoidCallback onUploadButtonPressed;
  final VoidCallback onFilterButtonPressed;
  final VoidCallback onArrangeButtonPressed;
  final VoidCallback onMultiClosetButtonPressed;
  final VoidCallback onPublicClosetButtonPressed;

  const MyClosetNavigationRow({
    super.key,
    required this.uploadData,
    required this.filterData,
    required this.arrangeData,
    required this.addClosetData,
    required this.publicClosetData,
    required this.onUploadButtonPressed,
    required this.onFilterButtonPressed,
    required this.onArrangeButtonPressed,
    required this.onMultiClosetButtonPressed,
    required this.onPublicClosetButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
