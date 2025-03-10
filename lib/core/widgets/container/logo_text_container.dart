import 'package:flutter/material.dart';
import 'base_container.dart';
import '../../core_enums.dart';
import '../../theme/themed_svg.dart';

class LogoTextContainer extends StatelessWidget {
  final ThemeData themeData;
  final String text;
  final bool isFromMyCloset;
  final ButtonType buttonType;
  final bool isSelected;
  final bool usePredefinedColor;

  const LogoTextContainer({
    super.key,
    required this.themeData,
    required this.text,
    required this.isFromMyCloset,
    required this.buttonType,
    required this.isSelected,
    required this.usePredefinedColor,
  });

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      theme: themeData,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ThemedSvg(
            assetName: 'assets/images/SVG_CC_Logo.svg',
            isFromMyCloset: isFromMyCloset,
            isSelected: isSelected,
            buttonType: buttonType,
            usePredefinedColor: usePredefinedColor,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                text,
                style: themeData.textTheme.titleMedium,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ThemedSvg(
            assetName: 'assets/images/SVG_CC_Logo.svg',
            isFromMyCloset: isFromMyCloset,
            isSelected: isSelected,
            buttonType: buttonType,
            usePredefinedColor: usePredefinedColor,
          ),
        ],
      ),
    );
  }
}
