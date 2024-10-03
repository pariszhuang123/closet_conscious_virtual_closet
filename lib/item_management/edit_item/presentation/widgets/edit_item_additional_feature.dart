import 'package:flutter/material.dart';

import '../../../../core/data/type_data.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';

class EditItemAdditionalFeature extends StatelessWidget {
  final VoidCallback openMetadataSheet;
  final VoidCallback openSwapSheet;

  const EditItemAdditionalFeature({
    super.key,
    required this.openMetadataSheet,
    required this.openSwapSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NavigationTypeButton(
          label: TypeDataList.metadata(context).getName(context),
          selectedLabel: '',
          onPressed: openMetadataSheet,
          assetPath: TypeDataList.metadata(context).assetPath,
          isFromMyCloset: true,
          buttonType: ButtonType.secondary,
          usePredefinedColor: false,
        ),
        NavigationTypeButton(
          label: TypeDataList.swapItem(context).getName(context),
          selectedLabel: '',
          onPressed: openSwapSheet,
          assetPath: TypeDataList.swapItem(context).assetPath,
          isFromMyCloset: true,
          buttonType: ButtonType.secondary,
          usePredefinedColor: false,
        ),
      ],
    );
  }
}
