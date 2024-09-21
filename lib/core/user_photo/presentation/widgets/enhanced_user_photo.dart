import 'package:flutter/material.dart';
import 'base/user_photo.dart';
import '../../../core_enums.dart';

class EnhancedUserPhoto extends StatelessWidget {
  final String imageUrl;
  final bool isSelected;
  final bool isDisliked;
  final VoidCallback onPressed;
  final String itemName;
  final String itemId;
  final ImageSize imageSize;

  const EnhancedUserPhoto({
    super.key,
    required this.imageUrl,
    required this.isSelected,
    required this.isDisliked,
    required this.onPressed,
    required this.itemName,
    required this.itemId,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool showBorder = isSelected || isDisliked;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: showBorder
              ? Border.all(color: theme.colorScheme.primary, width: 3)
              : null,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: AspectRatio(
                aspectRatio: 1.0, // Ensures the image is square
                child: UserPhoto(
                  imageUrl: imageUrl,
                  imageSize: imageSize,),
              ),
            ),
            const SizedBox(height: 8.0),
            Flexible(
              child: Text(
                itemName,
                style: Theme.of(context).textTheme.labelSmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
