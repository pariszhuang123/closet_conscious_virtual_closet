import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../utilities/logger.dart';
import '../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../bloc/photo_library_bloc.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../widgets/button/themed_elevated_button.dart';
import '../../../../generated/l10n.dart';
import '../../../data/models/image_source.dart';
import '../../../user_photo/presentation/widgets/base/user_photo.dart';
import '../widgets/pending_interactive_item_grid.dart';
import '../../../widgets/feedback/custom_snack_bar.dart';
import '../../../presentation/bloc/navigate_core_bloc/navigate_core_bloc.dart';
import '../../../paywall/data/feature_key.dart';
import '../../../utilities/routes.dart';


class PendingPhotoLibraryScreen extends StatefulWidget {
  const PendingPhotoLibraryScreen({super.key});

  @override
  State<PendingPhotoLibraryScreen> createState() => _PendingPhotoLibraryScreen();
}

class _PendingPhotoLibraryScreen extends State<PendingPhotoLibraryScreen> {
  final _logger = CustomLogger('PendingItemGridScreen');
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _logger.i('initState - initializing PendingPhotoLibraryScreen');
    context.read<PhotoLibraryBloc>().add(RequestLibraryPermission());
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

  FeatureKey _getFeatureKeyForState(NavigateCoreState state) {
    if (state is BronzeUploadItemDeniedState) return FeatureKey.uploadItemBronze;
    if (state is SilverUploadItemDeniedState) return FeatureKey.uploadItemSilver;
    if (state is GoldUploadItemDeniedState) return FeatureKey.uploadItemGold;
    return FeatureKey.uploadItemBronze;
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building PendingPhotoLibraryScreen');


    return MultiBlocListener(
        listeners: [
          BlocListener<PhotoLibraryBloc, PhotoLibraryState>(
            listener: (context, state) {
              if (state is PhotoLibraryMaxSelectionReached) {
                _logger.w('Max selection reached');
                CustomSnackbar(
                  message: S.of(context).maxPendingItemsSnackbar(state.maxAllowed),
                  theme: Theme.of(context),
                ).show(context);
              }
            },
          ),
          BlocListener<NavigateCoreBloc, NavigateCoreState>(
            listener: (context, state) {
              if (state is BronzeUploadItemDeniedState ||
                  state is SilverUploadItemDeniedState ||
                  state is GoldUploadItemDeniedState) {
                _logger.i('Upload access denied — navigating to payment');
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.payment, // Or AppRoutes.payment
                  arguments: {
                    'featureKey': _getFeatureKeyForState(state),
                    'isFromMyCloset': true,
                    'previousRoute': AppRoutes.myCloset,
                    'nextRoute': AppRoutes.pendingPhotoLibrary,
                  },
                );
              } else if (state is ItemAccessGrantedState) {
                final selectedAssets = context.read<PhotoLibraryBloc>().selectedImages;
                context.read<PhotoLibraryBloc>().add(UploadSelectedLibraryImages(assets: selectedAssets));
              }
            },
          ),
        ],
        child: BlocBuilder<PhotoLibraryBloc, PhotoLibraryState>(
      builder: (context, state) {
        _logger.i('PhotoLibraryBloc state: ${state.runtimeType}');

        // Show loading indicator while loading or uploading
        if (state is PhotoLibraryLoadingImages || state is PhotoLibraryUploading) {
          _logger.d('Showing ClosetProgressIndicator');
          return const ClosetProgressIndicator();
        }

        // When images are loaded, display them
        if (state is PhotoLibraryImagesLoaded) {
          final assets = state.images;          // All fetched images
          final selectedAssets = state.selectedImages; // Currently selected

          _logger.i('Loaded ${assets.length} assets');
          for (final asset in assets) {
            _logger.d('Loaded assetId: ${asset.id}');
          }

          // Convert the AssetEntity objects to ClosetItemMinimal for grid display
          return FutureBuilder<List<ClosetItemMinimal>>(
            future: _convertAssetsToItems(assets),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                _logger.d('Waiting for asset conversion');
                return const ClosetProgressIndicator();
              }

              final items = snapshot.data!;
              _logger.i('Converted ${items.length} assets to ClosetItemMinimal');

              return Column(
                children: [
                  const SizedBox(height: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      child: PendingInteractiveItemGrid(
                        scrollController: _scrollController,
                        items: items,
                        assets: assets,
                        crossAxisCount: 3,
                        onAction: () {}, // Optional: Add action if needed
                        enablePricePerWear: false,
                        enableItemName: false,
                        isOutfit: false,
                        isLocalImage: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ThemedElevatedButton(
                      onPressed: selectedAssets.isNotEmpty
                          ? () {
                        _logger.i('Upload button clicked');
                        // Dispatch the upload event with the currently selected images
                        context.read<PhotoLibraryBloc>().add(
                          UploadSelectedLibraryImages(assets: selectedAssets),
                        );
                      }
                          : null, // Disable button if no images are selected
                      text: S.of(context).upload,
                    ),
                  ),
                ],
              );
            },
          );
        }

        // Fallback if no relevant state is found
        _logger.w('Unhandled state in PhotoLibraryBloc: $state');
        return const ClosetProgressIndicator();
      },
        )
    );
  }
}
