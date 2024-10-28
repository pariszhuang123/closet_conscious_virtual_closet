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

  const OutfitGrid({
    super.key,
    required this.scrollController,
    required this.logger,
    required this.items,  // Ensure this is passed
  });

  @override
  Widget build(BuildContext context) {
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
                  imageSize: ImageSize.itemGrid3,
                  isSelected: isSelected,
                  isDisliked: false,
                  onPressed: () {
                    context.read<CreateOutfitItemBloc>().add(ToggleSelectItemEvent(selectedCategory, item.itemId));
                  },
                  itemName: item.name,
                  itemId: item.itemId,
                );
              },
              crossAxisCount: 3,
              childAspectRatio: 2 / 3,
            ),
          );
        }
      },
    );
  }
}
