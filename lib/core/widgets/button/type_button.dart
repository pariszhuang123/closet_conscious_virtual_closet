import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TypeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String imageUrl;
  final bool isSelected;
  final bool isHorizontal;

  const TypeButton({
    super.key, // This is the widget key
    this.onPressed,
    required this.imageUrl,
    this.isSelected = false,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = Container(
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.surface : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: theme.colorScheme.primary, width: 3) : null,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the children vertically
        mainAxisSize: MainAxisSize.min,
        children: [
          buildImage(imageUrl),
          const SizedBox(height: 4),
          buildContent(context),
        ],
      ),
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
        mainAxisAlignment: MainAxisAlignment.center, // Center the children horizontally
        mainAxisSize: MainAxisSize.min,
        children: [
          buildContent(context),
          const SizedBox(width: 4),
          buildImage(imageUrl),
        ],
      );
    }


  Widget buildVerticalContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center the children vertically
      mainAxisSize: MainAxisSize.min,
      children: [
        buildImage(imageUrl),
        const SizedBox(height: 4),
        buildContent(context),
      ],
    );
  }

  Widget buildImage(String url) {
    if (url.endsWith('.svg')) {
      return SvgPicture.network(
        url,
        width: 25,
        height: 25,
        placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
      );
    } else {
      return Image.network(
        url,
        width: 25,
        height: 25,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return const Icon(Icons.error); // Display an error icon if image fails to load
        },
      );
    }
  }

  Widget buildContent(BuildContext context) {
    return const SizedBox.shrink(); // Placeholder for derived classes to override
  }
}
