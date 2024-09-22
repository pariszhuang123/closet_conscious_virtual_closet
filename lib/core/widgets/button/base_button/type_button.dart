import 'package:flutter/material.dart';
import '../../../core_enums.dart';
import '../../../theme/themed_svg.dart';

class TypeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String assetPath;
  final bool isSelected;
  final bool isHorizontal;
  final bool isFromMyCloset;
  final ButtonType buttonType;
  final bool usePredefinedColor;

  const TypeButton({
    super.key,
    this.onPressed,
    required this.assetPath,
    this.isSelected = false,
    this.isHorizontal = false,
    required this.isFromMyCloset,
    this.buttonType = ButtonType.primary,
    required this.usePredefinedColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: theme.colorScheme.primary, width: 3) : null,
      ),
      padding: const EdgeInsets.all(8),
      child: isHorizontal ? buildHorizontalContent(context) : buildVerticalContent(context),
    );

    if (onPressed != null) {
      content = GestureDetector(
        onTap: onPressed,
        child: content,
      );
    }

    return content;
  }

  Widget buildHorizontalContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildImage(),
        const SizedBox(width: 4),
        buildContent(context),
      ],
    );
  }

  Widget buildVerticalContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildImage(),
        const SizedBox(height: 4),
        buildContent(context),
      ],
    );
  }

  Widget buildImage() {
    return ThemedSvg(
      assetName: assetPath,
      isFromMyCloset: isFromMyCloset,
      isSelected: isSelected,
      buttonType: buttonType,
      usePredefinedColor: usePredefinedColor,
    );
  }

  Widget buildContent(BuildContext context) {
    return const SizedBox.shrink();
  }
}
