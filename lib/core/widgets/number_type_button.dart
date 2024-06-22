import 'package:flutter/material.dart';
import 'type_button.dart';

class NumberTypeButton extends TypeButton {
  final int count;

  const NumberTypeButton({
    super.key,
    required this.count,
    super.imageUrl,
    super.isSelected,
  }) : super(
    onPressed: null,
  );
  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      '$count',
      style: TextStyle(
        color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color,
        fontSize: 24, // Increase the font size for visibility
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
