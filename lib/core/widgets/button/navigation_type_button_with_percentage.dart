import 'package:flutter/material.dart';
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
    Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Display only the icon and avoid duplicating the label (handled in superclass)
        buildImage(),

        // Spacer for correct alignment
        const SizedBox(width: 8),

        // Display the percentage overlay
        PercentageOverlay(percentageType: percentageType),
      ],
    );
  }
}
