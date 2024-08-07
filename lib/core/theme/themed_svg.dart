import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'my_closet_theme.dart';
import 'my_outfit_theme.dart';
import '../widgets/button/base_button/button_utility.dart';

enum ButtonType { primary, secondary }

class ThemedSvg extends StatelessWidget {
  final String assetName;
  final bool isFromMyCloset;
  final double width;
  final double height;
  final ButtonType buttonType;
  final bool isSelected;
  final bool usePredefinedColor;

  const ThemedSvg({
    super.key,
    required this.assetName,
    required this.isFromMyCloset,
    required this.isSelected,
    required this.buttonType,
    required this.usePredefinedColor,
    this.width = 25,
    this.height = 25,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = isFromMyCloset ? myClosetTheme : myOutfitTheme;
    final Color color = ButtonUtils.getTextColor(theme, buttonType, isSelected);

    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      colorFilter: usePredefinedColor ? null : ColorFilter.mode(color, BlendMode.srcIn),
      placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
    );
  }
}
