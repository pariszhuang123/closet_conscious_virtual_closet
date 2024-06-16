import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TypeButton extends StatelessWidget {
  final String label;
  final String selectedLabel;
  final VoidCallback onPressed;
  final String? imageUrl;

  const TypeButton({
    super.key,
    required this.label,
    required this.selectedLabel,
    required this.onPressed,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedLabel == label;
    final theme = Theme.of(context);


    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: theme.colorScheme.primary, width: 2) : null,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageUrl != null) _buildImage(imageUrl!),
            const SizedBox(height: 4),
            Text(
              label[0].toUpperCase() + label.substring(1),
              style: TextStyle(
                color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.endsWith('.svg')) {
      return SvgPicture.network(
        url,
        width: 50,
        height: 50,
        placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
      );
    } else {
      return Image.network(
        url,
        width: 50,
        height: 50,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return const Icon(Icons.error); // Display an error icon if image fails to load
        },
      );
    }
  }
}
