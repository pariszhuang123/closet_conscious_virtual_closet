import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TypeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? imageUrl;
  final bool isSelected;

  const TypeButton({
    super.key,
    this.onPressed,
    this.imageUrl,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: theme.colorScheme.primary, width: 2) : Border.all(color: Colors.grey, width: 1),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the children vertically
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageUrl != null) _buildImage(imageUrl!),
            const SizedBox(height: 4),
            buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
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
