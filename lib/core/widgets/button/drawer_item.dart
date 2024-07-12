import 'package:flutter/material.dart';

import 'type_button.dart';

class DrawerItem extends TypeButton {
  final String text;

  const DrawerItem({
    super.key,
    required super.imagePath,
    required this.text,
    bool isSelected = false,
    VoidCallback? onPressed,
  }) : super(
    isHorizontal: true, // Drawer items are horizontal
  );

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
      ),
    );
  }
}
