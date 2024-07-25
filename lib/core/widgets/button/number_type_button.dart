import 'package:flutter/material.dart';
import 'base_button/type_button.dart';
import 'base_button/button_utility.dart';

class NumberTypeButton extends TypeButton {
  final int count;

  const NumberTypeButton({
    super.key,
    required this.count,
    required super.imagePath,
    required super.isAsset,
    required super.isFromMyCloset,
    required super.buttonType,
    super.isSelected,
    super.isHorizontal,
  }) : super(
    onPressed: null,
  );

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = ButtonUtils.getTextColor(theme, buttonType, isSelected);

    return Text(
      '$count',
      style: theme.textTheme.labelSmall?.copyWith(
        color: textColor,
      ),
    );
  }
}
