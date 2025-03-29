import 'package:flutter/material.dart';

import '../../../../../core/widgets/container/base_container.dart';
import '../../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../core/data/type_data.dart';

class PhotoLibraryContainer extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onViewPendingUploadButtonPressed;

  const PhotoLibraryContainer({
    super.key,
    required this.theme,
    required this.onViewPendingUploadButtonPressed,
  });

  @override
  Widget build(BuildContext context) {

    return BaseContainer(
      theme: theme,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Enables horizontal scrolling
        child: Row(
          children: [
            NavigationTypeButton(
              label: TypeDataList.viewPendingUpload(context).getName(context),
              selectedLabel: '',
              onPressed: onViewPendingUploadButtonPressed,
              assetPath: TypeDataList.viewPendingUpload(context).assetPath,
              isFromMyCloset: true,
              buttonType: ButtonType.secondary,
              usePredefinedColor: false,
            ),
          ],
        ),
      ),
    );
  }
}
