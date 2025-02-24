import 'package:flutter/material.dart';

import 'base_button/button_utility.dart';
import 'navigation_type_button.dart';
import 'base_button/percentage_overlay.dart';

class NavigationTypeButtonWithPercentage extends NavigationTypeButton {
  final String percentageType;

  const NavigationTypeButtonWithPercentage({
    super.key,
    required super.label,
    required super.selectedLabel,
    required this.percentageType,
    required super.onPressed,
    required super.assetPath,
    required super.isFromMyCloset,
    required super.usePredefinedColor,
    super.isSelected,
    super.isHorizontal,
    required super.buttonType,
  });

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = ButtonUtils.getTextColor(theme, buttonType, isSelected);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure spacing between text/icon and percentage
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildImage(), // ThemedSVG Icon
            const SizedBox(width: 4),
            Text(
              isSelected ? selectedLabel : label,
              style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(width: 8), // Space before extra widget
        PercentageOverlay(percentageType: percentageType), // Extra Widget
      ],
    );
  }
}
