import 'package:flutter/material.dart';
import '../base_layout/base_grid_item.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../core/core_enums.dart';
import '../../../utilities/logger.dart';

class GridItem extends StatelessWidget {
  final ClosetItemMinimal item;
  final bool isSelected;
  final bool isDisliked;
  final VoidCallback onItemTapped;
  final ImageSize imageSize;
  final bool showItemName;

  final CustomLogger _logger = CustomLogger('GridItem');

  GridItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isDisliked,
    required this.onItemTapped,
    required this.imageSize,
    required this.showItemName,
  });

  @override
  Widget build(BuildContext context) {
    _logger.d('Building GridItem: ${item.itemId}, isSelected: $isSelected, isDisliked: $isDisliked');

    return BaseGridItem<ClosetItemMinimal>(
      item: item,
      isSelected: isSelected,
      isDisliked: isDisliked,
      onItemTapped: () {
        _logger.i('Item tapped: ${item.itemId}');
        onItemTapped();
      },
      imageSize: imageSize,
      showItemName: showItemName,
      getItemName: (item) => item.name,
      getItemId: (item) => item.itemId,
      getImageUrl: (item) => item.imageUrl,
    );
  }
}
