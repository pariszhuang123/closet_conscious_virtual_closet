import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../utilities/logger.dart';
import '../../../utilities/helper_functions/image_helper/image_helper.dart';
import '../../../widgets/layout/grid_item/grid_item.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../bloc/photo_library_bloc.dart';

class PendingInteractiveItemGrid extends StatelessWidget {
  final int crossAxisCount;
  final bool enablePricePerWear;
  final bool enableItemName;
  final bool isOutfit;
  final bool isLocalImage;

  const PendingInteractiveItemGrid({
    super.key,
    required this.crossAxisCount,
    this.enablePricePerWear = false,
    this.enableItemName = true,
    this.isOutfit = false,
    this.isLocalImage = true,
  });

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('PendingInteractiveItemGrid');

    logger.i("Building PendingInteractiveItemGrid");
    logger.d("Props - crossAxisCount: $crossAxisCount, "
        "enablePricePerWear: $enablePricePerWear, "
        "enableItemName: $enableItemName, isOutfit: $isOutfit, "
        "isLocalImage: $isLocalImage");

    final imageSize = ImageHelper.getImageSize(crossAxisCount);
    logger.d("Calculated image size: $imageSize");

    final childAspectRatio = (!enableItemName || crossAxisCount == 5 || crossAxisCount == 7)
        ? 1 / 1
        : 2.15 / 3;
    logger.d("Child aspect ratio set to: $childAspectRatio");

    final showItemName = enableItemName && !(crossAxisCount == 5 || crossAxisCount == 7);
    final showPricePerWear = enablePricePerWear && !(crossAxisCount == 5 || crossAxisCount == 7);

    final bloc = context.read<PhotoLibraryBloc>();
    final pagingController = bloc.pagingController;

    return PagedGridView<int, ClosetItemMinimal>(
      state: pagingController.value,
      fetchNextPage: () {
        logger.i("Fetching next image page...");
        pagingController.fetchNextPage();
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
      ),
      builderDelegate: PagedChildBuilderDelegate<ClosetItemMinimal>(
        itemBuilder: (context, item, index) {
          logger.d("Rendering item: index=$index, itemId=${item.itemId}");

          final asset = bloc.findAssetById(item.itemId);
          final isSelected = asset != null &&
              bloc.selectedImages.any((selected) => selected.id == asset.id);

          if (asset == null) {
            logger.w("Asset not found for itemId: ${item.itemId}");
          } else {
            logger.d("Asset found for itemId: ${item.itemId}, isSelected: $isSelected");
          }

          return GridItem(
            key: ValueKey('${item.itemId}_$isSelected'),
            item: item,
            isSelected: isSelected,
            isDisliked: item.isDisliked,
            imageSize: imageSize,
            showItemName: showItemName,
            showPricePerWear: showPricePerWear,
            isOutfit: isOutfit,
            onItemTapped: () {
              logger.i("Tapped on itemId: ${item.itemId}");
              if (asset != null) {
                logger.d("Dispatching ToggleLibraryImageSelection for itemId: ${item.itemId}");
                bloc.add(ToggleLibraryImageSelection(image: asset));
              } else {
                logger.w("Could not dispatch ToggleLibraryImageSelection - asset null for itemId: ${item.itemId}");
              }
            },
          );
        },
        noItemsFoundIndicatorBuilder: (_) {
          logger.i("No items found in image grid.");
          return const Center(child: Text("No photos found"));
        },
        firstPageProgressIndicatorBuilder: (_) {
          logger.i("Loading first page of images...");
          return const Center(child: CircularProgressIndicator());
        },
        newPageProgressIndicatorBuilder: (_) {
          logger.i("Loading next page of images...");
          return const Center(child: CircularProgressIndicator());
        },
        noMoreItemsIndicatorBuilder: (_) {
          logger.i("No more pages to load.");
          return const SizedBox.shrink();
        },
        firstPageErrorIndicatorBuilder: (_) {
          logger.e("Error loading first page of images.");
          return const Center(child: Text("Failed to load images"));
        },
        newPageErrorIndicatorBuilder: (_) {
          logger.e("Error loading new page of images.");
          return const Center(child: Text("Failed to load more images"));
        },
      ),
    );
  }
}
