import 'package:flutter/material.dart';
import 'base_button/type_button.dart';
import 'base_button/button_utility.dart';

class NavigationTypeButton extends TypeButton {
  final String label;
  final String selectedLabel;

  const NavigationTypeButton({
    required this.label,
    required this.selectedLabel,
    required super.onPressed,
    required super.assetPath,
    required super.isFromMyCloset,
    required super.usePredefinedColor,
    super.isSelected,
    super.isHorizontal,
    required super.buttonType,
    super.key,
   });

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = ButtonUtils.getTextColor(theme, buttonType, isSelected);

    return Text(
      isSelected ? selectedLabel : label,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
      ),
      textAlign: TextAlign.center,
    );
  }
}