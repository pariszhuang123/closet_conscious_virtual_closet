import 'package:flutter/material.dart';

import 'base/user_photo.dart';
import '../../../core_enums.dart';
import '../../../utilities/logger.dart';
import '../../../widgets/container/selected_container.dart';
import '../../../utilities/number_formatter.dart';
import '../../../data/models/image_source.dart';

class EnhancedUserPhoto extends StatelessWidget {
  final ImageSource imageSource;
  final bool isSelected;
  final bool isDisliked;
  final VoidCallback onPressed;
  final double? pricePerWear; // ✅ Added pricePerWear field
  final String? itemName;
  final String itemId;
  final ImageSize imageSize;
  final bool isOutfit; // ✅ Added isOutfit flag


  final CustomLogger _logger = CustomLogger('EnhancedUserPhoto');

  EnhancedUserPhoto({
    super.key,
    required this.imageSource,
    required this.isSelected,
    required this.isDisliked,
    required this.onPressed,
    this.itemName,
    this.pricePerWear, // ✅ Make it optional
    required this.itemId,
    required this.imageSize,
    required this.isOutfit, // ✅ Default to false
  });

  void _logImageSourceDetails() {
    switch (imageSource.type) {
      case ImageSourceType.remote:
        _logger.d('🌐 imageSource type: remote | URL: ${imageSource.path}');
        break;
      case ImageSourceType.assetEntity:
        final asset = imageSource.asset;
        _logger.d(
          '🖼️ imageSource type: assetEntity | assetId: ${asset?.id}, '
              'title: ${asset?.title}, path: ${asset?.relativePath}, type: ${asset?.type}',
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool showBorder = isSelected || isDisliked;

    _logger.d(
        '🔄 Building EnhancedUserPhoto → itemId: $itemId, isSelected: $isSelected, isDisliked: $isDisliked');

    _logImageSourceDetails();

    return GestureDetector(
      onTap: () {
        _logger.i('🖱️ EnhancedUserPhoto tapped → itemId: $itemId');
        onPressed();
      },
      child: Container(
        decoration: customBoxDecoration(
          showBorder: showBorder,
          borderColor: theme.colorScheme.primary,
          imageSize: imageSize,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: UserPhoto(
                imageUrl: imageSource.isRemote ? imageSource.path : null,
                asset: imageSource.isAsset ? imageSource.asset : null,
                imageSize: imageSize,
              ),
            ),
            if (itemName != null || pricePerWear != null) ...[
              const SizedBox(height: 4.0),
              Flexible(
                child: Column(
                  children: [
                    if (itemName != null)
                      Text(
                        itemName!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: (isOutfit || pricePerWear != null) ? 1 : 2,
                      ),
                    if (pricePerWear != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                              () {
                            final formattedPrice = formatNumber(pricePerWear!);
                            return "\$${formattedPrice.value}${formattedPrice.suffix} per wear";
                          }(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
