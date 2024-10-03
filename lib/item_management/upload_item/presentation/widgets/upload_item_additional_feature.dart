import 'package:flutter/material.dart';

import '../../../../core/data/type_data.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';

class UploadItemAdditionalFeature extends StatelessWidget {
  final VoidCallback openAiUploadSheet;

  const UploadItemAdditionalFeature({
    super.key,
    required this.openAiUploadSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NavigationTypeButton(
          label: TypeDataList.aiupload(context).getName(context),
          selectedLabel: '',
          onPressed: openAiUploadSheet,
          assetPath: TypeDataList.aiupload(context).assetPath,
          isFromMyCloset: true,
          buttonType: ButtonType.secondary,
          usePredefinedColor: false,
        ),
      ],
    );
  }
}
