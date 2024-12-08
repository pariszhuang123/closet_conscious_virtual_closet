import 'package:flutter/material.dart';
import '../../../../../core/widgets/container/base_container.dart';
import '../../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../core/data/type_data.dart';

class OutfitFeatureContainer extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onFilterButtonPressed;
  final VoidCallback onArrangeButtonPressed;

  const OutfitFeatureContainer({
    super.key,
    required this.theme,
    required this.onFilterButtonPressed,
    required this.onArrangeButtonPressed,
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
            ],
          ),
        ],
      ),
    );
  }
}
