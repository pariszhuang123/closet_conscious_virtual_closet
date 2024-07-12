import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'my_closet_theme.dart';
import 'my_outfit_theme.dart';

class ThemedSvg extends StatelessWidget {
  final String assetName;
  final bool isCloset;
  final double width;
  final double height;

  const ThemedSvg({
    super.key,
    required this.assetName,
    required this.isCloset,
    this.width = 25,
    this.height = 25,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = isCloset ? myClosetTheme : myOutfitTheme;
    final Color primaryColor = theme.colorScheme.primary;

    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
      placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
    );
  }
}
