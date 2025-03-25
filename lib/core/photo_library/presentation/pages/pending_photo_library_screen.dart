import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../utilities/logger.dart';
import '../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../bloc/photo_library_bloc.dart';
import '../../../core_enums.dart';
import '../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../widgets/layout/grid/interactive_item_grid.dart';
import '../../../widgets/button/themed_elevated_button.dart';
import '../../../../generated/l10n.dart';
import '../../../data/models/image_source.dart';

class PendingPhotoLibraryScreen extends StatefulWidget {
  const PendingPhotoLibraryScreen({super.key});

  @override
  State<PendingPhotoLibraryScreen> createState() =>
      _PendingPhotoLibraryScreen();
}

class _PendingPhotoLibraryScreen extends State<PendingPhotoLibraryScreen> {
  final _logger = CustomLogger('PendingItemGridScreen');
  final ScrollController _scrollController = ScrollController();
  late MultiSelectionItemCubit _multiSelectionCubit;

  @override
  void initState() {
    super.initState();
    _multiSelectionCubit = context.read<MultiSelectionItemCubit>();
    context.read<PhotoLibraryBloc>().add(RequestLibraryPermission());
  }

  void _uploadSelectedImages(
      List<String> selectedIds,
      List<AssetEntity> allAssets,
      ) {
    final selectedAssets =
    allAssets.where((asset) => selectedIds.contains(asset.id)).toList();
    context
        .read<PhotoLibraryBloc>()
        .add(UploadSelectedLibraryImages(assets: selectedAssets));
  }

  Future<List<ClosetItemMinimal>> _convertAssetsToItems(List<AssetEntity> assets) async {
    return Future.wait(assets.map((asset) async {
      final file = await asset.file;

      final imageSource = file != null
          ? ImageSource.localFile(file.path) // ✅ use local path for limited access
          : ImageSource.assetEntity(asset);  // ✅ fallback to AssetEntity for full access or no file

      return ClosetItemMinimal(
        itemId: asset.id,
        imageSource: imageSource,
        name: "cc_none",
        itemIsActive: true,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building PendingPhotoLibraryScreen');

    return BlocBuilder<PhotoLibraryBloc, PhotoLibraryState>(
      builder: (context, state) {
        _logger.i('PhotoLibraryBloc state: ${state.runtimeType}');

        if (state is PhotoLibraryLoadingImages ||
            state is PhotoLibraryUploading) {
          _logger.d('Showing ClosetProgressIndicator due to loading/uploading state');
          return const ClosetProgressIndicator();
        }

        if (state is PhotoLibraryImagesLoaded) {
          final assets = state.images;
          _logger.i('Loaded ${assets.length} assets');

          return FutureBuilder<List<ClosetItemMinimal>>(
            future: _convertAssetsToItems(assets),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                _logger.d('Waiting for asset conversion');
                return const ClosetProgressIndicator();
              }

              final items = snapshot.data!;
              _logger.i('Converted ${items.length} assets to ClosetItemMinimal');

              _multiSelectionCubit.initializeSelection([]);

              return Column(
                children: [
                  const SizedBox(height: 12),
                  Expanded(
                    child: BlocBuilder<MultiSelectionItemCubit,
                        MultiSelectionItemState>(
                      builder: (context, selectionState) {
                        _logger.d('Building grid with ${selectionState.selectedItemIds.length} selected');

                        return InteractiveItemGrid(
                          scrollController: _scrollController,
                          items: items,
                          crossAxisCount: 3,
                          selectedItemIds: selectionState.selectedItemIds,
                          itemSelectionMode: ItemSelectionMode.multiSelection,
                          onAction: () {}, // Add if needed
                          enablePricePerWear: false,
                          enableItemName: false,
                          isOutfit: false,
                          isLocalImage: true,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BlocBuilder<MultiSelectionItemCubit,
                        MultiSelectionItemState>(
                      builder: (context, selectionState) {
                        _logger.d(
                            'Upload button ${selectionState.hasSelectedItems ? "enabled" : "disabled"}');

                        return ThemedElevatedButton(
                          onPressed: selectionState.hasSelectedItems
                              ? () {
                            _logger.i('Uploading ${selectionState.selectedItemIds.length} selected items');
                            _uploadSelectedImages(
                              selectionState.selectedItemIds,
                              assets,
                            );
                          }
                              : null,
                          text: S.of(context).upload,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        }

        _logger.w('Unhandled state: $state');
        return const ClosetProgressIndicator();
      },
    );
  }
}
