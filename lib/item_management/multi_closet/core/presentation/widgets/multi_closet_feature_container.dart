import 'package:flutter/material.dart';
import '../../../../../core/widgets/container/base_container.dart';
import '../../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../core/data/type_data.dart';

class MultiClosetFeatureContainer extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onFilterButtonPressed;
  final VoidCallback onArrangeButtonPressed;
  final VoidCallback onResetButtonPressed;
  final VoidCallback onSelectAllButtonPressed;

  const MultiClosetFeatureContainer({
    super.key,
    required this.theme,
    required this.onFilterButtonPressed,
    required this.onArrangeButtonPressed,
    required this.onResetButtonPressed,
    required this.onSelectAllButtonPressed,
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
                label: TypeDataList.filter(context).getName(context),
                selectedLabel: '',
                onPressed: onFilterButtonPressed,
                assetPath: TypeDataList.filter(context).assetPath,
                isFromMyCloset: true,
                buttonType: ButtonType.secondary,
                usePredefinedColor: false,
              ),
              NavigationTypeButton(
                label: TypeDataList.arrange(context).getName(context),
                selectedLabel: '',
                onPressed: onArrangeButtonPressed,
                assetPath: TypeDataList.arrange(context).assetPath,
                isFromMyCloset: true,
                buttonType: ButtonType.secondary,
                usePredefinedColor: false,
              ),
              NavigationTypeButton(
                label: TypeDataList.reset(context).getName(context),
                selectedLabel: '',
                onPressed: onResetButtonPressed,
                assetPath: TypeDataList.reset(context).assetPath,
                isFromMyCloset: true,
                buttonType: ButtonType.secondary,
                usePredefinedColor: false,
              ),
              NavigationTypeButton(
                label: TypeDataList.selectAll(context).getName(context), // Label for the "Select All" button
                selectedLabel: '',
                onPressed: onSelectAllButtonPressed, // Use the new callback here
                assetPath: TypeDataList.selectAll(context).assetPath,
                isFromMyCloset: true,
                buttonType: ButtonType.secondary,
                usePredefinedColor: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
