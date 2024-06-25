import 'package:flutter/material.dart';
import 'type_button.dart';

class TextTypeButton extends TypeButton {
  final String dataKey;
  final String selectedKey;
  final String label;

  const TextTypeButton({
    super.key, // This is the widget key
    required this.dataKey, // This is your custom key for selection logic
    required this.selectedKey,
    required this.label,
    required super.imageUrl,
    super.isSelected,
    super.onPressed,
  });


  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label[0].toUpperCase() + label.substring(1),
      style: TextStyle(
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.primary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
