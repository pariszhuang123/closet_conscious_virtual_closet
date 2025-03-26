import 'package:flutter/material.dart';

import '../../../../core/utilities/helper_functions/image_helper/image_helper.dart';
import '../../../../core/widgets/layout/base_layout/base_grid.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/user_photo/presentation/widgets/enhanced_user_photo.dart';
import '../../../../item_management/multi_closet/core/data/models/multi_closet_minimal.dart';
import '../../../../generated/l10n.dart';
import '../../../data/models/image_source.dart';

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

  @override
  Widget build(BuildContext context) {
    final imageSize = ImageHelper.getImageSize(crossAxisCount);
    final showItemName = !(crossAxisCount == 5 || crossAxisCount == 7);
    final childAspectRatio =  (crossAxisCount == 5 || crossAxisCount == 7) ? 1 /
        1 : 2.15 / 3;
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
          imageSource: ImageSource.remote(closet.closetImage), // ✅ fixed
          itemName: showItemName ? closet.closetName : null,
          itemId: closet.closetId,
          imageSize: imageSize,
          isSelected: isSelected,
          isOutfit: false,
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
