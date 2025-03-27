import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../utilities/logger.dart';
import '../../../utilities/helper_functions/image_helper/image_helper.dart';
import '../../../widgets/layout/base_layout/base_grid.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../widgets/layout/grid_item/grid_item.dart';
import '../bloc/photo_library_bloc.dart';

class PendingInteractiveItemGrid extends StatelessWidget {
  final ScrollController? scrollController;
  final List<ClosetItemMinimal> items;
  final List<AssetEntity> assets;
  final int crossAxisCount;
  final VoidCallback? onAction;
  final bool enablePricePerWear;
  final bool enableItemName;
  final bool isOutfit;
  final bool isLocalImage;

  const PendingInteractiveItemGrid({
    super.key,
    this.scrollController,
    required this.items,
    required this.assets,
    required this.crossAxisCount,
    this.onAction,
    this.enablePricePerWear = false,
    this.enableItemName = true,
    this.isOutfit = false,
    this.isLocalImage = true,
  });


  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('PendingInteractiveItemGrid');
    final imageSize = ImageHelper.getImageSize(crossAxisCount);
    final childAspectRatio = (!enableItemName || crossAxisCount == 5 || crossAxisCount == 7)
        ? 1 / 1
        : 2.15 / 3;
    final showItemName = enableItemName && !(crossAxisCount == 5 || crossAxisCount == 7);
    final showPricePerWear = enablePricePerWear && !(crossAxisCount == 5 || crossAxisCount == 7);

    return BlocBuilder<PhotoLibraryBloc, PhotoLibraryState>(
      builder: (context, state) {
        // Get the currently selected assets from the bloc state.
        List<AssetEntity> selectedAssets = [];
        if (state is PhotoLibraryImagesLoaded) {
          selectedAssets = state.selectedImages;
        }

        return BaseGrid<ClosetItemMinimal>(
          items: items,
          scrollController: scrollController,
          shrinkWrap: false,
          isScrollable: true,
          itemBuilder: (context, item, index) {
            // Find the AssetEntity that corresponds to this item.
            AssetEntity? asset;
            try {
              asset = assets.firstWhere((a) => a.id == item.itemId);
            } catch (_) {
              asset = null;
            }
            final bool isSelected = selectedAssets.any((selected) => selected.id == asset?.id);

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
                if (asset != null) {
                  // Dispatch the event to toggle selection in the PhotoLibraryBloc.
                  context
                      .read<PhotoLibraryBloc>()
                      .add(ToggleLibraryImageSelection(image: asset));
                } else {
                  logger.e('Asset not found for item ${item.itemId}');
                }
              },
            );
          },
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
        );
      },
    );
  }
}
