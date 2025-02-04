import 'package:flutter/material.dart';
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
  final String Function(T item) getItemName;
  final String Function(T item) getItemId;
  final String Function(T item) getImageUrl;
  final bool Function(T item)? getIsActive; // ✅ Optional function to check if active

  final CustomLogger _logger;

  BaseGridItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isDisliked,
    required this.onItemTapped,
    required this.imageSize,
    required this.showItemName,
    required this.getItemName,
    required this.getItemId,
    required this.getImageUrl,
    this.getIsActive, // ✅ Allow checking if item is active
  }) : _logger = CustomLogger('BaseGridItem');

  @override
  Widget build(BuildContext context) {
    final itemId = getItemId(item);
    final isActive = getIsActive != null ? getIsActive!(item) : true; // ✅ Default to active if missing

    // Log the rendering process
    _logger.d('Rendering BaseGridItem for itemId: $itemId, isSelected: $isSelected, isActive: $isActive');

    return Container(
      key: ValueKey('${itemId}_$isSelected'), // Composite key for rebuild accuracy
      child: GrayscaleWrapper(
        applyGrayscale: !isActive, // ✅ Apply grayscale when item is inactive
        child: EnhancedUserPhoto(
          imageUrl: getImageUrl(item),
          isSelected: isSelected,
          isDisliked: isDisliked,
          onPressed: () {
            _logger.i('Item tapped - itemId: $itemId');
            onItemTapped();
          },
          itemName: showItemName ? getItemName(item) : null,
          itemId: itemId,
          imageSize: imageSize,
        ),
      ),
    );
  }
}
