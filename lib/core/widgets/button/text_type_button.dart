import 'package:flutter/material.dart';
import 'base_button/type_button.dart';
import 'base_button/button_utility.dart';

class TextTypeButton extends TypeButton {
  final String dataKey;
  final String selectedKey;
  final String label;

  const TextTypeButton({
    super.key, // This is the widget key
    required this.dataKey, // This is your custom key for selection logic
    required this.selectedKey,
    required this.label,
    required super.assetPath,
    required super.onPressed,
    required super.isFromMyCloset,
    required super.buttonType,
    required super.usePredefinedColor,
    super.isSelected,
    super.isHorizontal,

  });


  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = ButtonUtils.getTextColor(theme, buttonType, isSelected);

    return Text(
      label[0].toUpperCase() + label.substring(1),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
      ),
    );
  }
}
