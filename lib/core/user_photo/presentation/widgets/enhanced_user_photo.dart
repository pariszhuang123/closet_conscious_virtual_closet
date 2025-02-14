import 'package:flutter/material.dart';

import 'base/user_photo.dart';
import '../../../core_enums.dart';
import '../../../utilities/logger.dart';


class EnhancedUserPhoto extends StatelessWidget {
  final String imageUrl;
  final bool isSelected;
  final bool isDisliked;
  final VoidCallback onPressed;
  final String? itemName;
  final String itemId;
  final ImageSize imageSize;

  final CustomLogger _logger = CustomLogger('EnhancedUserPhoto');

  EnhancedUserPhoto({
    super.key,
    required this.imageUrl,
    required this.isSelected,
    required this.isDisliked,
    required this.onPressed,
    this.itemName,
    required this.itemId,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool showBorder = isSelected || isDisliked;

    _logger.d('Building EnhancedUserPhoto - Item ID: $itemId, isSelected: $isSelected, isDisliked: $isDisliked');

    return GestureDetector(
      onTap: () {
        _logger.i('EnhancedUserPhoto tapped - Item ID: $itemId');
        onPressed(); // Trigger the onPressed callback
      },
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
            if (itemName != null) // Only show if itemName is not null
              Flexible(
                child: Text(
                  itemName!,
                  style: Theme.of(context).textTheme.bodyMedium,
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
