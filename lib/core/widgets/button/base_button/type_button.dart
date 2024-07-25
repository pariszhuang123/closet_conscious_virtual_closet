import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/themed_svg.dart';


class TypeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String imagePath;
  final bool isAsset;
  final bool isSelected;
  final bool isHorizontal;
  final bool isFromMyCloset;
  final ButtonType buttonType;

  const TypeButton({
    super.key,
    this.onPressed,
    required this.imagePath,
    this.isAsset = false,
    this.isSelected = false,
    this.isHorizontal = false,
    required this.isFromMyCloset,
    this.buttonType = ButtonType.primary,
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
    if (isAsset) {
      return ThemedSvg(
        assetName: imagePath,
        isFromMyCloset: isFromMyCloset,
        isSelected: isSelected,
        buttonType: buttonType,// Pass the isSelected parameter
      );
    } else {
      if (imagePath.endsWith('.svg')) {
        return SvgPicture.network(
          imagePath,
          width: 25,
          height: 25,
          placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
        );
      } else {
        return Image.network(
          imagePath,
          width: 25,
          height: 25,
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return const Icon(Icons.error);
          },
        );
      }
    }
  }

  Widget buildContent(BuildContext context) {
    return const SizedBox.shrink();
  }
}
