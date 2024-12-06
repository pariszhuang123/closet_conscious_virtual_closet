import 'package:flutter/material.dart';

import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../core/user_photo/presentation/widgets/enhanced_user_photo.dart';
import '../../../../core/core_enums.dart';

class SelectableGridItem extends StatelessWidget {
  final ClosetItemMinimal item;
  final bool isSelected;
  final VoidCallback onToggleSelection;
  final int crossAxisCount;
  final ImageSize imageSize;
  final bool showItemName;

  const SelectableGridItem({
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
    return EnhancedUserPhoto(
      imageUrl: item.imageUrl,
      imageSize: imageSize,
      isSelected: isSelected,
      isDisliked: false,
      onPressed: onToggleSelection, // Pass onToggleSelection here
      itemName: showItemName ? item.name : null,
      itemId: item.itemId,
    );
  }
}
