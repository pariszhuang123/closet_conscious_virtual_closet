import 'package:flutter/material.dart';
import '../../../../core/widgets/layout/base_layout/base_grid.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/user_photo/presentation/widgets/enhanced_user_photo.dart';
import '../../../../core/core_enums.dart';
import '../../../../item_management/multi_closet/core/data/models/multi_closet_minimal.dart';
import '../../../../generated/l10n.dart';

class ClosetGrid extends StatelessWidget {
  final List<MultiClosetMinimal> closets; // List of closets as MultiCloset objects
  final ScrollController scrollController;
  final ThemeData myClosetTheme;
  final String selectedClosetId;
  final ValueChanged<String> onSelectCloset;
  final int crossAxisCount; // Dynamic crossAxisCount


  ClosetGrid({
    super.key,
    required this.closets,
    required this.scrollController,
    required this.myClosetTheme,
    required this.selectedClosetId,
    required this.onSelectCloset,
    required this.crossAxisCount, // Add crossAxisCount as a required parameter
  }) : _logger = CustomLogger('ClosetGrid');

  final CustomLogger _logger;

  ImageSize _getImageSize(int crossAxisCount) {
    switch (crossAxisCount) {
      case 2:
        return ImageSize.itemGrid2;
      case 3:
        return ImageSize.itemGrid3;
      case 5:
        return ImageSize.itemGrid5;
      case 7:
        return ImageSize.itemGrid7;
      default:
        return ImageSize.itemGrid3; // Default to itemGrid3 if not matched
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = _getImageSize(crossAxisCount);
    final showItemName = !(crossAxisCount == 5 || crossAxisCount == 7);
    final childAspectRatio = (crossAxisCount == 5 || crossAxisCount == 7) ? 4 / 5 : 2 / 3;

    if (closets.isEmpty) {
      return Center(child: Text(S.of(context).noClosetsAvailable));
    }

    return BaseGrid<MultiClosetMinimal>(
      items: closets,
      scrollController: scrollController,
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      itemBuilder: (context, closet, index) {
        final isSelected = closet.closetId == selectedClosetId;

        return EnhancedUserPhoto(
          imageUrl: closet.closetImage,
          itemName: showItemName ? closet.closetName : null,
          itemId: closet.closetId,
          imageSize: imageSize,
          isSelected: isSelected,
          isDisliked: false,
          onPressed: () {
            _logger.i('Closet selected: ${closet.closetName}');
            onSelectCloset(closet.closetId);
          },
        );
      },
    );
  }
}
