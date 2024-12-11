import 'package:flutter/material.dart';
import '../../../../../core/widgets/container/base_container.dart';
import '../../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../core/data/type_data.dart';

class MultiClosetFeatureContainer extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onArchiveButtonPressed;

  const MultiClosetFeatureContainer({
    super.key,
    required this.theme,
    required this.onArchiveButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      theme: theme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              NavigationTypeButton(
                label: TypeDataList.archiveCloset(context).getName(context),
                selectedLabel: '',
                onPressed: onArchiveButtonPressed,
                assetPath: TypeDataList.archiveCloset(context).assetPath,
                isFromMyCloset: true,
                buttonType: ButtonType.secondary,
                usePredefinedColor: false,
              ),
            ], // Correctly closes the `children` list here
          ), // Correctly closes the `Row` widget here
        ],
      ),
    );
  }
}
