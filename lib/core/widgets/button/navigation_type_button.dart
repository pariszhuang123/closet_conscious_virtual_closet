import 'package:flutter/material.dart';
import 'type_button.dart';

class NavigationTypeButton extends TypeButton {
  final String label;
  final String selectedLabel;

  const NavigationTypeButton({
    required this.label,
    required this.selectedLabel,
    required super.onPressed,
    required super.imageUrl,
    super.isSelected,
    super.key,
  });

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      isSelected ? selectedLabel : label,
      style: theme.textTheme.labelSmall?.copyWith(
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }
}
