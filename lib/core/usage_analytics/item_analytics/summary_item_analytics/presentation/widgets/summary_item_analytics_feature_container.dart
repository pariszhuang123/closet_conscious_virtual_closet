import 'package:flutter/material.dart';

import '../../../../../widgets/container/base_container.dart';
import '../../../../../widgets/button/navigation_type_button.dart';
import '../../../../../core_enums.dart';
import '../../../../../data/type_data.dart';

class SummaryItemAnalyticsFeatureContainer extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onFilterButtonPressed;
  final VoidCallback onArrangeButtonPressed;
  final VoidCallback onResetButtonPressed;
  final VoidCallback onSelectAllButtonPressed;

  const SummaryItemAnalyticsFeatureContainer({
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
                label: TypeDataList.selectAll(context).getName(context),
                selectedLabel: '',
                onPressed: onSelectAllButtonPressed,
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
