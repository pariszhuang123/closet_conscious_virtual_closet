import 'package:flutter/material.dart';

import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../core/user_photo/presentation/widgets/enhanced_user_photo.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/utilities/logger.dart';

class SelectableGridItem extends StatelessWidget {
  final ClosetItemMinimal item;
  final bool isSelected;
  final VoidCallback onToggleSelection;
  final int crossAxisCount;
  final ImageSize imageSize;
  final bool showItemName;

  final CustomLogger _logger = CustomLogger('SelectableGridItem');

  SelectableGridItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onToggleSelection,
    required this.crossAxisCount,
    required this.imageSize,
    required this.showItemName,
  });

  @override
  Widget build(BuildContext context) {
    _logger.d('Building SelectableGridItem - Item ID: ${item.itemId}, isSelected: $isSelected');

    return Container(
      key: ValueKey('${item.itemId}_$isSelected'), // Composite key ensures rebuilds when selection state changes
      child: EnhancedUserPhoto(
        imageUrl: item.imageUrl,
        imageSize: imageSize,
        isSelected: isSelected,
        isDisliked: false,
        onPressed: () {
          _logger.i('Item tapped - Item ID: ${item.itemId}, toggling selection');
          onToggleSelection(); // Trigger the selection callback
        },
        itemName: showItemName ? item.name : null,
        itemId: item.itemId,
      ),
    );
  }
}
