import 'package:flutter/material.dart';

import '../../../../../core/widgets/feedback/custom_tooltip.dart';
import '../../../../../core/widgets/button/number_type_button.dart';
import '../../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../generated/l10n.dart'; // for localized strings

class UploadIncompleteRow extends StatelessWidget {
  final ThemeData theme;
  final int apparelCount;
  final dynamic itemUploadData;
  final VoidCallback onUploadCompletedButtonPressed;

  const UploadIncompleteRow({
    super.key,
    required this.theme,
    required this.apparelCount,
    required this.itemUploadData,
    required this.onUploadCompletedButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Apparel count button with tooltip
        CustomTooltip(
          message: itemUploadData.getName(context),
          position: TooltipPosition.left,
          theme: theme,
          child: NumberTypeButton(
            count: apparelCount,
            assetPath: itemUploadData.assetPath ?? '',
            isFromMyCloset: true,
            isHorizontal: true,
            buttonType: ButtonType.secondary,
            usePredefinedColor: false,
          ),
        ),
        const SizedBox(width: 8.0),
        // Themed elevated button for upload completion
        ThemedElevatedButton(
          onPressed: onUploadCompletedButtonPressed,
          text: S.of(context).closetUploadComplete,
        ),
      ],
    );
  }
}
