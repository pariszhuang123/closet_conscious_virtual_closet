import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utilities/logger.dart';
import '../../../create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import '../../../../core/widgets/layout/base_grid.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../core/user_photo/presentation/widgets/enhanced_user_photo.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/core_enums.dart';
import '../../../core/outfit_enums.dart';

class OutfitGrid extends StatelessWidget {
  final ScrollController scrollController;
  final CustomLogger logger;
  final List<ClosetItemMinimal> items;  // Add this line
  final int crossAxisCount;


  const OutfitGrid({
    super.key,
    required this.scrollController,
    required this.logger,
    required this.items,  // Ensure this is passed
    required this.crossAxisCount,
  });

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

    return BlocBuilder<CreateOutfitItemBloc, CreateOutfitItemState>(
      builder: (context, state) {
        if (state.saveStatus == SaveStatus.failure) {
          return Center(child: Text(S.of(context).failedToLoadItems));
        } else if (state.saveStatus == SaveStatus.initial || items.isEmpty) {  // Use the items from the parameter
          return Center(child: Text(S.of(context).noItemsInOutfitCategory));
        } else {
          final selectedCategory = state.currentCategory;

          final selectedItems = state.selectedItemIds[selectedCategory] ?? [];

          logger.d('OutfitGrid: Displaying ${items.length} items for category $selectedCategory');

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                // Trigger fetch more items event when reaching the bottom
                context.read<CreateOutfitItemBloc>().add(FetchMoreItemsEvent());
              }
              return false; // Return false to allow the notification to continue to bubble up
            },
            child: BaseGrid<ClosetItemMinimal>( // Use 'child' to wrap the BaseGrid
              items: items,  // Use the items passed into the widget
              scrollController: scrollController,
              logger: logger,
              itemBuilder: (context, item, index) {
                final isSelected = selectedItems.contains(item.itemId);

                return EnhancedUserPhoto(
                  imageUrl: item.imageUrl,
                  imageSize: imageSize,
                  isSelected: isSelected,
                  isDisliked: false,
                  onPressed: () {
                    context.read<CreateOutfitItemBloc>().add(ToggleSelectItemEvent(selectedCategory, item.itemId));
                  },
                  itemName: showItemName ? item.name : null,
                  itemId: item.itemId,
                );
              },
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
            ),
          );
        }
      },
    );
  }
}
