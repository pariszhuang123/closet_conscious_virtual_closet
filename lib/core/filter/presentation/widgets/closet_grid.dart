import 'package:flutter/material.dart';
import '../../../../core/widgets/layout/base_grid.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/user_photo/presentation/widgets/enhanced_user_photo.dart';
import '../../../../core/core_enums.dart';
import '../../../../item_management/core/data/models/multi_closet_minimal.dart';
import '../../../../generated/l10n.dart';

class ClosetGrid extends StatelessWidget {
  final List<MultiClosetMinimal> closets; // List of closets as MultiCloset objects
  final ScrollController scrollController;
  final ThemeData myClosetTheme;
  final CustomLogger logger;
  final String selectedClosetId;
  final ValueChanged<String> onSelectCloset;

  const ClosetGrid({
    super.key,
    required this.closets,
    required this.scrollController,
    required this.myClosetTheme,
    required this.logger,
    required this.selectedClosetId,
    required this.onSelectCloset,
  });

  @override
  Widget build(BuildContext context) {
    if (closets.isEmpty) {
      return Center(child: Text(S.of(context).noClosetsAvailable));
    }

    return BaseGrid<MultiClosetMinimal>(
      items: closets,
      scrollController: scrollController,
      logger: logger,
      crossAxisCount: 3,  // Always use itemGrid3 layout
      childAspectRatio: 2 / 3,
      itemBuilder: (context, closet, index) {
        final isSelected = closet.closetId == selectedClosetId;

        return EnhancedUserPhoto(
          imageUrl: closet.closetImage,
          itemName: closet.closetName,
          itemId: closet.closetId,
          imageSize: ImageSize.itemGrid3,
          isSelected: isSelected,
          isDisliked: false,
          onPressed: () {
            logger.i('Closet selected: ${closet.closetName}');
            onSelectCloset(closet.closetId);
          },
        );
      },
    );
  }
}
