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

    final imageSize = ImageHelper.getImageSize(crossAxisCount);
    final childAspectRatio = (!enableItemName || crossAxisCount == 5 || crossAxisCount == 7)
        ? 1 / 1
        : 2.15 / 3;

    final showItemName = enableItemName && !(crossAxisCount == 5 || crossAxisCount == 7);
    final showPricePerWear = enablePricePerWear && !(crossAxisCount == 5 || crossAxisCount == 7);

    final bloc = context.read<PhotoLibraryBloc>();

    return BlocBuilder<PhotoLibraryBloc, PhotoLibraryState>(
      builder: (context, state) {
        if (state is PhotoLibraryFailure) {
          return Center(child: Text(S.of(context).failedToLoadImages));
        }
        else if (state is! PhotoLibraryReady &&
            state is! PhotoLibraryLoadingImages &&
            state is! PhotoLibraryNoPendingItem &&
            state is! PhotoLibraryPendingItem &&
            state is! PhotoLibraryMaxSelectionReached &&
            state is! PhotoLibraryUploading) {
          logger.i("Skipping PagedGridView — current state: ${state.runtimeType}");
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ClosetProgressIndicator(),
                const SizedBox(height: 16),
                Text(state.debugLabel), // use your manual label instead of runtimeType
              ],
            ),
          );
        }

        Set<String> selectedIds = {};

        if (state is PhotoLibraryReady) {
          selectedIds = state.selectedAssetIds;
        } else if (state is PhotoLibraryMaxSelectionReached) {
          selectedIds = state.selectedAssetIds;
        } else if (state is PhotoLibraryUploading) {
          selectedIds = state.selectedAssetIds;
        } else if (state is PhotoLibraryUploadSuccess) {
          selectedIds = state.selectedAssetIds;
        } else if (state is PhotoLibraryFailure) {
          selectedIds = state.selectedAssetIds;
        } else if (state is PhotoLibraryPageLoaded) {
          selectedIds = state.selectedAssetIds;
        }

        return ValueListenableBuilder<PagingState<int, ClosetItemMinimal>>(
          valueListenable: bloc.pagingController,
          builder: (context, pagingState, child) {
            logger.d("PagedGridView rebuilding with ${pagingState.pages?.length ?? 0} page(s) loaded");

            return PagedGridView<int, ClosetItemMinimal>(
              state: pagingState,
              fetchNextPage: bloc.pagingController.fetchNextPage,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
              ),
              builderDelegate: PagedChildBuilderDelegate<ClosetItemMinimal>(
                itemBuilder: (context, item, index) {
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
                noItemsFoundIndicatorBuilder: (_) => Center(child: Text(S.of(context).noPhotosFound)),
                firstPageProgressIndicatorBuilder: (_) => const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClosetProgressIndicator(),
                      SizedBox(height: 12),
                      Text('🔄 firstPageProgressIndicatorBuilder'),
                    ],
                  ),
                ),

                newPageProgressIndicatorBuilder: (_) => const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClosetProgressIndicator(),
                      SizedBox(height: 12),
                      Text('📦 newPageProgressIndicatorBuilder'),
                    ],
                  ),
                ),
                noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
                firstPageErrorIndicatorBuilder: (_) => Center(child: Text(S.of(context).failedToLoadImages)),
                newPageErrorIndicatorBuilder: (_) => Center(child: Text(S.of(context).failedToLoadMoreImages)),
              ),
            );
          },
        );
      },
    );
  }
}
