import 'package:flutter/material.dart';
import '../../../core_enums.dart';

class ButtonUtils {
  static Color getTextColor(ThemeData theme, ButtonType buttonType, bool isSelected) {
    if (isSelected) {
      return theme.colorScheme.primary;
    } else {
      switch (buttonType) {
        case ButtonType.primary:
          return theme.colorScheme.primary;
        case ButtonType.secondary:
          return theme.colorScheme.secondary;
      }
    }
  }
}
