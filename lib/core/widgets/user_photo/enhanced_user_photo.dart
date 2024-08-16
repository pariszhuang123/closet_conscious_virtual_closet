import 'package:flutter/material.dart';
import 'base/user_photo.dart';

class EnhancedUserPhoto extends StatelessWidget {
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onPressed;
  final String itemName;
  final String itemId;

  const EnhancedUserPhoto({
    super.key,
    required this.imageUrl,
    required this.isSelected,
    required this.onPressed,
    required this.itemName,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: theme.colorScheme.primary, width: 3)
              : null,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: AspectRatio(
                aspectRatio: 1.0, // Ensures the image is square
                child: UserPhoto(imageUrl: imageUrl),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              itemName,
              style: Theme.of(context).textTheme.labelSmall,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
