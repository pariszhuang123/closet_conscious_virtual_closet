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
  final bool showPricePerWear; // ✅ New parameter
  final bool isOutfit;

  final CustomLogger _logger = CustomLogger('GridItem');

  GridItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isDisliked,
    required this.onItemTapped,
    required this.imageSize,
    required this.showItemName,
    required this.showPricePerWear, // ✅ Accept the new parameter
    required this.isOutfit,
  });

  @override
  Widget build(BuildContext context) {
    final asset = item.imageSource.asset;

    _logger.d(
        'GridItem build → itemId: ${item.itemId}, '
            'imageSource: ${item.imageSource}, '
            'assetId: ${asset?.id}, '
            'assetType: ${asset?.type}, '
            'title: ${asset?.title}, '
            'relativePath: ${asset?.relativePath}, '
            'isLocallyAvailable: ${asset == null ? 'null' : 'TBD'}'
    );

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
      showPricePerWear: showPricePerWear, // ✅ Pass to BaseGridItem
      isOutfit: isOutfit,
      getItemName: (item) => item.name,
      getItemId: (item) => item.itemId,
      getImageSource: (item) => item.imageSource, // ✅ FIXED
      getIsActive: (item) => item.itemIsActive, // ✅ Pass isActive to BaseGridItem
      getPricePerWear: (item) => item.pricePerWear, // ✅ Add this line
    );
  }
}
