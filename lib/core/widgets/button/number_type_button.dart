import 'package:flutter/material.dart';
import 'base_button/type_button.dart';
import 'base_button/button_utility.dart';
import '../../utilities/number_formatter.dart';

class NumberTypeButton extends TypeButton {
  final int count;

  const NumberTypeButton({
    super.key,
    required this.count,
    required super.assetPath,
    required super.isFromMyCloset,
    required super.buttonType,
    required super.usePredefinedColor,
    super.isSelected,
    super.isHorizontal,
  }) : super(
    onPressed: null,
  );

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = ButtonUtils.getTextColor(theme, buttonType, isSelected);
    final formattedCount = formatNumber(count);

    return Text(
      '${formattedCount.value}${formattedCount.suffix}',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
      ),
    );
  }
}
