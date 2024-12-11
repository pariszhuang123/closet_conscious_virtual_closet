import 'package:flutter/material.dart';
import '../base_layout/base_grid_item.dart';
import '../../../../item_management/multi_closet/core/data/models/multi_closet_minimal.dart';
import '../../../../core/core_enums.dart';
import '../../../utilities/logger.dart';

class GridClosetItem extends StatelessWidget {
  final MultiClosetMinimal item;
  final bool isSelected;
  final bool isDisliked;
  final VoidCallback onItemTapped;
  final ImageSize imageSize;
  final bool showItemName;

  final CustomLogger _logger = CustomLogger('GridClosetItem');

  GridClosetItem({
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
    _logger.d('Building GridClosetItem: ${item.closetId}, isSelected: $isSelected, isDisliked: $isDisliked');

    return BaseGridItem<MultiClosetMinimal>(
      item: item,
      isSelected: isSelected,
      isDisliked: isDisliked,
      onItemTapped: () {
        _logger.i('Item tapped: ${item.closetId}');
        onItemTapped();
      },
      imageSize: imageSize,
      showItemName: showItemName,
      getItemName: (item) => item.closetName,
      getItemId: (item) => item.closetId,
      getImageUrl: (item) => item.closetImage,
    );
  }
}
