import 'package:flutter/material.dart';
import 'base_button/type_button.dart';
import 'base_button/button_utility.dart';

class TextTypeButton extends TypeButton {
  final String dataKey;
  final List<String> selectedKeys;
  final String label;

  TextTypeButton({
    super.key,
    required this.dataKey,
    required this.selectedKeys,
    required this.label,
    required super.assetPath,
    required super.onPressed,
    required super.isFromMyCloset,
    required super.buttonType,
    required super.usePredefinedColor,
    super.isHorizontal,
  }) : super(isSelected: selectedKeys.contains(dataKey));  // Pass `isSelected` here

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    // Determine if this button is selected based on whether dataKey is in selectedKeys
    final isSelected = selectedKeys.contains(dataKey);
    final textColor = ButtonUtils.getTextColor(theme, buttonType, isSelected);

    return Text(
      label[0].toUpperCase() + label.substring(1),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
      ),
    );
  }
}
