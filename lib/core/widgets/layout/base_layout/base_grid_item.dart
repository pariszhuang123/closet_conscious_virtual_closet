import 'package:flutter/material.dart';

import '../../../../core/data/models/image_source.dart';
import '../../../../core/user_photo/presentation/widgets/enhanced_user_photo.dart';
import '../../../../core/core_enums.dart';
import '../../../utilities/logger.dart';
import '../../../../core/theme/grayscale_wrapper.dart'; // ✅ Import GrayscaleWrapper

class BaseGridItem<T> extends StatelessWidget {
  final T item;
  final bool isSelected;
  final bool isDisliked;
  final VoidCallback onItemTapped;
  final ImageSize imageSize;
  final bool showItemName;
  final bool showPricePerWear;
  final String Function(T item) getItemName;
  final String Function(T item) getItemId;
  final ImageSource Function(T item) getImageSource;
  final bool Function(T item)? getIsActive; // ✅ Optional function to check if active
  final double? Function(T item)? getPricePerWear; // ✅ Optional function
  final bool isOutfit; // ✅ Added isOutfit flag

  final CustomLogger _logger;

  BaseGridItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isDisliked,
    required this.onItemTapped,
    required this.imageSize,
    required this.showItemName,
    required this.showPricePerWear,
    required this.getItemName,
    required this.getItemId,
    required this.getImageSource, // ✅ new
    this.getIsActive, // ✅ Allow checking if item is active
    this.getPricePerWear, // ✅ Optional
    required this.isOutfit, // ✅ Default to false

  }) : _logger = CustomLogger('BaseGridItem');

  void _logImageSource(ImageSource source, String itemId) {
    switch (source.type) {
      case ImageSourceType.assetEntity:
        final asset = source.asset;
        _logger.d(
          '🖼️ ImageSource for itemId=$itemId → type: assetEntity | '
              'assetId: ${asset?.id}, title: ${asset?.title}, '
              'relativePath: ${asset?.relativePath}, type: ${asset?.type}',
        );
        break;
      case ImageSourceType.remote:
        _logger.d('🌐 ImageSource for itemId=$itemId → type: remote | url: ${source.path}');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemId = getItemId(item);
    final isActive = getIsActive != null ? getIsActive!(item) : true; // ✅ Default to active if missing
    final pricePerWear = getPricePerWear != null ? getPricePerWear!(item) : null;
    final imageSource = getImageSource(item);

    // Log the rendering process
    _logger.d(
      '🔄 Rendering BaseGridItem → itemId: $itemId | '
          'isSelected: $isSelected | isDisliked: $isDisliked | '
          'isActive: $isActive | showItemName: $showItemName | '
          'showPricePerWear: $showPricePerWear | pricePerWear: $pricePerWear',
    );

    _logImageSource(imageSource, itemId);

    return Container(
      key: ValueKey('${itemId}_${isSelected || isDisliked}'), // Unified selection logic
      child: GrayscaleWrapper(
        applyGrayscale: !isActive, // ✅ Apply grayscale when item is inactive
        child: EnhancedUserPhoto(
          imageSource: getImageSource(item),
          isSelected: isSelected,
          isDisliked: isDisliked,
          isOutfit: isOutfit,
          onPressed: () {
            _logger.i('🖱️ Item tapped → itemId: $itemId, sourceType: ${imageSource.runtimeType}');
            onItemTapped();
          },
          itemName: showItemName ? getItemName(item) : null,
          pricePerWear: (showPricePerWear && pricePerWear != null) ? pricePerWear : null, // ✅ Show price only when applicable
          itemId: itemId,
          imageSize: imageSize,
        ),
      ),
    );
  }
}
