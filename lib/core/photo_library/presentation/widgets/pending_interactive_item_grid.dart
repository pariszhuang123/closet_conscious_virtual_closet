import 'package:closet_conscious/core/widgets/progress_indicator/closet_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../utilities/logger.dart';
import '../../../utilities/helper_functions/image_helper/image_helper.dart';
import '../../../widgets/layout/grid_item/grid_item.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../bloc/photo_library_bloc.dart';
import '../../../../generated/l10n.dart';

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

    return ValueListenableBuilder<PagingState<int, ClosetItemMinimal>>(
      valueListenable: bloc.pagingController,
      builder: (context, state, child) {
        logger.d("PagedGridView rebuilding with ${state.pages?.length ?? 0} page(s) loaded");
        return PagedGridView<int, ClosetItemMinimal>(
          state: state,
          fetchNextPage: bloc.pagingController.fetchNextPage,
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

              return ValueListenableBuilder<Set<String>>(
                valueListenable: bloc.selectedImageIdsNotifier,
                builder: (context, selectedIds, _) {
                  final asset = bloc.findAssetById(item.itemId);
                  final isSelected = asset != null && selectedIds.contains(asset.id);

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
                      final asset = bloc.findAssetById(item.itemId);
                      if (asset != null) {
                        bloc.add(ToggleLibraryImageSelection(image: asset));
                      }
                    },
                  );
                },
              );
            },
            noItemsFoundIndicatorBuilder: (_) {
              logger.i("No items found in image grid.");
              return Center(child: Text(S.of(context).noPhotosFound));
            },
            firstPageProgressIndicatorBuilder: (_) {
              logger.i("Loading first page of images...");
              return const Center(child: ClosetProgressIndicator());
            },
            newPageProgressIndicatorBuilder: (_) {
              logger.i("Loading next page of images...");
              return const Center(child: ClosetProgressIndicator());
            },
            noMoreItemsIndicatorBuilder: (_) {
              logger.i("No more pages to load.");
              return const SizedBox.shrink();
            },
            firstPageErrorIndicatorBuilder: (_) {
              logger.e("Error loading first page of images.");
              return Center(child: Text(S.of(context).failedToLoadImages));
            },
            newPageErrorIndicatorBuilder: (_) {
              logger.e("Error loading new page of images.");
              return Center(child: Text(S.of(context).failedToLoadMoreImages));
            },
          ),
        );
      },
    );
  }
}
