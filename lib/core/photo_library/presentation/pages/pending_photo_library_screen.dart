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
import '../../../user_photo/presentation/widgets/base/user_photo.dart';

class PendingPhotoLibraryScreen extends StatefulWidget {
  const PendingPhotoLibraryScreen({super.key});

  @override
  State<PendingPhotoLibraryScreen> createState() => _PendingPhotoLibraryScreen();
}

class _PendingPhotoLibraryScreen extends State<PendingPhotoLibraryScreen> {
  final _logger = CustomLogger('PendingItemGridScreen');
  final ScrollController _scrollController = ScrollController();
  late MultiSelectionItemCubit _multiSelectionCubit;

  @override
  void initState() {
    super.initState();
    _logger.i('initState - initializing PendingPhotoLibraryScreen');
    _multiSelectionCubit = context.read<MultiSelectionItemCubit>();
    context.read<PhotoLibraryBloc>().add(RequestLibraryPermission());
  }

  void _uploadSelectedImages(List<String> selectedIds, List<AssetEntity> allAssets) {
    _logger.i('Preparing to upload. Selected IDs: $selectedIds');

    final selectedAssets = allAssets.where((asset) {
      final selected = selectedIds.contains(asset.id);
      if (selected) {
        _logger.d('Selected asset for upload: ${asset.id}');
      }
      return selected;
    }).toList();

    _logger.i('Total assets selected for upload: ${selectedAssets.length}');
    context.read<PhotoLibraryBloc>().add(UploadSelectedLibraryImages(assets: selectedAssets));
  }

  Future<List<ClosetItemMinimal>> _convertAssetsToItems(List<AssetEntity> assets) async {
    _logger.i('Converting ${assets.length} assets to ClosetItemMinimal');

    return Future.wait(assets.map((asset) async {
      final file = await asset.file;

      if (file != null) {
        _logger.d('Asset ${asset.id} resolved to file: ${file.path}');
      } else {
        _logger.w('Asset ${asset.id} had no accessible file, falling back to assetEntity');
      }

      final imageSource = file != null
          ? ImageSource.localFile(file.path)
          : ImageSource.assetEntity(asset);

      return ClosetItemMinimal(
        itemId: asset.id,
        imageSource: imageSource,
        name: "cc_none",
        itemIsActive: true,
      );
    }));
  }

  @override
  void dispose() {
    _logger.i('Disposing PendingPhotoLibraryScreen - clearing UserPhoto cache');
    UserPhoto.clearCache(); // 👈 clear the static in-memory image cache
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building PendingPhotoLibraryScreen');

    return BlocBuilder<PhotoLibraryBloc, PhotoLibraryState>(
      builder: (context, state) {
        _logger.i('PhotoLibraryBloc state: ${state.runtimeType}');

        if (state is PhotoLibraryLoadingImages || state is PhotoLibraryUploading) {
          _logger.d('Showing ClosetProgressIndicator due to loading/uploading state');
          return const ClosetProgressIndicator();
        }

        if (state is PhotoLibraryImagesLoaded) {
          final assets = state.images;
          _logger.i('Loaded ${assets.length} assets');

          for (final asset in assets) {
            _logger.d('Loaded assetId: ${asset.id}');
          }

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
                    child: BlocBuilder<MultiSelectionItemCubit, MultiSelectionItemState>(
                      builder: (context, selectionState) {
                        _logger.d('Building grid with ${selectionState.selectedItemIds.length} selected');
                        _logger.d('Selected item IDs: ${selectionState.selectedItemIds}');

                        return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),

                            child: InteractiveItemGrid(
                              scrollController: _scrollController,
                              items: items,
                              crossAxisCount: 3,
                              selectedItemIds: selectionState.selectedItemIds,
                              itemSelectionMode: ItemSelectionMode.multiSelection,
                              onAction: () {}, // Optional: Add action if needed
                              enablePricePerWear: false,
                              enableItemName: false,
                              isOutfit: false,
                              isLocalImage: true,
                            )
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BlocBuilder<MultiSelectionItemCubit, MultiSelectionItemState>(
                      builder: (context, selectionState) {
                        final hasItems = selectionState.hasSelectedItems;
                        _logger.d('Upload button is ${hasItems ? "enabled" : "disabled"}');

                        return ThemedElevatedButton(
                          onPressed: hasItems
                              ? () {
                            _logger.i('Upload button clicked');
                            _logger.i('Selected item IDs to upload: ${selectionState.selectedItemIds}');
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

        _logger.w('Unhandled state in PhotoLibraryBloc: $state');
        return const ClosetProgressIndicator();
      },
    );
  }
}
