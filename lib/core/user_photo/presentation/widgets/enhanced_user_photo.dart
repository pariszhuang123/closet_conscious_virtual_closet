import 'package:flutter/material.dart';

import 'base/user_photo.dart';
import '../../../core_enums.dart';
import '../../../utilities/logger.dart';
import '../../../widgets/container/selected_container.dart';
import '../../../utilities/number_formatter.dart';

class EnhancedUserPhoto extends StatelessWidget {
  final String imageUrl;
  final bool isSelected;
  final bool isDisliked;
  final VoidCallback onPressed;
  final double? pricePerWear; // ✅ Added pricePerWear field
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
    this.pricePerWear, // ✅ Make it optional
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
        decoration: customBoxDecoration(
          showBorder: showBorder,
          borderColor: theme.colorScheme.primary,
          imageSize: imageSize, // Pass the image size
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
            if (pricePerWear != null) // ✅ Show price per wear if available
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                      () {
                    final formattedPrice = formatNumber(pricePerWear!);
                    return "\$${formattedPrice.value}${formattedPrice.suffix} per wear";
                  }(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.secondary, // ✅ Use secondary color for contrast
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
