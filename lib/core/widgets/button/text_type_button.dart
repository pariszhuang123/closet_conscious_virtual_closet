import 'package:flutter/material.dart';
import 'type_button.dart';

class TextTypeButton extends TypeButton {
  final String label;
  final String selectedLabel;

  const TextTypeButton({
    super.key,
    required super.onPressed,
    required super.imageUrl,
    super.isSelected,
    required this.label,
    required this.selectedLabel, // Add this line
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
