import 'package:flutter/material.dart';
import 'type_button.dart';

class NumberTypeButton extends TypeButton {
  final int count;

  const NumberTypeButton({
    super.key,
    required this.count,
    required super.imagePath,
    required super.isAsset,
    required super.isCloset,
    super.isSelected,
    super.isHorizontal,
  }) : super(
    onPressed: null,
  );

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min, // Ensure the row wraps its content
      children: [
        Text(
          '$count',
          style: theme.textTheme.labelSmall?.copyWith(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}