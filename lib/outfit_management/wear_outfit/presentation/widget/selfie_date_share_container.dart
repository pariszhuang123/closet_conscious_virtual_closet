import 'package:closet_conscious/core/data/type_data.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/container/base_container_no_format.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/theme/themed_svg.dart';
import '../../../../generated/l10n.dart';

class SelfieDateShareContainer extends StatelessWidget {
  final String formattedDate;
  final VoidCallback onSelfieButtonPressed;
  final VoidCallback onShareButtonPressed;
  final ThemeData theme;
  final bool isSelfieTaken;

  const SelfieDateShareContainer({
    super.key,
    required this.formattedDate,
    required this.onSelfieButtonPressed,
    required this.onShareButtonPressed,
    required this.theme,
    required this.isSelfieTaken,
  });

  @override
  Widget build(BuildContext context) {
    final selfieData = TypeDataList.selfie(context);
    final shareData = TypeDataList.share(context);

    return BaseContainerNoFormat(
      theme: theme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // Center the buttons and text
        children: [
          if (!isSelfieTaken) // Conditionally render the selfie button
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: NavigationTypeButton(
                label: selfieData.getName(context),
                selectedLabel: '',
                onPressed: onSelfieButtonPressed,
                assetPath: selfieData.assetPath,
                isFromMyCloset: false,
                buttonType: ButtonType.primary,
                usePredefinedColor: false,
              ),
            ),
          Text(
            '${S
                .of(context)
                .date}: $formattedDate',
            style: theme.textTheme.bodyMedium,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            // Add some gap on the left
            child: NavigationTypeButton(
              label: shareData.getName(context),
              selectedLabel: '',
              onPressed: onShareButtonPressed,
              assetPath: shareData.assetPath,
              isFromMyCloset: false,
              buttonType: ButtonType.primary,
              usePredefinedColor: false,
            ),
          ),
        ],
      ),
    );
  }
}
