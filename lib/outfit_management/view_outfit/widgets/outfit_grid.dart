import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utilities/logger.dart';
import '../../create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import '../../../core/widgets/base_grid.dart';
import '../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../core/widgets/user_photo/enhanced_user_photo.dart';

class OutfitGrid extends StatelessWidget {
  final ScrollController scrollController;
  final CustomLogger logger;

  const OutfitGrid({
    super.key,
    required this.scrollController,
    required this.logger,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOutfitItemBloc, CreateOutfitItemState>(
      builder: (context, state) {
        if (state.saveStatus == SaveStatus.failure) {
          return const Center(child: Text('Failed to load items'));
        } else if (state.saveStatus == SaveStatus.initial || state.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final selectedCategory = state.currentCategory;
          final items = state.items.where((item) {
            switch (selectedCategory) {
              case OutfitItemCategory.clothing:
                return item.itemType == 'clothing';
              case OutfitItemCategory.accessory:
                return item.itemType == 'accessory';
              case OutfitItemCategory.shoes:
                return item.itemType == 'shoes';
              default:
                return false;
            }
          }).toList();

          final selectedItems = state.selectedItemIds[selectedCategory] ?? [];

          logger.d('OutfitGrid: Displaying ${items.length} items for category $selectedCategory');

          return BaseGrid<ClosetItemMinimal>(
            items: items,
            scrollController: scrollController,
            logger: logger,
            itemBuilder: (context, item, index) {
              final isSelected = selectedItems.contains(item.itemId);

              return EnhancedUserPhoto(
                imageUrl: item.imageUrl,
                isSelected: isSelected,
                onPressed: () {
                  if (isSelected) {
                    context.read<CreateOutfitItemBloc>().add(DeselectItemEvent(selectedCategory!, item.itemId));
                  } else {
                    context.read<CreateOutfitItemBloc>().add(SelectItemEvent(selectedCategory!, item.itemId));
                  }
                },
                itemName: item.name,
                itemId: item.itemId,
              );
            },
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
          );
        }
      },
    );
  }
}
